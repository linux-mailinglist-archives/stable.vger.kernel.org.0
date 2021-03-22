Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03325344331
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:51:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231983AbhCVMtE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:49:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:42924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231920AbhCVMqz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:46:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2632619A4;
        Mon, 22 Mar 2021 12:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416978;
        bh=UJHtBs8vtxO77pjJFBEnrU/VMMrYWuoFF0eQunXUOgs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pghaZ8MGPBkHH/pZ2sKNzQGoOf1NCnDQ7jVL3PlWCjXgXjLmEyMTd7dGBfr75ucTm
         qRPinX/r1bqDIGAYlwOjwisWiCsCmFQnz5W5d7aJEKbI7HAMiXLG6OoznaDRL1iNEn
         mLgg746oW+52agKgfYFdy+UVuaFNqz3rm0fbTDuY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Albrieux <jonathan.albrieux@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 40/60] iio:adc:qcom-spmi-vadc: add default scale to LR_MUX2_BAT_ID channel
Date:   Mon, 22 Mar 2021 13:28:28 +0100
Message-Id: <20210322121923.710310914@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121922.372583154@linuxfoundation.org>
References: <20210322121922.372583154@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Albrieux <jonathan.albrieux@gmail.com>

commit 7d200b283aa049fcda0d43dd6e03e9e783d2799c upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/qcom-spmi-vadc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/adc/qcom-spmi-vadc.c
+++ b/drivers/iio/adc/qcom-spmi-vadc.c
@@ -598,7 +598,7 @@ static const struct vadc_channels vadc_c
 	VADC_CHAN_NO_SCALE(P_MUX16_1_3, 1)
 
 	VADC_CHAN_NO_SCALE(LR_MUX1_BAT_THERM, 0)
-	VADC_CHAN_NO_SCALE(LR_MUX2_BAT_ID, 0)
+	VADC_CHAN_VOLT(LR_MUX2_BAT_ID, 0, SCALE_DEFAULT)
 	VADC_CHAN_NO_SCALE(LR_MUX3_XO_THERM, 0)
 	VADC_CHAN_NO_SCALE(LR_MUX4_AMUX_THM1, 0)
 	VADC_CHAN_NO_SCALE(LR_MUX5_AMUX_THM2, 0)


