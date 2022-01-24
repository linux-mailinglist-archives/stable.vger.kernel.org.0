Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 295C2499997
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:45:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352058AbiAXVg2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:36:28 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:45328 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1453726AbiAXVar (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:30:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 111F0B8121C;
        Mon, 24 Jan 2022 21:30:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32098C340E5;
        Mon, 24 Jan 2022 21:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059842;
        bh=4RrGe9wr71LWzqgF6XSoStKYKDl1f6S25cA8dDWoh9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jRPM2FuHY04uZC7yGPukn7yAC5fiDjhNda7nD9KfDfDI2J7zB2J0vn1izh6OaI0ty
         wwKdhPG8uND/Yx+Rwvk6AgGdm/zxWkbxBEThQZ6Cib53iCRbSO4AtDXr5BiAlz1izb
         26zGy3ln77P0/AT6ROxULvbt0n2eoCtAiOYTkuew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephan Gerhold <stephan@gerhold.net>,
        Georgi Djakov <djakov@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0752/1039] interconnect: qcom: rpm: Prevent integer overflow in rate
Date:   Mon, 24 Jan 2022 19:42:21 +0100
Message-Id: <20220124184150.612174636@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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
index ef7999a08c8bf..8114295a83129 100644
--- a/drivers/interconnect/qcom/icc-rpm.c
+++ b/drivers/interconnect/qcom/icc-rpm.c
@@ -239,6 +239,7 @@ static int qcom_icc_set(struct icc_node *src, struct icc_node *dst)
 	rate = max(sum_bw, max_peak_bw);
 
 	do_div(rate, qn->buswidth);
+	rate = min_t(u64, rate, LONG_MAX);
 
 	if (qn->rate == rate)
 		return 0;
-- 
2.34.1



