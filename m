Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADC7C499CAF
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355124AbiAXWGa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:06:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1578722AbiAXWDV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:03:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F72DC036BFC;
        Mon, 24 Jan 2022 12:41:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F1673615D8;
        Mon, 24 Jan 2022 20:41:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5309C340E5;
        Mon, 24 Jan 2022 20:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056911;
        bh=Ht43UxNFhdmKPNTqhSR/k8BwiUdZV1+y0lRQ40YRnCE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w1TNF/TV7M/9UdSfiYjkrqU/g7x/D1wPuSNm+V/Xxmq1HTvO2D8w7eP8uzlba5xEo
         mHgwHO/MoeEE2nEmvwB6MezXyyPueir1q8IWHkXWRa/Jr9f4ye6trJnRJ4/IDbZrjX
         iRJR2FKS/SdU0bUUvwvyWMO3DoQlrCfGalBLAbg8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephan Gerhold <stephan@gerhold.net>,
        Georgi Djakov <djakov@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 639/846] interconnect: qcom: rpm: Prevent integer overflow in rate
Date:   Mon, 24 Jan 2022 19:42:36 +0100
Message-Id: <20220124184123.072750615@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephan Gerhold <stephan@gerhold.net>

[ Upstream commit a7d9436a6c85fcb8843c910fd323dcd7f839bf63 ]

Using icc-rpm on ARM32 currently results in clk_set_rate() errors during
boot, e.g. "bus clk_set_rate error: -22". This is very similar to commit
7381e27b1e56 ("interconnect: qcom: msm8974: Prevent integer overflow in rate")
where the u64 is converted to a signed long during clock rate rounding,
resulting in an overflow on 32-bit platforms.

Let's fix it similarly by making sure that the rate does not exceed
LONG_MAX. Such high clock rates will surely result in the maximum
frequency of the bus anyway.

Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Link: https://lore.kernel.org/r/20211206114542.45325-1-stephan@gerhold.net
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/qcom/icc-rpm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/interconnect/qcom/icc-rpm.c b/drivers/interconnect/qcom/icc-rpm.c
index 54de49ca7808a..ddf1805ded0c0 100644
--- a/drivers/interconnect/qcom/icc-rpm.c
+++ b/drivers/interconnect/qcom/icc-rpm.c
@@ -68,6 +68,7 @@ static int qcom_icc_set(struct icc_node *src, struct icc_node *dst)
 	rate = max(sum_bw, max_peak_bw);
 
 	do_div(rate, qn->buswidth);
+	rate = min_t(u64, rate, LONG_MAX);
 
 	if (qn->rate == rate)
 		return 0;
-- 
2.34.1



