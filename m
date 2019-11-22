Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B313106DAF
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:02:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730705AbfKVLCJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:02:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:55450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731263AbfKVLCG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 06:02:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68FB120748;
        Fri, 22 Nov 2019 11:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420525;
        bh=X5sJjt7VX5Mvcc/8ptrKXV0mBAzqXlsQCrJR8uhh/lg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w+80LoY/xAH7luGDGuR6c1Ts3nPjPVnBTSEJ5UH+R2ruMEWQYIVGHAab+C17loN3w
         /y+KOrsaasQnlAjTcmb1B9LDSvGmiNNLYFlbpqW67TWfG+FEXh9JEckECjHZUoInz0
         qyERY6EBLOyMeAdoZtDhD1S81lfe7TjUNGm6CcDg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sibi Sankar <sibis@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 137/220] remoteproc: qcom: q6v5: Fix a race condition on fatal crash
Date:   Fri, 22 Nov 2019 11:28:22 +0100
Message-Id: <20191122100922.661150215@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



