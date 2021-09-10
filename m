Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1A4F40637E
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240270AbhIJAr5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:47:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:49468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234763AbhIJAYN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:24:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2057611BD;
        Fri, 10 Sep 2021 00:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233383;
        bh=ISzSvm4C6f8lHwgz+pYqhFqWZ8I8lIYQVNbzl6VCqi8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a5MczqkOv12YbXLfY+4UES3v7pDgRRD1dU8G94Qd7iHMhMSSSq8cmGwT+rXcnRt8m
         /Mc5s268pWlkd4bq/VhK/PT4cHc6Dwo8ij7i3AjMTp9pA7ak+OKVDc6lo8YwQdVEGG
         SXzdnBzR4qHIbj0mmYPkiBqRnjFTdqblDnis4MdC9yTyX+tkSDKHCeVBeekwsJKqcZ
         c/OCy7kpOFXYakCa3kchfeiujZE+xS8+oa/y7aZfAPpxb/FCay3TBPYBBG8gDranT1
         D9gGC0CIMdD1WlhldaPoPg9/h6oG9vWZgjPW7j2M8bKPBvhhDX2gYas3mVI8MIe7Or
         biPeLnvF+4N8w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>, Sasha Levin <sashal@kernel.org>,
        xen-devel@lists.xenproject.org
Subject: [PATCH AUTOSEL 4.19 22/25] xen: remove stray preempt_disable() from PV AP startup code
Date:   Thu,  9 Sep 2021 20:22:30 -0400
Message-Id: <20210910002234.176125-22-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910002234.176125-1-sashal@kernel.org>
References: <20210910002234.176125-1-sashal@kernel.org>
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
index 41fd4c123165..7b6e56703bb9 100644
--- a/arch/x86/xen/smp_pv.c
+++ b/arch/x86/xen/smp_pv.c
@@ -59,7 +59,6 @@ static void cpu_bringup(void)
 
 	cpu_init();
 	touch_softlockup_watchdog();
-	preempt_disable();
 
 	/* PVH runs in ring 0 and allows us to do native syscalls. Yay! */
 	if (!xen_feature(XENFEAT_supervisor_mode_kernel)) {
-- 
2.30.2

