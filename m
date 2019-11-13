Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F539FA467
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728414AbfKMCQ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 21:16:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:48330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729414AbfKMB4O (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:56:14 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F218A222D3;
        Wed, 13 Nov 2019 01:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610173;
        bh=pBZM1+qxDgGdEEMveh3ihD78Jrc09jymm0BKj6GZGOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Td8Q13KJYdIo6JBm3CMqSkZRvXSdEvAnwBBuetoaUUBxRfNC+/vnJFUYvW9cngOMv
         a8UZ5RYHmCV2onH7GTIQ5xmn19fZXjAapMe+F8i3+z2vUP6t9LxYwbzq/omtA3B8gW
         Z0SjqPB5rQqKF3eOg69wEQLQDI/QTDcqiKO8FMH8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Reinette Chatre <reinette.chatre@intel.com>,
        Borislav Petkov <bp@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>, fenghua.yu@intel.com,
        gavin.hindman@intel.com, jithu.joseph@intel.com,
        x86-ml <x86@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 209/209] x86/resctrl: Fix rdt_find_domain() return value and checks
Date:   Tue, 12 Nov 2019 20:50:25 -0500
Message-Id: <20191113015025.9685-209-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Reinette Chatre <reinette.chatre@intel.com>

[ Upstream commit 52eb74339a6233c69f4e3794b69ea7c98eeeae1b ]

rdt_find_domain() returns an ERR_PTR() that is generated from a provided
domain id when the value is negative.

Care needs to be taken when creating an ERR_PTR() from this value
because a subsequent check using IS_ERR() expects the error to
be within the MAX_ERRNO range. Using an invalid domain id as an
ERR_PTR() does work at this time since this is currently always -1.
Using this undocumented assumption is fragile since future users of
rdt_find_domain() may not be aware of thus assumption.

Two related issues are addressed:

- Ensure that rdt_find_domain() always returns a valid error value by
forcing the error to be -ENODEV when a negative domain id is provided.

- In a few instances the return value of rdt_find_domain() is just
checked for NULL - fix these to include a check of ERR_PTR.

Fixes: d89b7379015f ("x86/intel_rdt/cqm: Add mon_data")
Fixes: 521348b011d6 ("x86/intel_rdt: Introduce utility to obtain CDP peer")
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: fenghua.yu@intel.com
Cc: gavin.hindman@intel.com
Cc: jithu.joseph@intel.com
Cc: x86-ml <x86@kernel.org>
Link: https://lkml.kernel.org/r/b88cd4ff6a75995bf8db9b0ea546908fe50f69f3.1544479852.git.reinette.chatre@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/intel_rdt.c             | 2 +-
 arch/x86/kernel/cpu/intel_rdt_ctrlmondata.c | 2 +-
 arch/x86/kernel/cpu/intel_rdt_rdtgroup.c    | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_rdt.c b/arch/x86/kernel/cpu/intel_rdt.c
index abb71ac704433..cc43c5abd187b 100644
--- a/arch/x86/kernel/cpu/intel_rdt.c
+++ b/arch/x86/kernel/cpu/intel_rdt.c
@@ -421,7 +421,7 @@ struct rdt_domain *rdt_find_domain(struct rdt_resource *r, int id,
 	struct list_head *l;
 
 	if (id < 0)
-		return ERR_PTR(id);
+		return ERR_PTR(-ENODEV);
 
 	list_for_each(l, &r->domains) {
 		d = list_entry(l, struct rdt_domain, list);
diff --git a/arch/x86/kernel/cpu/intel_rdt_ctrlmondata.c b/arch/x86/kernel/cpu/intel_rdt_ctrlmondata.c
index 627e5c809b33d..968ace3c6d730 100644
--- a/arch/x86/kernel/cpu/intel_rdt_ctrlmondata.c
+++ b/arch/x86/kernel/cpu/intel_rdt_ctrlmondata.c
@@ -459,7 +459,7 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 
 	r = &rdt_resources_all[resid];
 	d = rdt_find_domain(r, domid, NULL);
-	if (!d) {
+	if (IS_ERR_OR_NULL(d)) {
 		ret = -ENOENT;
 		goto out;
 	}
diff --git a/arch/x86/kernel/cpu/intel_rdt_rdtgroup.c b/arch/x86/kernel/cpu/intel_rdt_rdtgroup.c
index 0d8ea82acd930..ad64031e82dcd 100644
--- a/arch/x86/kernel/cpu/intel_rdt_rdtgroup.c
+++ b/arch/x86/kernel/cpu/intel_rdt_rdtgroup.c
@@ -1023,7 +1023,7 @@ static int rdt_cdp_peer_get(struct rdt_resource *r, struct rdt_domain *d,
 	 * peer RDT CDP resource. Hence the WARN.
 	 */
 	_d_cdp = rdt_find_domain(_r_cdp, d->id, NULL);
-	if (WARN_ON(!_d_cdp)) {
+	if (WARN_ON(IS_ERR_OR_NULL(_d_cdp))) {
 		_r_cdp = NULL;
 		ret = -EINVAL;
 	}
-- 
2.20.1

