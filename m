Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C93EC593703
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233529AbiHOTG7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:06:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245169AbiHOTF1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:05:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 735394E61D;
        Mon, 15 Aug 2022 11:34:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B634BB8106E;
        Mon, 15 Aug 2022 18:34:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B2A5C433C1;
        Mon, 15 Aug 2022 18:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588457;
        bh=NsVV9z4D0is7Au0wRGSembh84gMxq1mQKQCq5GKTZn0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wv/WH8yZSevlB/tfcROOCMr8tE8zbpqabGziU/Rq6YWLBiagrK2QPu8qsHcM5XS3e
         ca5kjSeFSm7N4NdLqACUbhw0Cbslr3+snm6W31m7Fm5M4XtQ1J+gOj98MQd6PwISJI
         0wmiIXn2kxhB5AxofDdLL1R0eem9K85MwDZn1gD8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 409/779] mtd: partitions: Fix refcount leak in parse_redboot_of
Date:   Mon, 15 Aug 2022 20:00:53 +0200
Message-Id: <20220815180354.765046404@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 9f7e62815cf3cbbcb1b8cb21649fb4dfdb3aa016 ]

of_get_child_by_name() returns a node pointer with refcount
incremented, we should use of_node_put() on it when not need anymore.
Add missing of_node_put() to avoid refcount leak.

Fixes: 237960880960 ("mtd: partitions: redboot: seek fis-index-block in the right node")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20220526110652.64849-1-linmq006@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/parsers/redboot.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mtd/parsers/redboot.c b/drivers/mtd/parsers/redboot.c
index feb44a573d44..a16b42a88581 100644
--- a/drivers/mtd/parsers/redboot.c
+++ b/drivers/mtd/parsers/redboot.c
@@ -58,6 +58,7 @@ static void parse_redboot_of(struct mtd_info *master)
 		return;
 
 	ret = of_property_read_u32(npart, "fis-index-block", &dirblock);
+	of_node_put(npart);
 	if (ret)
 		return;
 
-- 
2.35.1



