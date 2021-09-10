Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 481704061A9
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240987AbhIJAnX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:43:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:44094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232694AbhIJATG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:19:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4099611BF;
        Fri, 10 Sep 2021 00:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233076;
        bh=L1NascCO+RqV2EXe7WgTVOgru+3jDwh0a4LVdwaZR/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=arFFHtckENB/uaxPUEVv7ZUYqMWFts/MhT7jppWwPMHuIbxB74zrMtB87W0Ghq9ft
         ioBgf5/NtxpeX0JpCEJwCqr0B2oHqC8G+0qV1px9BWYrX9qjx+/uvO+5wA/1PKoEEt
         Jfy9T0Ur7fqA+1Z3lDyM49Hwi5epZNQDckSf7SzW1ofg2qfqzHw/Ts2V1TwXhkrHcN
         SkHx/4itK+7zPdE0VP2Qx/4Mu0tNhyef9H6LzL6+EfMiKrJe+VdtaHeUHbjxJdfi8f
         v1vjyiRG8+mijL7rP7ClsUnnapzz+yItaqq6zqAdZu0iWK37SWqkiLPl45BTwMHg4L
         ENRKxc5nK3AZQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>, Sasha Levin <sashal@kernel.org>,
        xen-devel@lists.xenproject.org
Subject: [PATCH AUTOSEL 5.14 85/99] xen: remove stray preempt_disable() from PV AP startup code
Date:   Thu,  9 Sep 2021 20:15:44 -0400
Message-Id: <20210910001558.173296-85-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001558.173296-1-sashal@kernel.org>
References: <20210910001558.173296-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

[ Upstream commit 58e636039b512697554b579c2bb23774061877f5 ]

In cpu_bringup() there is a call of preempt_disable() without a paired
preempt_enable(). This is not needed as interrupts are off initially.
Additionally this will result in early boot messages like:

BUG: scheduling while atomic: swapper/1/0/0x00000002

Signed-off-by: Juergen Gross <jgross@suse.com>
Link: https://lore.kernel.org/r/20210825113158.11716-1-jgross@suse.com
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/xen/smp_pv.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/xen/smp_pv.c b/arch/x86/xen/smp_pv.c
index c2ac319f11a4..96afadf9878e 100644
--- a/arch/x86/xen/smp_pv.c
+++ b/arch/x86/xen/smp_pv.c
@@ -64,7 +64,6 @@ static void cpu_bringup(void)
 	cr4_init();
 	cpu_init();
 	touch_softlockup_watchdog();
-	preempt_disable();
 
 	/* PVH runs in ring 0 and allows us to do native syscalls. Yay! */
 	if (!xen_feature(XENFEAT_supervisor_mode_kernel)) {
-- 
2.30.2

