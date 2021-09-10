Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B777940635B
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242681AbhIJAr1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:47:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:49044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234237AbhIJAXi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:23:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0018610A3;
        Fri, 10 Sep 2021 00:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233348;
        bh=B3+dapiH7ZqT0zNupi/gPeO0vO8/7rY0FDBnebcTA1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ESZg825KvV5tGsZ0dn3orW51NieRVTYim0DUkFfMPslxm/8Q7zPksDkuSpsuaO2UN
         WMAD3uthyDVN4+1/OrCYmGj7DBflKywPW8bRZD/FaTHYHeXbx3AqawJdQGmmY6uJX/
         QDC3Bkb0sKH/on9vNNviNaeF75Xw0nKLe8+tXOHgoU24R18YWsEDS6/QIcfMxqB05l
         hy0F1Jx0wzzKn/dQZ9WBiLsxdR4z7ZBLxPD5EgySjysfQFHb5NH/10nkp7rWkhova2
         AJmS9/47AZNj8OFC7alwNAyo5otn1j7OGKo6bTP8Va9LqHlb0wuuwXpht5bPZ+w2Ig
         bvDZhaAQhTyHQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>, Sasha Levin <sashal@kernel.org>,
        xen-devel@lists.xenproject.org
Subject: [PATCH AUTOSEL 5.4 34/37] xen: remove stray preempt_disable() from PV AP startup code
Date:   Thu,  9 Sep 2021 20:21:39 -0400
Message-Id: <20210910002143.175731-34-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910002143.175731-1-sashal@kernel.org>
References: <20210910002143.175731-1-sashal@kernel.org>
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
index 0cebe5db691d..b87c6403b5bd 100644
--- a/arch/x86/xen/smp_pv.c
+++ b/arch/x86/xen/smp_pv.c
@@ -61,7 +61,6 @@ static void cpu_bringup(void)
 	cr4_init();
 	cpu_init();
 	touch_softlockup_watchdog();
-	preempt_disable();
 
 	/* PVH runs in ring 0 and allows us to do native syscalls. Yay! */
 	if (!xen_feature(XENFEAT_supervisor_mode_kernel)) {
-- 
2.30.2

