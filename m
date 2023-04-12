Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C30236DEDF6
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbjDLIiz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:38:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230226AbjDLIik (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:38:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D2D57ABA
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:37:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C022662FEC
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:35:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4C50C433D2;
        Wed, 12 Apr 2023 08:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681288553;
        bh=zAWVvsQVFHc9ubP8aNPZh/Bwz3WiDRikp0z37JdnMXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fcC5ElGG/U0IbEEmRlvyq5tWz7lkflqx1XxEjuST7x7QumETbun28koBEtzIW4h8a
         PGEN4Gu95zOSBIyBpAr/CnONshzpimMD26XJ/W9iIYUp52SADNNfI0p8HwghMK9c9v
         ksmHFiJPrN7hu/MXiqSHaV8bFs3gwaNBKS0RTA70=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 06/93] soc: sifive: ccache: fix missing free_irq() in error path in sifive_ccache_init()
Date:   Wed, 12 Apr 2023 10:33:07 +0200
Message-Id: <20230412082823.310163512@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082823.045155996@linuxfoundation.org>
References: <20230412082823.045155996@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 756344e7cb1afbb87da8705c20384dddd0dea233 ]

Add missing free_irq() before return error from sifive_ccache_init().

Fixes: a967a289f169 ("RISC-V: sifive_l2_cache: Add L2 cache controller driver for SiFive SoCs")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/sifive/sifive_ccache.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/sifive/sifive_ccache.c b/drivers/soc/sifive/sifive_ccache.c
index 335e4303fb928..4b9d0a656a979 100644
--- a/drivers/soc/sifive/sifive_ccache.c
+++ b/drivers/soc/sifive/sifive_ccache.c
@@ -234,7 +234,7 @@ static int __init sifive_ccache_init(void)
 				 NULL);
 		if (rc) {
 			pr_err("Could not request IRQ %d\n", g_irq[i]);
-			goto err_unmap;
+			goto err_free_irq;
 		}
 	}
 
@@ -248,6 +248,9 @@ static int __init sifive_ccache_init(void)
 #endif
 	return 0;
 
+err_free_irq:
+	while (--i >= 0)
+		free_irq(g_irq[i], NULL);
 err_unmap:
 	iounmap(ccache_base);
 	return rc;
-- 
2.39.2



