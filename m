Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4B32E40D2
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:58:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440576AbgL1OPF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:15:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:49964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440574AbgL1OPE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:15:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1633207AB;
        Mon, 28 Dec 2020 14:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164864;
        bh=gTLGYdL02XKs0yupekkeEsMyPVc7aRlL9Kj0z/zmwxA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sbh/KWow4Z5Ih+bY4kcm0Jd9qpUNe71FPr22TPGdf7zOTjM7JzLeXjuXNDBxgK8W2
         KYtLl83rm4ufJ44y9jA+XNAnMqggisQztowX/xk59BbhBLx/vu5WpmttrQsuKrjj4H
         S3+bhGpgikrzJ8z9b9VX85c2GAOm4xTNZmA2VQYI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 327/717] cpufreq: st: Add missing MODULE_DEVICE_TABLE
Date:   Mon, 28 Dec 2020 13:45:25 +0100
Message-Id: <20201228125036.686052143@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

[ Upstream commit 183747ab52654eb406fc6b5bfb40806b75d31811 ]

This patch adds missing MODULE_DEVICE_TABLE definition which generates
correct modalias for automatic loading of this cpufreq driver when it is
compiled as an external module.

Signed-off-by: Pali Rohár <pali@kernel.org>
Fixes: ab0ea257fc58d ("cpufreq: st: Provide runtime initialised driver for ST's platforms")
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/sti-cpufreq.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/cpufreq/sti-cpufreq.c b/drivers/cpufreq/sti-cpufreq.c
index 4ac6fb23792a0..c40d3d7d4ea43 100644
--- a/drivers/cpufreq/sti-cpufreq.c
+++ b/drivers/cpufreq/sti-cpufreq.c
@@ -292,6 +292,13 @@ register_cpufreq_dt:
 }
 module_init(sti_cpufreq_init);
 
+static const struct of_device_id __maybe_unused sti_cpufreq_of_match[] = {
+	{ .compatible = "st,stih407" },
+	{ .compatible = "st,stih410" },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, sti_cpufreq_of_match);
+
 MODULE_DESCRIPTION("STMicroelectronics CPUFreq/OPP driver");
 MODULE_AUTHOR("Ajitpal Singh <ajitpal.singh@st.com>");
 MODULE_AUTHOR("Lee Jones <lee.jones@linaro.org>");
-- 
2.27.0



