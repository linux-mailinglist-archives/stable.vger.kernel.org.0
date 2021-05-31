Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 052213962C1
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231845AbhEaPAy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 11:00:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:50542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234450AbhEaO7o (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:59:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 646F660FDA;
        Mon, 31 May 2021 14:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469699;
        bh=fSTD4FuGqLEfK8x+eTDVG+Dp7DHSuice4wy0O09xT3g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xz0O7K2tUr6Y7vnd+CL8WhktnTOoxHPCVenpnExmkcZmn1FAgNgubmnGIGEbX+frx
         Kp4avAFG4KjgcOoU4OhdWBy06SptDadAcaQLmqGPudug34pq/l7lf8w6ikwFMuvVUk
         Cu/Pl8JqsvRTEh/wLJvNRDuGaZIKUk6JdG9bv9vg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 286/296] thermal/drivers/qcom: Fix error code in adc_tm5_get_dt_channel_data()
Date:   Mon, 31 May 2021 15:15:41 +0200
Message-Id: <20210531130713.331981212@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 5d8db38ad7660e4d78f4e2a63f14336f31f07a63 ]

Return -EINVAL when args is invalid instead of 'ret' which is set to
zero by a previous successful call to a function.

Fixes: ca66dca5eda6 ("thermal: qcom: add support for adc-tm5 PMIC thermal monitor")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20210527092640.2070555-1-yangyingliang@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/qcom/qcom-spmi-adc-tm5.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thermal/qcom/qcom-spmi-adc-tm5.c b/drivers/thermal/qcom/qcom-spmi-adc-tm5.c
index b460b56e981c..232fd0b33325 100644
--- a/drivers/thermal/qcom/qcom-spmi-adc-tm5.c
+++ b/drivers/thermal/qcom/qcom-spmi-adc-tm5.c
@@ -441,7 +441,7 @@ static int adc_tm5_get_dt_channel_data(struct adc_tm5_chip *adc_tm,
 
 	if (args.args_count != 1 || args.args[0] >= ADC5_MAX_CHANNEL) {
 		dev_err(dev, "%s: invalid ADC channel number %d\n", name, chan);
-		return ret;
+		return -EINVAL;
 	}
 	channel->adc_channel = args.args[0];
 
-- 
2.30.2



