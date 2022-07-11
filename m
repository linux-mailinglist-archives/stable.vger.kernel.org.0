Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8699A56FE09
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 12:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234225AbiGKKDn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 06:03:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234503AbiGKKDR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 06:03:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2697866B98;
        Mon, 11 Jul 2022 02:29:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1BEDB6136E;
        Mon, 11 Jul 2022 09:29:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24A93C34115;
        Mon, 11 Jul 2022 09:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531748;
        bh=rwYDbgqaFOd3kXq3xU6cJ8+EHfNvjHPitVnigsdKzyM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bRc8d9oLy2b5IkvCvSuzevc52EvTISpGBLMZ2l4i0L1lV4G9UPvOQ+GpH5UuNtFyS
         c3N99aES9ch8vfIjZhzhhXPoyBvhWo9lQHGnYoebO3BHqLod+Nz3aXvUL2wHDy7nvV
         ptOJ7QKtHW9sacVNzqNsiQr6Qn/0slmF+jq3sLn0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Robinson <pbrobinson@gmail.com>,
        Fabio Estevam <festevam@gmail.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15 215/230] dmaengine: imx-sdma: Allow imx8m for imx7 FW revs
Date:   Mon, 11 Jul 2022 11:07:51 +0200
Message-Id: <20220711090610.201031861@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
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

From: Peter Robinson <pbrobinson@gmail.com>

commit a7cd3cf0b2e5aaacfe5e02c472bd28e98e640be7 upstream.

The revision of the imx-sdma IP that is in the i.MX8M series is the
same is that as that in the i.MX7 series but the imx7d MODULE_FIRMWARE
directive is wrapped in a condiditional which means it's not defined
when built for aarch64 SOC_IMX8M platforms and hence you get the
following errors when the driver loads on imx8m devices:

imx-sdma 302c0000.dma-controller: Direct firmware load for imx/sdma/sdma-imx7d.bin failed with error -2
imx-sdma 302c0000.dma-controller: external firmware not found, using ROM firmware

Add the SOC_IMX8M into the check so the firmware can load on i.MX8.

Fixes: 1474d48bd639 ("arm64: dts: imx8mq: Add SDMA nodes")
Fixes: 941acd566b18 ("dmaengine: imx-sdma: Only check ratio on parts that support 1:1")
Signed-off-by: Peter Robinson <pbrobinson@gmail.com>
Cc: stable@vger.kernel.org   # v5.2+
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Link: https://lore.kernel.org/r/20220606161034.3544803-1-pbrobinson@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/imx-sdma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -2264,7 +2264,7 @@ MODULE_DESCRIPTION("i.MX SDMA driver");
 #if IS_ENABLED(CONFIG_SOC_IMX6Q)
 MODULE_FIRMWARE("imx/sdma/sdma-imx6q.bin");
 #endif
-#if IS_ENABLED(CONFIG_SOC_IMX7D)
+#if IS_ENABLED(CONFIG_SOC_IMX7D) || IS_ENABLED(CONFIG_SOC_IMX8M)
 MODULE_FIRMWARE("imx/sdma/sdma-imx7d.bin");
 #endif
 MODULE_LICENSE("GPL");


