Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E14F4173B8
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 14:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344862AbhIXM7d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 08:59:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:52818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345487AbhIXM61 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:58:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A50A7610CF;
        Fri, 24 Sep 2021 12:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487947;
        bh=17tC2RO3Hgl7tXLde7DcsuqTn8ERBowRwjH+oeOf1As=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GD/GKuAmLoUraTg+MA1iOkIEAsoqy00PjBIre7iDFIMjoazxufLmcBtJvc2zxEJ1p
         0Zx7a7JqateN6RCi/uocvpUOVN85YooWtUjVFo47DRWx+zs/n5aN5eqMqFJrJCkB94
         fe3JO3RE0OTNY+5qVdnapHRmkYaspEXlV40DKCv8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthias Kaehlcke <mka@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 5.14 023/100] thermal/drivers/qcom/spmi-adc-tm5: Dont abort probing if a sensor is not used
Date:   Fri, 24 Sep 2021 14:43:32 +0200
Message-Id: <20210924124342.217331621@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124341.214446495@linuxfoundation.org>
References: <20210924124341.214446495@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthias Kaehlcke <mka@chromium.org>

commit 70ee251ded6ba24c15537f4abb8a318e233d0d1a upstream.

adc_tm5_register_tzd() registers the thermal zone sensors for all
channels of the thermal monitor. If the registration of one channel
fails the function skips the processing of the remaining channels
and returns an error, which results in _probe() being aborted.

One of the reasons the registration could fail is that none of the
thermal zones is using the channel/sensor, which hardly is a critical
error (if it is an error at all). If this case is detected emit a
warning and continue with processing the remaining channels.

Fixes: ca66dca5eda6 ("thermal: qcom: add support for adc-tm5 PMIC thermal monitor")
Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
Reported-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20210823134726.1.I1dd23ddf77e5b3568625d80d6827653af071ce19@changeid
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/qcom/qcom-spmi-adc-tm5.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/thermal/qcom/qcom-spmi-adc-tm5.c
+++ b/drivers/thermal/qcom/qcom-spmi-adc-tm5.c
@@ -359,6 +359,12 @@ static int adc_tm5_register_tzd(struct a
 							   &adc_tm->channels[i],
 							   &adc_tm5_ops);
 		if (IS_ERR(tzd)) {
+			if (PTR_ERR(tzd) == -ENODEV) {
+				dev_warn(adc_tm->dev, "thermal sensor on channel %d is not used\n",
+					 adc_tm->channels[i].channel);
+				continue;
+			}
+
 			dev_err(adc_tm->dev, "Error registering TZ zone for channel %d: %ld\n",
 				adc_tm->channels[i].channel, PTR_ERR(tzd));
 			return PTR_ERR(tzd);


