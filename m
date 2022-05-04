Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 498AB51A73F
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 18:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353891AbiEDRDP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354757AbiEDQ7F (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 12:59:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB52473A7;
        Wed,  4 May 2022 09:50:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 31F74617A6;
        Wed,  4 May 2022 16:50:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A323C385A5;
        Wed,  4 May 2022 16:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683056;
        bh=0gbObnZmdg3X7SuNnDkKe2xmN0OZyeNQ6+n97FTWnzE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r2pFBxZFjm+FPAzmh2SjD0krVccVhM3TpPns/TRYHnTCP0rnKW2wsOt5Aaaal6BNa
         hyA6wfdi9z6w0bGoUm7oqKtCH6nQa4hILmjVKDsz4E11EXF+dd5iGl5umOQ5oFi1kS
         FB+QOUE8Fk9vNHfqT9nFxJVnrAWNGTKbihX0OV8w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oleksandr Ocheretnyi <oocheret@cisco.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 060/129] mtd: fix part field data corruption in mtd_info
Date:   Wed,  4 May 2022 18:44:12 +0200
Message-Id: <20220504153026.005036487@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153021.299025455@linuxfoundation.org>
References: <20220504153021.299025455@linuxfoundation.org>
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
index 157357ec1441..fc41fecfe44f 100644
--- a/include/linux/mtd/mtd.h
+++ b/include/linux/mtd/mtd.h
@@ -388,10 +388,8 @@ struct mtd_info {
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



