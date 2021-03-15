Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB2F733C003
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 16:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231877AbhCOPf1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 11:35:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:60234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233306AbhCOPfY (ORCPT <rfc822;Stable@vger.kernel.org>);
        Mon, 15 Mar 2021 11:35:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F3A864E22;
        Mon, 15 Mar 2021 15:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615822524;
        bh=ptPHRzaWvWWH6PZ5DiyJLJCK0bkiFD5iPOPD7Z+RMiI=;
        h=Subject:To:From:Date:From;
        b=1G2W1A2PnykFCLCNzYE5OrWLLGJZMUwLVosHUoSWeyR0NgpG6hYREQiwGEHdaZjoi
         R7j7MJWCHPtO3rAvPPtnHtOwuHUFQheHrJCvOqy30xhfZfdbousZsh10Lm8Wd6uGKG
         MRuFxTnww0wfWyDXtt/JPVegIU0X3WlcCfa44ZTo=
Subject: patch "iio:adc:qcom-spmi-vadc: add default scale to LR_MUX2_BAT_ID channel" added to staging-linus
To:     jonathan.albrieux@gmail.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, bjorn.andersson@linaro.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Mar 2021 16:35:21 +0100
Message-ID: <1615822521519@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio:adc:qcom-spmi-vadc: add default scale to LR_MUX2_BAT_ID channel

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 7d200b283aa049fcda0d43dd6e03e9e783d2799c Mon Sep 17 00:00:00 2001
From: Jonathan Albrieux <jonathan.albrieux@gmail.com>
Date: Wed, 13 Jan 2021 16:18:07 +0100
Subject: iio:adc:qcom-spmi-vadc: add default scale to LR_MUX2_BAT_ID channel

Checking at both msm8909-pm8916.dtsi and msm8916.dtsi from downstream
it is indicated that "batt_id" channel has to be scaled with the default
function:

	chan@31 {
		label = "batt_id";
		reg = <0x31>;
		qcom,decimation = <0>;
		qcom,pre-div-channel-scaling = <0>;
		qcom,calibration-type = "ratiometric";
		qcom,scale-function = <0>;
		qcom,hw-settle-time = <0xb>;
		qcom,fast-avg-setup = <0>;
	};

Change LR_MUX2_BAT_ID scaling accordingly.

Signed-off-by: Jonathan Albrieux <jonathan.albrieux@gmail.com>
Acked-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Fixes: 7c271eea7b8a ("iio: adc: spmi-vadc: Changes to support different scaling")
Link: https://lore.kernel.org/r/20210113151808.4628-2-jonathan.albrieux@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/qcom-spmi-vadc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/qcom-spmi-vadc.c b/drivers/iio/adc/qcom-spmi-vadc.c
index b0388f8a69f4..7e7d408452ec 100644
--- a/drivers/iio/adc/qcom-spmi-vadc.c
+++ b/drivers/iio/adc/qcom-spmi-vadc.c
@@ -598,7 +598,7 @@ static const struct vadc_channels vadc_chans[] = {
 	VADC_CHAN_NO_SCALE(P_MUX16_1_3, 1)
 
 	VADC_CHAN_NO_SCALE(LR_MUX1_BAT_THERM, 0)
-	VADC_CHAN_NO_SCALE(LR_MUX2_BAT_ID, 0)
+	VADC_CHAN_VOLT(LR_MUX2_BAT_ID, 0, SCALE_DEFAULT)
 	VADC_CHAN_NO_SCALE(LR_MUX3_XO_THERM, 0)
 	VADC_CHAN_NO_SCALE(LR_MUX4_AMUX_THM1, 0)
 	VADC_CHAN_NO_SCALE(LR_MUX5_AMUX_THM2, 0)
-- 
2.30.2


