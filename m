Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5FA179630
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390372AbfG2Tth (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:49:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:40212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390559AbfG2Tth (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:49:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2D542171F;
        Mon, 29 Jul 2019 19:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429776;
        bh=ljmbUjArS7s9I0wGp7O46tcK9Gu6RtaNGsPsw8xQges=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZoTr8s+m2R7uNtipbWZIi7BmLmSXPoafkeN3Ttt/+B4m1ZtfwsCI8Njvj1hA7vfOa
         VsmPsqkIzKCrCu4JWFOT2d0oyYL7UogrDincb/y8Xs2FRkTrUtCBA2LaWaSXAtmGZH
         nY/6t5HIhFOd+E2S2/J05e+9zeEEnN8xm3rd+oMk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Lynch <nathanl@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 092/215] powerpc/rtas: retry when cpu offline races with suspend/migration
Date:   Mon, 29 Jul 2019 21:21:28 +0200
Message-Id: <20190729190755.293241211@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index b824f4c69622..fff2eb22427d 100644
--- a/arch/powerpc/kernel/rtas.c
+++ b/arch/powerpc/kernel/rtas.c
@@ -980,10 +980,9 @@ int rtas_ibm_suspend_me(u64 handle)
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



