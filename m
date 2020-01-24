Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5EA4147CA0
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:53:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388256AbgAXJxX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:53:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:55892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388253AbgAXJxW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:53:22 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A78020718;
        Fri, 24 Jan 2020 09:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579859602;
        bh=HWtDXZ3+dqRs3dDrGqX3euHlCduGl/P0Y+Y6lUpLJJA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2HYjvZ8PrE2YU8+pmkgz9xY3Jm/KVb9rIVDVRtzhq4T04ncAXiTXdqxuQi4qjnq4b
         QtBxBsVACoz27obJ4Es0YFTTFF2uzQ95oIa7bHv5PfDGQMRtwSEkUt/8Z9R8CzwQD2
         d+64T+2jZzZnIzxmCX+0NN6OyD+658oO8kRM+i2E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Walmsley <paul@pwsan.com>,
        Tero Kristo <t-kristo@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 153/343] ARM: OMAP2+: Fix potentially uninitialized return value for _setup_reset()
Date:   Fri, 24 Jan 2020 10:29:31 +0100
Message-Id: <20200124092940.108150453@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 45c8f2ef4e23c..9274a484c6a39 100644
--- a/arch/arm/mach-omap2/omap_hwmod.c
+++ b/arch/arm/mach-omap2/omap_hwmod.c
@@ -2530,7 +2530,7 @@ static void _setup_iclk_autoidle(struct omap_hwmod *oh)
  */
 static int _setup_reset(struct omap_hwmod *oh)
 {
-	int r;
+	int r = 0;
 
 	if (oh->_state != _HWMOD_STATE_INITIALIZED)
 		return -EINVAL;
-- 
2.20.1



