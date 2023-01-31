Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 990A068298E
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 10:53:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230354AbjAaJw7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 04:52:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230480AbjAaJw6 (ORCPT
        <rfc822;Stable@vger.kernel.org>); Tue, 31 Jan 2023 04:52:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B74BC61A3
        for <Stable@vger.kernel.org>; Tue, 31 Jan 2023 01:52:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D7736B81ACC
        for <Stable@vger.kernel.org>; Tue, 31 Jan 2023 09:52:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D589C4339B;
        Tue, 31 Jan 2023 09:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675158771;
        bh=ONCKEiRJ8ulZkZQNhNE40vJNiYCF+KeUkPwZZ9amfTQ=;
        h=Subject:To:From:Date:From;
        b=0oCIhpSsGCf+R4rs8/WjUjR6TfHN2Zwiryo5YLAp2wll5UAEAf3vzkHvmtYlzHpCX
         bVdGKyb9q0yME/UQrlUHOO1tQP7Eh6UCVMsMQ2CVD9dwbjcPa5ihwBMID8lfZzIGCH
         hB+OmnswAE02jhAk46KCyvQYEN10sMI6GLvpvrIo=
Subject: patch "iio: imx8qxp-adc: fix irq flood when call imx8qxp_adc_read_raw()" added to char-misc-linus
To:     Frank.Li@nxp.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, cai.huoqing@linux.dev, haibo.chen@nxp.com
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 31 Jan 2023 10:52:38 +0100
Message-ID: <1675158758170107@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: imx8qxp-adc: fix irq flood when call imx8qxp_adc_read_raw()

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 0fc3562a993c3dc41d1177b3983d9300d0db1d4d Mon Sep 17 00:00:00 2001
From: Frank Li <Frank.Li@nxp.com>
Date: Thu, 1 Dec 2022 09:01:10 -0500
Subject: iio: imx8qxp-adc: fix irq flood when call imx8qxp_adc_read_raw()

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


