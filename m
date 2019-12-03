Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C652111CA0
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:46:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729145AbfLCWp7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:45:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:35066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729141AbfLCWp7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:45:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6AA8720803;
        Tue,  3 Dec 2019 22:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413159;
        bh=q8c7pSzDH6ofmpi3wekKse06815smYHyUWi3zQCd6d0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B2EZ0d53EexUbmbXqi3OyM7xSDfo+op3AQFha+gMooyCdh1QFQxV6Eo9iA1Mod+Zx
         KgVWPMjgbM/Nwua5Wlaoi2KOVSvFHDhOZPBOJSNOlgx9J81/5ZN5sYiikrP7fw6rhX
         uQMq4hg2aGBS0DGStYPKbVPBdGvp3kNZ41lVLmwY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaochen Shen <xiaochen.shen@intel.com>,
        Borislav Petkov <bp@suse.de>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        pei.p.jia@intel.com, Reinette Chatre <reinette.chatre@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86-ml <x86@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 021/321] x86/resctrl: Prevent NULL pointer dereference when reading mondata
Date:   Tue,  3 Dec 2019 23:31:27 +0100
Message-Id: <20191203223428.221829108@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaochen Shen <xiaochen.shen@intel.com>

[ Upstream commit 26467b0f8407cbd628fa5b7bcfd156e772004155 ]

When a mon group is being deleted, rdtgrp->flags is set to RDT_DELETED
in rdtgroup_rmdir_mon() firstly. The structure of rdtgrp will be freed
until rdtgrp->waitcount is dropped to 0 in rdtgroup_kn_unlock() later.

During the window of deleting a mon group, if an application calls
rdtgroup_mondata_show() to read mondata under this mon group,
'rdtgrp' returned from rdtgroup_kn_lock_live() is a NULL pointer when
rdtgrp->flags is RDT_DELETED. And then 'rdtgrp' is passed in this path:
rdtgroup_mondata_show() --> mon_event_read() --> mon_event_count().
Thus it results in NULL pointer dereference in mon_event_count().

Check 'rdtgrp' in rdtgroup_mondata_show(), and return -ENOENT
immediately when reading mondata during the window of deleting a mon
group.

Fixes: d89b7379015f ("x86/intel_rdt/cqm: Add mon_data")
Signed-off-by: Xiaochen Shen <xiaochen.shen@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Fenghua Yu <fenghua.yu@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: pei.p.jia@intel.com
Cc: Reinette Chatre <reinette.chatre@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: x86-ml <x86@kernel.org>
Link: https://lkml.kernel.org/r/1572326702-27577-1-git-send-email-xiaochen.shen@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/intel_rdt_ctrlmondata.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kernel/cpu/intel_rdt_ctrlmondata.c b/arch/x86/kernel/cpu/intel_rdt_ctrlmondata.c
index c8b72aff55e00..2052e1e6a11c9 100644
--- a/arch/x86/kernel/cpu/intel_rdt_ctrlmondata.c
+++ b/arch/x86/kernel/cpu/intel_rdt_ctrlmondata.c
@@ -459,6 +459,10 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 	int ret = 0;
 
 	rdtgrp = rdtgroup_kn_lock_live(of->kn);
+	if (!rdtgrp) {
+		ret = -ENOENT;
+		goto out;
+	}
 
 	md.priv = of->kn->priv;
 	resid = md.u.rid;
-- 
2.20.1



