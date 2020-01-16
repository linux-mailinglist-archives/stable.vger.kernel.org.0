Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC1813E3AA
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388580AbgAPRDK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:03:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:57108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388576AbgAPRDJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:03:09 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B26D24685;
        Thu, 16 Jan 2020 17:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194189;
        bh=q1gIVPVMHO9I/akf7uP5X2iGRY12EkSsbiYExikhfrM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bw+0VcF+WE8y3A279qZXG6gaOB/E4ov69Fyz68jcMaF5Tlf3cukfeK+drFmQTkgUE
         VFDAw+xqjh94uWkSMEAssV0qjZHHy6/Zbxvl8tB9bPrSROIyhH4cmwTTzyUnvwVGZO
         Nkxaq00pWPkYhHFW/vODnGiqhuNY/rLfZ8sPs7NU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Lindgren <tony@atomide.com>, Paul Walmsley <paul@pwsan.com>,
        Tero Kristo <t-kristo@ti.com>, Sasha Levin <sashal@kernel.org>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 261/671] ARM: OMAP2+: Fix potentially uninitialized return value for _setup_reset()
Date:   Thu, 16 Jan 2020 11:52:50 -0500
Message-Id: <20200116165940.10720-144-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165940.10720-1-sashal@kernel.org>
References: <20200116165940.10720-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 7f0d078667a494466991aa7133f49594f32ff6a2 ]

Commit 747834ab8347 ("ARM: OMAP2+: hwmod: revise hardreset behavior") made
the call to _enable() conditional based on no oh->rst_lines_cnt. This
caused the return value to be potentially uninitialized. Curiously we see
no compiler warnings for this, probably as this gets inlined.

We call _setup_reset() from _setup() and only _setup_postsetup() if the
return value is zero. Currently the return value can be uninitialized for
cases where oh->rst_lines_cnt is set and HWMOD_INIT_NO_RESET is not set.

Fixes: 747834ab8347 ("ARM: OMAP2+: hwmod: revise hardreset behavior")
Cc: Paul Walmsley <paul@pwsan.com>
Cc: Tero Kristo <t-kristo@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap2/omap_hwmod.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/omap_hwmod.c b/arch/arm/mach-omap2/omap_hwmod.c
index ec3789ba17b8..a8269f0a87ce 100644
--- a/arch/arm/mach-omap2/omap_hwmod.c
+++ b/arch/arm/mach-omap2/omap_hwmod.c
@@ -2430,7 +2430,7 @@ static void _setup_iclk_autoidle(struct omap_hwmod *oh)
  */
 static int _setup_reset(struct omap_hwmod *oh)
 {
-	int r;
+	int r = 0;
 
 	if (oh->_state != _HWMOD_STATE_INITIALIZED)
 		return -EINVAL;
-- 
2.20.1

