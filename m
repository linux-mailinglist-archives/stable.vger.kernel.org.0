Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3152164A239
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:51:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233046AbiLLNva (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:51:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233136AbiLLNvL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:51:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0CF9140E9
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:50:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 60BB061068
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FDA6C433EF;
        Mon, 12 Dec 2022 13:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670853017;
        bh=bl3qD9WEy/2JrTV9dkMx9ZUTzm+oZEHVzW3ig8T9N9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RBQENUyLhLR45+gJYlRXX3cdkMPc2KYz3+vjgTq1vzi6bWSeNfocqDfP7arWZxTPb
         t8n3ibMeJlGzRYGvsmxz9KMrt34euaUhz7UCCZDhnW0Lvv7NlKW9oH+7vj8MIJ6CR+
         w8vG1SPJcMySQJQQg9gCeVuwMnyxqjVhK7drUCEQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jisheng Zhang <jszhang@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 40/49] net: stmmac: fix "snps,axi-config" node property parsing
Date:   Mon, 12 Dec 2022 14:19:18 +0100
Message-Id: <20221212130915.662036674@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130913.666185567@linuxfoundation.org>
References: <20221212130913.666185567@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jisheng Zhang <jszhang@kernel.org>

[ Upstream commit 61d4f140943c47c1386ed89f7260e00418dfad9d ]

In dt-binding snps,dwmac.yaml, some properties under "snps,axi-config"
node are named without "axi_" prefix, but the driver expects the
prefix. Since the dt-binding has been there for a long time, we'd
better make driver match the binding for compatibility.

Fixes: afea03656add ("stmmac: rework DMA bus setting and introduce new platform AXI structure")
Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Link: https://lore.kernel.org/r/20221202161739.2203-1-jszhang@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 9762e687fc73..9e040eb629ed 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -114,10 +114,10 @@ static struct stmmac_axi *stmmac_axi_setup(struct platform_device *pdev)
 
 	axi->axi_lpi_en = of_property_read_bool(np, "snps,lpi_en");
 	axi->axi_xit_frm = of_property_read_bool(np, "snps,xit_frm");
-	axi->axi_kbbe = of_property_read_bool(np, "snps,axi_kbbe");
-	axi->axi_fb = of_property_read_bool(np, "snps,axi_fb");
-	axi->axi_mb = of_property_read_bool(np, "snps,axi_mb");
-	axi->axi_rb =  of_property_read_bool(np, "snps,axi_rb");
+	axi->axi_kbbe = of_property_read_bool(np, "snps,kbbe");
+	axi->axi_fb = of_property_read_bool(np, "snps,fb");
+	axi->axi_mb = of_property_read_bool(np, "snps,mb");
+	axi->axi_rb =  of_property_read_bool(np, "snps,rb");
 
 	if (of_property_read_u32(np, "snps,wr_osr_lmt", &axi->axi_wr_osr_lmt))
 		axi->axi_wr_osr_lmt = 1;
-- 
2.35.1



