Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE0E8226958
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732535AbgGTQBa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:01:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:34922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732523AbgGTQB3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:01:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 157AC20684;
        Mon, 20 Jul 2020 16:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260888;
        bh=pqH4Z4h+Y7+f/SBsItam4q6GwuJmWL+jss7UQgIFMZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SbtYHUWRUxRG1qFE3FOfW7DGkUaU/91Ev4jwrMLT9/WcTTSAXXH2akFI2f18aUesY
         KMXHfFYAgaaj9hYKCxkSQE33OnNhvu/q+lVzPL4ctVyVOVktRDbM09oDHO2zDjXpCa
         frq+F7edUlwcUpviWyhVbrYm5nvgqvga61POH+r8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 101/215] bus: ti-sysc: Do not disable on suspend for no-idle
Date:   Mon, 20 Jul 2020 17:36:23 +0200
Message-Id: <20200720152825.011824505@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit a55de412228cc5a2b4bf8d2a09849898102633e2 ]

If we have "ti,no-idle" specified for a module we must not disable
the the module on suspend to keep things backwards compatible.

Fixes: 386cb76681ca ("bus: ti-sysc: Handle missed no-idle property in addition to no-idle-on-init")
Reported-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/ti-sysc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/bus/ti-sysc.c b/drivers/bus/ti-sysc.c
index 76e749dfc4fd1..f8bc052cd853a 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -1245,7 +1245,8 @@ static int __maybe_unused sysc_noirq_suspend(struct device *dev)
 
 	ddata = dev_get_drvdata(dev);
 
-	if (ddata->cfg.quirks & SYSC_QUIRK_LEGACY_IDLE)
+	if (ddata->cfg.quirks &
+	    (SYSC_QUIRK_LEGACY_IDLE | SYSC_QUIRK_NO_IDLE))
 		return 0;
 
 	return pm_runtime_force_suspend(dev);
@@ -1257,7 +1258,8 @@ static int __maybe_unused sysc_noirq_resume(struct device *dev)
 
 	ddata = dev_get_drvdata(dev);
 
-	if (ddata->cfg.quirks & SYSC_QUIRK_LEGACY_IDLE)
+	if (ddata->cfg.quirks &
+	    (SYSC_QUIRK_LEGACY_IDLE | SYSC_QUIRK_NO_IDLE))
 		return 0;
 
 	return pm_runtime_force_resume(dev);
-- 
2.25.1



