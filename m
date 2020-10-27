Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C662629BC9D
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:41:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1810178AbgJ0Qe2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:34:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:49364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1802447AbgJ0Psn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:48:43 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1DFF207C3;
        Tue, 27 Oct 2020 15:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813723;
        bh=uZxgvXsTuZEVeZJFJRaqPTQhvh18DilCfGbVejeewDM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ur/o7GbrGUGV8m/opldCkcJW07c3Q7a7fDIqahgreTPQ5fMTAm+PBFTljBwX7Q8A3
         Dg8ipWvrZuGvydJQwME0YW0TNzRvOivLSNX6NQ6bZ/x5/pEHiXRnrnbJBoIHuHaGY3
         13zUpY+7I/rR4KTfHdqHOuXJMlmrsSRgRJ/kHrTs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 617/757] ARM: OMAP2+: Restore MPU power domain if cpu_cluster_pm_enter() fails
Date:   Tue, 27 Oct 2020 14:54:27 +0100
Message-Id: <20201027135519.486840962@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 8f04aea048d56f3e39a7e543939450246542a6fc ]

If cpu_cluster_pm_enter() fails, we need to set MPU power domain back
to enabled to prevent the next WFI from potentially triggering an
undesired MPU power domain state change.

We already do this for omap_enter_idle_smp() but are missing it for
omap_enter_idle_coupled().

Fixes: 55be2f50336f ("ARM: OMAP2+: Handle errors for cpu_pm")
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap2/cpuidle44xx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/cpuidle44xx.c b/arch/arm/mach-omap2/cpuidle44xx.c
index 6f5f89711f256..a92d277f81a08 100644
--- a/arch/arm/mach-omap2/cpuidle44xx.c
+++ b/arch/arm/mach-omap2/cpuidle44xx.c
@@ -174,8 +174,10 @@ static int omap_enter_idle_coupled(struct cpuidle_device *dev,
 		 */
 		if (mpuss_can_lose_context) {
 			error = cpu_cluster_pm_enter();
-			if (error)
+			if (error) {
+				omap_set_pwrdm_state(mpu_pd, PWRDM_POWER_ON);
 				goto cpu_cluster_pm_out;
+			}
 		}
 	}
 
-- 
2.25.1



