Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CDDB328DCE
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241331AbhCATRl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:17:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:39788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241245AbhCATNK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:13:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 50B5864E01;
        Mon,  1 Mar 2021 17:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620861;
        bh=GcKFfhkIssTDuutgdeiy/2SdhXQg4dTqydtIE0iJoTc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b4Gvat4+p3QKSfc+PFt5s/68TbXdXUJxBJ8U5VURpiEYrbGnpa9I//0lwnwelTNjG
         RQvCBtpNFj6IkHYMGpFrMxrXcjsrq6MhKvIKcDZsOUTR5hsz28Vq79igMFNGYLU7gu
         0c4s+vKTF3pwrKQeuexy3teaPo8p1XJjrPqhjOow=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Merlijn Wajer <merlijn@wizzup.org>,
        Tony Lindgren <tony@atomide.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 307/775] power: supply: cpcap: Add missing IRQF_ONESHOT to fix regression
Date:   Mon,  1 Mar 2021 17:07:55 +0100
Message-Id: <20210301161216.792564425@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit e62333e26be649bfc3c167b9f2bbca38b92332c5 ]

Commit 25d76fed7ffe ("phy: cpcap-usb: Use IRQF_ONESHOT") started causing
errors loading phy-cpcap-usb driver:

cpcap_battery cpcap_battery.0: failed to register power supply
genirq: Flags mismatch irq 211. 00002080 (se0conn) vs. 00000080 (se0conn)
cpcap-usb-phy cpcap-usb-phy.0: could not get irq se0conn: -16

Let's fix this by adding the missing IRQF_ONESHOT to also cpcap-battery
and cpcap-charger drivers.

Fixes: 25d76fed7ffe ("phy: cpcap-usb: Use IRQF_ONESHOT")
Reported-by: Merlijn Wajer <merlijn@wizzup.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/cpcap-battery.c | 2 +-
 drivers/power/supply/cpcap-charger.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/power/supply/cpcap-battery.c b/drivers/power/supply/cpcap-battery.c
index 295611b3b15e9..7a974b5bd9dd1 100644
--- a/drivers/power/supply/cpcap-battery.c
+++ b/drivers/power/supply/cpcap-battery.c
@@ -666,7 +666,7 @@ static int cpcap_battery_init_irq(struct platform_device *pdev,
 
 	error = devm_request_threaded_irq(ddata->dev, irq, NULL,
 					  cpcap_battery_irq_thread,
-					  IRQF_SHARED,
+					  IRQF_SHARED | IRQF_ONESHOT,
 					  name, ddata);
 	if (error) {
 		dev_err(ddata->dev, "could not get irq %s: %i\n",
diff --git a/drivers/power/supply/cpcap-charger.c b/drivers/power/supply/cpcap-charger.c
index c0d452e3dc8b0..804ac7f84c301 100644
--- a/drivers/power/supply/cpcap-charger.c
+++ b/drivers/power/supply/cpcap-charger.c
@@ -708,7 +708,7 @@ static int cpcap_usb_init_irq(struct platform_device *pdev,
 
 	error = devm_request_threaded_irq(ddata->dev, irq, NULL,
 					  cpcap_charger_irq_thread,
-					  IRQF_SHARED,
+					  IRQF_SHARED | IRQF_ONESHOT,
 					  name, ddata);
 	if (error) {
 		dev_err(ddata->dev, "could not get irq %s: %i\n",
-- 
2.27.0



