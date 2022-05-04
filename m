Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 597EC51A785
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240526AbiEDRG0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:06:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356073AbiEDREw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:04:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B16DF50443;
        Wed,  4 May 2022 09:53:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D5A461505;
        Wed,  4 May 2022 16:53:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 832F5C385AF;
        Wed,  4 May 2022 16:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683224;
        bh=9aKAC8bS8AJ3whFajoPKnF48+NJXL61N8ubLWROvCB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AXQAiLyxgnnqP4hw+6yurCBMlIK5zCk50T86KI6xc7PLZ1ZiCFxg9i7rzy5jgy7QA
         hMME7zrfAoyoODPsvGOho4bdcEEZUaeED+wHg+gJt9DH28I82XLHjqrPWkLSxcUQkp
         nY77Zhq7hQfqxgaEqYFTjQonVd/YwJdNt24leEx8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oleksandr Ocheretnyi <oocheret@cisco.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 077/177] mtd: fix part field data corruption in mtd_info
Date:   Wed,  4 May 2022 18:44:30 +0200
Message-Id: <20220504153059.970955149@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153053.873100034@linuxfoundation.org>
References: <20220504153053.873100034@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleksandr Ocheretnyi <oocheret@cisco.com>

[ Upstream commit 37c5f9e80e015d0df17d0c377c18523002986851 ]

Commit 46b5889cc2c5 ("mtd: implement proper partition handling")
started using "mtd_get_master_ofs()" in mtd callbacks to determine
memory offsets by means of 'part' field from mtd_info, what previously
was smashed accessing 'master' field in the mtd_set_dev_defaults() method.
That provides wrong offset what causes hardware access errors.

Just make 'part', 'master' as separate fields, rather than using
union type to avoid 'part' data corruption when mtd_set_dev_defaults()
is called.

Fixes: 46b5889cc2c5 ("mtd: implement proper partition handling")
Signed-off-by: Oleksandr Ocheretnyi <oocheret@cisco.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20220417184649.449289-1-oocheret@cisco.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mtd/mtd.h | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/linux/mtd/mtd.h b/include/linux/mtd/mtd.h
index 88227044fc86..8a2c60235ebb 100644
--- a/include/linux/mtd/mtd.h
+++ b/include/linux/mtd/mtd.h
@@ -394,10 +394,8 @@ struct mtd_info {
 	/* List of partitions attached to this MTD device */
 	struct list_head partitions;
 
-	union {
-		struct mtd_part part;
-		struct mtd_master master;
-	};
+	struct mtd_part part;
+	struct mtd_master master;
 };
 
 static inline struct mtd_info *mtd_get_master(struct mtd_info *mtd)
-- 
2.35.1



