Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DEA26DEDF4
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbjDLIio (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbjDLIib (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:38:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DC3872AB
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:37:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 73A0662883
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:35:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89393C433EF;
        Wed, 12 Apr 2023 08:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681288542;
        bh=QRlrZVrRVlY2Bb4V8al69Chpuhw3g4qOcsToB0TgspI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IcudV1Dx+HAQe7GBNcmax0/tdLWC2bTspApCQDylixx0iU5o4L0IgWIi+W7P/9Nzv
         caaS+5Omnc02Mpj2yVdxA3865wij7JxCCERIdoYB7/hEga/IDHz26GaBLh6cWyqcv2
         woYk1DB6eDxkfItCqQl75AbHe1N3AhTmh79bBmeU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zong Li <zong.li@sifive.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 02/93] soc: sifive: ccache: determine the cache level from dts
Date:   Wed, 12 Apr 2023 10:33:03 +0200
Message-Id: <20230412082823.145768544@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082823.045155996@linuxfoundation.org>
References: <20230412082823.045155996@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zong Li <zong.li@sifive.com>

[ Upstream commit 95f196f3212bbc258611c22865aef12b98304e1d ]

Composable cache could be L2 or L3 cache, use 'cache-level' property of
device node to determine the level.

Signed-off-by: Zong Li <zong.li@sifive.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/r/20220913061817.22564-4-zong.li@sifive.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Stable-dep-of: 73e770f08502 ("soc: sifive: ccache: fix missing iounmap() in error path in sifive_ccache_init()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/sifive/sifive_ccache.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/sifive/sifive_ccache.c b/drivers/soc/sifive/sifive_ccache.c
index 949b824e89adf..b361b661ea09a 100644
--- a/drivers/soc/sifive/sifive_ccache.c
+++ b/drivers/soc/sifive/sifive_ccache.c
@@ -38,6 +38,7 @@
 static void __iomem *ccache_base;
 static int g_irq[SIFIVE_CCACHE_MAX_ECCINTR];
 static struct riscv_cacheinfo_ops ccache_cache_ops;
+static int level;
 
 enum {
 	DIR_CORR = 0,
@@ -144,7 +145,7 @@ static const struct attribute_group *ccache_get_priv_group(struct cacheinfo
 							   *this_leaf)
 {
 	/* We want to use private group for composable cache only */
-	if (this_leaf->level == 2)
+	if (this_leaf->level == level)
 		return &priv_attr_group;
 	else
 		return NULL;
@@ -215,6 +216,9 @@ static int __init sifive_ccache_init(void)
 	if (!ccache_base)
 		return -ENOMEM;
 
+	if (of_property_read_u32(np, "cache-level", &level))
+		return -ENOENT;
+
 	intr_num = of_property_count_u32_elems(np, "interrupts");
 	if (!intr_num) {
 		pr_err("CCACHE: no interrupts property\n");
-- 
2.39.2



