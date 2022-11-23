Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC84635594
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:20:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237361AbiKWJTZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:19:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237388AbiKWJTK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:19:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07B203C6E8
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:19:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8853B81EE5
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:19:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC9A8C433C1;
        Wed, 23 Nov 2022 09:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195147;
        bh=lsMZlUJMxJ34d4h3ylrNWXuIl2QPP7Luvb1IvJC3YwI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=URX9R7ZRzRb8qPN0MU7CbjMiCDrwm5yVrtDS13AZlryld/TN+Y1YriV6715BcXeP6
         Nihxu/5akxIyETlSSWZOMLdLRUD7SurQ6J21TQ0JucX9ftq8tadQbL7mszwGsKjfsI
         PYYSVmW37IUCJV9PTQfsGq82u5KvaTLar3MCJELw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, stable <stable@kernel.org>,
        =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5.4 131/156] serial: 8250_lpss: Configure DMA also w/o DMA filter
Date:   Wed, 23 Nov 2022 09:51:28 +0100
Message-Id: <20221123084602.667330997@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
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

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

commit 1bfcbe5805d0cfc83c3544dcd01e0a282c1f6790 upstream.

If the platform doesn't use DMA device filter (as is the case with
Elkhart Lake), whole lpss8250_dma_setup() setup is skipped. This
results in skipping also *_maxburst setup which is undesirable.
Refactor lpss8250_dma_setup() to configure DMA even if filter is not
setup.

Cc: stable <stable@kernel.org>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20221108121952.5497-3-ilpo.jarvinen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_lpss.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/drivers/tty/serial/8250/8250_lpss.c
+++ b/drivers/tty/serial/8250/8250_lpss.c
@@ -258,8 +258,13 @@ static int lpss8250_dma_setup(struct lps
 	struct dw_dma_slave *rx_param, *tx_param;
 	struct device *dev = port->port.dev;
 
-	if (!lpss->dma_param.dma_dev)
+	if (!lpss->dma_param.dma_dev) {
+		dma = port->dma;
+		if (dma)
+			goto out_configuration_only;
+
 		return 0;
+	}
 
 	rx_param = devm_kzalloc(dev, sizeof(*rx_param), GFP_KERNEL);
 	if (!rx_param)
@@ -270,16 +275,18 @@ static int lpss8250_dma_setup(struct lps
 		return -ENOMEM;
 
 	*rx_param = lpss->dma_param;
-	dma->rxconf.src_maxburst = lpss->dma_maxburst;
-
 	*tx_param = lpss->dma_param;
-	dma->txconf.dst_maxburst = lpss->dma_maxburst;
 
 	dma->fn = lpss8250_dma_filter;
 	dma->rx_param = rx_param;
 	dma->tx_param = tx_param;
 
 	port->dma = dma;
+
+out_configuration_only:
+	dma->rxconf.src_maxburst = lpss->dma_maxburst;
+	dma->txconf.dst_maxburst = lpss->dma_maxburst;
+
 	return 0;
 }
 


