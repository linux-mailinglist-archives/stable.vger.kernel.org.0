Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DCAD20D898
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387592AbgF2TkR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:40:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:47656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387561AbgF2TkQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:40:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9946224889;
        Mon, 29 Jun 2020 15:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444385;
        bh=654HW8eN8nsMN0MFjbKPYJtwu9+JQYwiQahStHN2M24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UHUQeUih0fvyqCMWpuIyksUzpKV8GWS1QhOlsBJ2Sw6lIhbgPwNtZOlxzVcpTFjJw
         vL0WpGXBQkR2Qt0DbA2PDewFYG866wHh11m1lCn/fNnqgv+UPKxYPYg2LT1g0NYHOr
         +ZAzZY4pCOd9VwnGzthYx6Rq85qxXN5HlBFQXLBM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Lindgren <tony@atomide.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 062/178] bus: ti-sysc: Ignore clockactivity unless specified as a quirk
Date:   Mon, 29 Jun 2020 11:23:27 -0400
Message-Id: <20200629152523.2494198-63-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629152523.2494198-1-sashal@kernel.org>
References: <20200629152523.2494198-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.50-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.50-rc1
X-KernelTest-Deadline: 2020-07-01T15:25+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 08b91dd6e547467fad61a7c201ff71080d7ad65a ]

We must ignore the clockactivity bit for most modules and not set it
unless specified for the module with SYSC_QUIRK_USE_CLOCKACT. Otherwise
the interface clock can be automatically gated constantly causing
unexpected performance issues.

Fixes: ae9ae12e9daa ("bus: ti-sysc: Handle clockactivity for enable and disable")
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/ti-sysc.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/bus/ti-sysc.c b/drivers/bus/ti-sysc.c
index c088c6f4adcff..553c0e2796217 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -880,10 +880,13 @@ static int sysc_enable_module(struct device *dev)
 	regbits = ddata->cap->regbits;
 	reg = sysc_read(ddata, ddata->offsets[SYSC_SYSCONFIG]);
 
-	/* Set CLOCKACTIVITY, we only use it for ick */
+	/*
+	 * Set CLOCKACTIVITY, we only use it for ick. And we only configure it
+	 * based on the SYSC_QUIRK_USE_CLOCKACT flag, not based on the hardware
+	 * capabilities. See the old HWMOD_SET_DEFAULT_CLOCKACT flag.
+	 */
 	if (regbits->clkact_shift >= 0 &&
-	    (ddata->cfg.quirks & SYSC_QUIRK_USE_CLOCKACT ||
-	     ddata->cfg.sysc_val & BIT(regbits->clkact_shift)))
+	    (ddata->cfg.quirks & SYSC_QUIRK_USE_CLOCKACT))
 		reg |= SYSC_CLOCACT_ICK << regbits->clkact_shift;
 
 	/* Set SIDLE mode */
-- 
2.25.1

