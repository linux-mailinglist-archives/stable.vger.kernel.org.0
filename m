Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D58556FA54
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231566AbiGKJQL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:16:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231829AbiGKJO4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:14:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08143C01;
        Mon, 11 Jul 2022 02:10:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A8A9611E9;
        Mon, 11 Jul 2022 09:10:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E0CCC34115;
        Mon, 11 Jul 2022 09:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530650;
        bh=Pe/pZg5QJzD1CRbxDtgY8MMA8jBKbD4EC2ecOckql1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oYeYdqbe0zvw3x2Y8PNeRi/cAnntbjtEaua8gr9HPNMHHc5MGn2bbAlCJMjDtH2Xd
         0rr3DloQ1SBEsU94Lb1Pf/D1dkGm1fgKjW/XNrUMiKvJeq8uU5HfYjINN5Zo8jsLBx
         59WDmsgpq5LwRp/lKqcVBmVunTzaEdJ+RkW5mxAs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Robinson <pbrobinson@gmail.com>,
        Fabio Estevam <festevam@gmail.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.4 29/38] dmaengine: imx-sdma: Allow imx8m for imx7 FW revs
Date:   Mon, 11 Jul 2022 11:07:11 +0200
Message-Id: <20220711090539.587270102@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090538.722676354@linuxfoundation.org>
References: <20220711090538.722676354@linuxfoundation.org>
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
@@ -2208,7 +2208,7 @@ MODULE_DESCRIPTION("i.MX SDMA driver");
 #if IS_ENABLED(CONFIG_SOC_IMX6Q)
 MODULE_FIRMWARE("imx/sdma/sdma-imx6q.bin");
 #endif
-#if IS_ENABLED(CONFIG_SOC_IMX7D)
+#if IS_ENABLED(CONFIG_SOC_IMX7D) || IS_ENABLED(CONFIG_SOC_IMX8M)
 MODULE_FIRMWARE("imx/sdma/sdma-imx7d.bin");
 #endif
 MODULE_LICENSE("GPL");


