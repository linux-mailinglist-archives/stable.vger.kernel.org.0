Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBB192E6590
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:03:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393195AbgL1QCz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:02:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:58734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390189AbgL1N3v (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:29:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 10E5F20719;
        Mon, 28 Dec 2020 13:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162150;
        bh=iRrV4hdtPk4eKcU5Iq0aDCH+J2vIQi9boaG6kCWLdjY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WFfdILJQEJ9HwC/ANifKqEWrPqGAsNAhmjT/einTitP/Q3O73yAC89EhCP1uQmVu8
         npfxuTP1tDRc+iQfMqr0L8uoQyDnJo74+ytOqs5V+vHn1fp0TE5L+vncyfP9KIMwZ5
         2t2XHunq86sh41u90sORVErDFNdaQBHN0vCdQSXU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 204/346] cpufreq: highbank: Add missing MODULE_DEVICE_TABLE
Date:   Mon, 28 Dec 2020 13:48:43 +0100
Message-Id: <20201228124929.652978169@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

[ Upstream commit 9433777a6e0aae27468d3434b75cd51bb88ff711 ]

This patch adds missing MODULE_DEVICE_TABLE definition which generates
correct modalias for automatic loading of this cpufreq driver when it is
compiled as an external module.

Signed-off-by: Pali Rohár <pali@kernel.org>
Fixes: 6754f556103be ("cpufreq / highbank: add support for highbank cpufreq")
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/highbank-cpufreq.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/cpufreq/highbank-cpufreq.c b/drivers/cpufreq/highbank-cpufreq.c
index 1608f7105c9f8..ad743f2f31e78 100644
--- a/drivers/cpufreq/highbank-cpufreq.c
+++ b/drivers/cpufreq/highbank-cpufreq.c
@@ -104,6 +104,13 @@ out_put_node:
 }
 module_init(hb_cpufreq_driver_init);
 
+static const struct of_device_id __maybe_unused hb_cpufreq_of_match[] = {
+	{ .compatible = "calxeda,highbank" },
+	{ .compatible = "calxeda,ecx-2000" },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, hb_cpufreq_of_match);
+
 MODULE_AUTHOR("Mark Langsdorf <mark.langsdorf@calxeda.com>");
 MODULE_DESCRIPTION("Calxeda Highbank cpufreq driver");
 MODULE_LICENSE("GPL");
-- 
2.27.0



