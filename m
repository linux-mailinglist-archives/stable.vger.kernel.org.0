Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16ED3FA538
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:22:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729197AbfKMCVq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 21:21:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:44036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727717AbfKMBxx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:53:53 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 526F8222D3;
        Wed, 13 Nov 2019 01:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610033;
        bh=X5sJjt7VX5Mvcc/8ptrKXV0mBAzqXlsQCrJR8uhh/lg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C4PURUdLaShGfvr/ikq63edB+gpoEZIlvVdVTplKVhzOdZLjvQPhH0VA6Yb6eCIm6
         JSXPrXqHt8Q3zYHx1HuDnMO9zjLd+BDHjKswihNirHg+uS2XdL2Q5FBXToPc1yreoL
         LrAbJaGj56RH36NFf8EjfMndaacshPS3t9NJtm8A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sibi Sankar <sibis@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-remoteproc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 126/209] remoteproc: qcom: q6v5: Fix a race condition on fatal crash
Date:   Tue, 12 Nov 2019 20:49:02 -0500
Message-Id: <20191113015025.9685-126-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sibi Sankar <sibis@codeaurora.org>

[ Upstream commit d3ae96c0e6b042a883927493351b2af6ee05e92c ]

Currently with GLINK_SSR enabled each fatal crash results in servicing
a crash from wdog as well. This is due to a race that occurs in setting
the running flag in the shutdown path. Fix this by moving the running
flag to the end of fatal interrupt handler.

Crash Logs:
qcom-q6v5-pil 4080000.remoteproc: fatal error without message
remoteproc remoteproc0: crash detected in 4080000.remoteproc: type fatal
	error
remoteproc remoteproc0: handling crash #1 in 4080000.remoteproc
remoteproc remoteproc0: recovering 4080000.remoteproc
qcom-q6v5-pil 4080000.remoteproc: watchdog without message
remoteproc remoteproc0: crash detected in 4080000.remoteproc: type watchdog
remoteproc:glink-edge: intent request timed out
qcom_glink_ssr remoteproc:glink-edge.glink_ssr.-1.-1: failed to send
	cleanup message
qcom_glink_ssr remoteproc:glink-edge.glink_ssr.-1.-1: timeout waiting
	for cleanup done message
qcom-q6v5-pil 4080000.remoteproc: timed out on wait
qcom-q6v5-pil 4080000.remoteproc: port failed halt
remoteproc remoteproc0: stopped remote processor 4080000.remoteproc
qcom-q6v5-pil 4080000.remoteproc: MBA booted, loading mpss
remoteproc remoteproc0: remote processor 4080000.remoteproc is now up
remoteproc remoteproc0: handling crash #2 in 4080000.remoteproc
remoteproc remoteproc0: recovering 4080000.remoteproc
qcom-q6v5-pil 4080000.remoteproc: port failed halt
remoteproc remoteproc0: stopped remote processor 4080000.remoteproc
qcom-q6v5-pil 4080000.remoteproc: MBA booted, loading mpss
remoteproc remoteproc0: remote processor 4080000.remoteproc is now up

Suggested-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sibi Sankar <sibis@codeaurora.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_q6v5.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/remoteproc/qcom_q6v5.c b/drivers/remoteproc/qcom_q6v5.c
index 602af839421de..0d33e3079f0dc 100644
--- a/drivers/remoteproc/qcom_q6v5.c
+++ b/drivers/remoteproc/qcom_q6v5.c
@@ -84,6 +84,7 @@ static irqreturn_t q6v5_fatal_interrupt(int irq, void *data)
 	else
 		dev_err(q6v5->dev, "fatal error without message\n");
 
+	q6v5->running = false;
 	rproc_report_crash(q6v5->rproc, RPROC_FATAL_ERROR);
 
 	return IRQ_HANDLED;
@@ -150,8 +151,6 @@ int qcom_q6v5_request_stop(struct qcom_q6v5 *q6v5)
 {
 	int ret;
 
-	q6v5->running = false;
-
 	qcom_smem_state_update_bits(q6v5->state,
 				    BIT(q6v5->stop_bit), BIT(q6v5->stop_bit));
 
-- 
2.20.1

