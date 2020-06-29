Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0631020E667
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404197AbgF2VrJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:47:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:56794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726737AbgF2Sfo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B6EB24697;
        Mon, 29 Jun 2020 15:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593443992;
        bh=sNOLCnFtuh+m9OD5TG/Nxs/Wi7fC45jIgNmN74LSD68=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xVEWP8b0vlhVIVqeevq5CPd8itlP4SPQmY8b7Da82wwqCw1Z4NIZWMYPBFkQA0ofH
         NvAZg6CRcLZ3tbjz9IRXCerji041kHGiofvxw4dwP4PDoHdpc3mCBr40l+oos865+A
         lSX9Ck+vGSSH4fbUKekEH8yBsVj6f3m8tIlAeipo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Lindgren <tony@atomide.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 096/265] bus: ti-sysc: Fix uninitialized framedonetv_irq
Date:   Mon, 29 Jun 2020 11:15:29 -0400
Message-Id: <20200629151818.2493727-97-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 085bc0e576a4bf53b67a917c54908f299a2fb949 ]

We are currently only setting the framedonetv_irq disabled for the SoCs
that don't have it. But we are never setting it enabled for the SoCs that
have it. Let's initialized it to true by default.

Fixes: 7324a7a0d5e2 ("bus: ti-sysc: Implement display subsystem reset quirk")
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/ti-sysc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/bus/ti-sysc.c b/drivers/bus/ti-sysc.c
index 4f640a635ded1..db9541f385055 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -1552,7 +1552,7 @@ static u32 sysc_quirk_dispc(struct sysc *ddata, int dispc_offset,
 	bool lcd_en, digit_en, lcd2_en = false, lcd3_en = false;
 	const int lcd_en_mask = BIT(0), digit_en_mask = BIT(1);
 	int manager_count;
-	bool framedonetv_irq;
+	bool framedonetv_irq = true;
 	u32 val, irq_mask = 0;
 
 	switch (sysc_soc->soc) {
@@ -1569,6 +1569,7 @@ static u32 sysc_quirk_dispc(struct sysc *ddata, int dispc_offset,
 		break;
 	case SOC_AM4:
 		manager_count = 1;
+		framedonetv_irq = false;
 		break;
 	case SOC_UNKNOWN:
 	default:
-- 
2.25.1

