Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70A096DEB0
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731448AbfGSEFI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:05:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:37324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728812AbfGSEFH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:05:07 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 947F6218B8;
        Fri, 19 Jul 2019 04:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509106;
        bh=vx2vWh9eODayEyi7NmcYmZ1q6GxdvboP6NB7tsl66xU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O7YSSNYxPTrEPWiahUId+KqxTkfNZO1zwiRoRCyL5YgNqvvKEHvM22WObxfks+/0a
         juNZL1xYBmFCKtWNN+qZRKqemOInDSds2QtEFfDDfPMc5ClrLOeTThNeMxLv9t53+B
         DisslQJy1x4PUoB9F2WyHZ6j1amga9rb+rF9tkyg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Lynch <nathanl@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.1 071/141] powerpc/rtas: retry when cpu offline races with suspend/migration
Date:   Fri, 19 Jul 2019 00:01:36 -0400
Message-Id: <20190719040246.15945-71-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719040246.15945-1-sashal@kernel.org>
References: <20190719040246.15945-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Lynch <nathanl@linux.ibm.com>

[ Upstream commit 9fb603050ffd94f8127df99c699cca2f575eb6a0 ]

The protocol for suspending or migrating an LPAR requires all present
processor threads to enter H_JOIN. So if we have threads offline, we
have to temporarily bring them up. This can race with administrator
actions such as SMT state changes. As of dfd718a2ed1f ("powerpc/rtas:
Fix a potential race between CPU-Offline & Migration"),
rtas_ibm_suspend_me() accounts for this, but errors out with -EBUSY
for what almost certainly is a transient condition in any reasonable
scenario.

Callers of rtas_ibm_suspend_me() already retry when -EAGAIN is
returned, and it is typical during a migration for that to happen
repeatedly for several minutes polling the H_VASI_STATE hcall result
before proceeding to the next stage.

So return -EAGAIN instead of -EBUSY when this race is
encountered. Additionally: logging this event is still appropriate but
use pr_info instead of pr_err; and remove use of unlikely() while here
as this is not a hot path at all.

Fixes: dfd718a2ed1f ("powerpc/rtas: Fix a potential race between CPU-Offline & Migration")
Signed-off-by: Nathan Lynch <nathanl@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/rtas.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kernel/rtas.c b/arch/powerpc/kernel/rtas.c
index fbc676160adf..9b4d2a2ffb4f 100644
--- a/arch/powerpc/kernel/rtas.c
+++ b/arch/powerpc/kernel/rtas.c
@@ -984,10 +984,9 @@ int rtas_ibm_suspend_me(u64 handle)
 	cpu_hotplug_disable();
 
 	/* Check if we raced with a CPU-Offline Operation */
-	if (unlikely(!cpumask_equal(cpu_present_mask, cpu_online_mask))) {
-		pr_err("%s: Raced against a concurrent CPU-Offline\n",
-		       __func__);
-		atomic_set(&data.error, -EBUSY);
+	if (!cpumask_equal(cpu_present_mask, cpu_online_mask)) {
+		pr_info("%s: Raced against a concurrent CPU-Offline\n", __func__);
+		atomic_set(&data.error, -EAGAIN);
 		goto out_hotplug_enable;
 	}
 
-- 
2.20.1

