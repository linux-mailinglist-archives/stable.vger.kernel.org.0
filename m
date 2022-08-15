Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE6E594A9D
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352019AbiHPAFJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:05:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356941AbiHPADX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:03:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4263D16CCD8;
        Mon, 15 Aug 2022 13:25:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 913B261093;
        Mon, 15 Aug 2022 20:25:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DB65C433C1;
        Mon, 15 Aug 2022 20:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595106;
        bh=mNt363BbGutMZ6Z1x/izic53rXbcVevjrO2YbmfMRKs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b6mE249Y0aUZ1F39Rko0G7Nq+EAoANxZe7rYMax2dQDC3T7kGLjYJfbsR0a7AaqZZ
         3rkYTo+h3lIq0K5AN8gy9ZKb2AN42dHgA/KvDU8lv1RUjqFbSn3nTTeJaMnnOJdqap
         Wx7WM8KauVdUoUYzXpu5XzoaNQYisR24+Z87GZ90=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0616/1157] dmaengine: dw: dmamux: Fix build without CONFIG_OF
Date:   Mon, 15 Aug 2022 19:59:32 +0200
Message-Id: <20220815180504.291639276@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit 7811f2e7fd6a30d96eaa1fccf57b07694a8cad27 ]

When built without OF support, of_match_node() expands to NULL, which
produces the following output:
>> drivers/dma/dw/rzn1-dmamux.c:105:34: warning: unused variable 'rzn1_dmac_match' [-Wunused-const-variable]
   static const struct of_device_id rzn1_dmac_match[] = {

One way to silence the warning is to enclose the structure definition
with an #ifdef CONFIG_OF/#endif block.

Fixes: 134d9c52fca2 ("dmaengine: dw: dmamux: Introduce RZN1 DMA router support")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20220609141455.300879-2-miquel.raynal@bootlin.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dw/rzn1-dmamux.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/dma/dw/rzn1-dmamux.c b/drivers/dma/dw/rzn1-dmamux.c
index 0ce4fb58185e..f9912c3dd4d7 100644
--- a/drivers/dma/dw/rzn1-dmamux.c
+++ b/drivers/dma/dw/rzn1-dmamux.c
@@ -102,10 +102,12 @@ static void *rzn1_dmamux_route_allocate(struct of_phandle_args *dma_spec,
 	return ERR_PTR(ret);
 }
 
+#ifdef CONFIG_OF
 static const struct of_device_id rzn1_dmac_match[] = {
 	{ .compatible = "renesas,rzn1-dma" },
 	{}
 };
+#endif
 
 static int rzn1_dmamux_probe(struct platform_device *pdev)
 {
-- 
2.35.1



