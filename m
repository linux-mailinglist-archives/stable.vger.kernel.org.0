Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE3668D819
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:05:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232286AbjBGNFq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:05:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232163AbjBGNFU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:05:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 468433B0D3
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:05:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD277613E2
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:05:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7F25C4339B;
        Tue,  7 Feb 2023 13:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775101;
        bh=H/LupYvdUS0x6kEZJNiVzuw/Sy0/ep8lMySlGI4+KB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=euN4ni8c6McroOANfl9tLwpgb+pADAWdn57h/3iEg4W/kXD40kCM4ayPAswVz0D0U
         avCtk7WrfUEf/rfA+sXRhhcEmikTkGjkx+gma2YG9foipfH4I3c2IT8CJHz2f9dHC7
         ax4nsDS5Ix2/9Eiump83J9k3yrnHZ6BxXQAWDlG4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Frank Li <Frank.Li@nxp.com>,
        Cai Huoqing <cai.huoqing@linux.dev>,
        Haibo Chen <haibo.chen@nxp.com>, Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 136/208] iio: imx8qxp-adc: fix irq flood when call imx8qxp_adc_read_raw()
Date:   Tue,  7 Feb 2023 13:56:30 +0100
Message-Id: <20230207125640.594926550@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
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

From: Frank Li <Frank.Li@nxp.com>

commit 0fc3562a993c3dc41d1177b3983d9300d0db1d4d upstream.

irq flood happen when run
    cat /sys/bus/iio/devices/iio:device0/in_voltage1_raw

imx8qxp_adc_read_raw()
{
	...
	enable irq
	/* adc start */
	writel(1, adc->regs + IMX8QXP_ADR_ADC_SWTRIG);
	^^^^ trigger irq flood.
	wait_for_completion_interruptible_timeout();
	readl(adc->regs + IMX8QXP_ADR_ADC_RESFIFO);
	^^^^ clear irq here.
	...
}

There is only FIFO watermark interrupt at this ADC controller.
IRQ line will be assert until software read data from FIFO.
So IRQ flood happen during wait_for_completion_interruptible_timeout().

Move FIFO read into irq handle to avoid irq flood.

Fixes: 1e23dcaa1a9f ("iio: imx8qxp-adc: Add driver support for NXP IMX8QXP ADC")
Cc: stable@vger.kernel.org

Signed-off-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Cai Huoqing <cai.huoqing@linux.dev>
Reviewed-by: Haibo Chen <haibo.chen@nxp.com>
Link: https://lore.kernel.org/r/20221201140110.2653501-1-Frank.Li@nxp.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/imx8qxp-adc.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/adc/imx8qxp-adc.c b/drivers/iio/adc/imx8qxp-adc.c
index 36777b827165..f5a0fc9e64c5 100644
--- a/drivers/iio/adc/imx8qxp-adc.c
+++ b/drivers/iio/adc/imx8qxp-adc.c
@@ -86,6 +86,8 @@
 
 #define IMX8QXP_ADC_TIMEOUT		msecs_to_jiffies(100)
 
+#define IMX8QXP_ADC_MAX_FIFO_SIZE		16
+
 struct imx8qxp_adc {
 	struct device *dev;
 	void __iomem *regs;
@@ -95,6 +97,7 @@ struct imx8qxp_adc {
 	/* Serialise ADC channel reads */
 	struct mutex lock;
 	struct completion completion;
+	u32 fifo[IMX8QXP_ADC_MAX_FIFO_SIZE];
 };
 
 #define IMX8QXP_ADC_CHAN(_idx) {				\
@@ -238,8 +241,7 @@ static int imx8qxp_adc_read_raw(struct iio_dev *indio_dev,
 			return ret;
 		}
 
-		*val = FIELD_GET(IMX8QXP_ADC_RESFIFO_VAL_MASK,
-				 readl(adc->regs + IMX8QXP_ADR_ADC_RESFIFO));
+		*val = adc->fifo[0];
 
 		mutex_unlock(&adc->lock);
 		return IIO_VAL_INT;
@@ -265,10 +267,15 @@ static irqreturn_t imx8qxp_adc_isr(int irq, void *dev_id)
 {
 	struct imx8qxp_adc *adc = dev_id;
 	u32 fifo_count;
+	int i;
 
 	fifo_count = FIELD_GET(IMX8QXP_ADC_FCTRL_FCOUNT_MASK,
 			       readl(adc->regs + IMX8QXP_ADR_ADC_FCTRL));
 
+	for (i = 0; i < fifo_count; i++)
+		adc->fifo[i] = FIELD_GET(IMX8QXP_ADC_RESFIFO_VAL_MASK,
+				readl_relaxed(adc->regs + IMX8QXP_ADR_ADC_RESFIFO));
+
 	if (fifo_count)
 		complete(&adc->completion);
 
-- 
2.39.1



