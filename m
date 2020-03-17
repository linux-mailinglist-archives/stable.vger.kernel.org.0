Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91DDD18812E
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:16:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727995AbgCQLKD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:10:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:52732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729035AbgCQLKD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:10:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B7D8205ED;
        Tue, 17 Mar 2020 11:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443402;
        bh=Yfg8VFTpWdJwPbLcR6+malbbWAsQhtfHj2Prwv67Ce0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OqgmpUzpMW4L+EfJFPnhfcuaEpbaTgFLxcvpMaX0MBQJ/cAnFCkRblK67lxDO6f+y
         Tb1U243Dh7vTCbHZ5FP3bEacbWczsm5IM1IG5kO7XSsNC64TO1QjSG7Vc8MYqot/Uk
         wjfEwh8x5zufU4zsSId44AxDDFt1WreGP/sDVKnw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <cai@lca.pw>,
        Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 5.5 072/151] cgroup: fix psi_show() crash on 32bit ino archs
Date:   Tue, 17 Mar 2020 11:54:42 +0100
Message-Id: <20200317103331.602367219@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103326.593639086@linuxfoundation.org>
References: <20200317103326.593639086@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Cai <cai@lca.pw>

commit 190ecb190a9cd8c0599d8499b901e3c32e87966a upstream.

Similar to the commit d7495343228f ("cgroup: fix incorrect
WARN_ON_ONCE() in cgroup_setup_root()"), cgroup_id(root_cgrp) does not
equal to 1 on 32bit ino archs which triggers all sorts of issues with
psi_show() on s390x. For example,

 BUG: KASAN: slab-out-of-bounds in collect_percpu_times+0x2d0/
 Read of size 4 at addr 000000001e0ce000 by task read_all/3667
 collect_percpu_times+0x2d0/0x798
 psi_show+0x7c/0x2a8
 seq_read+0x2ac/0x830
 vfs_read+0x92/0x150
 ksys_read+0xe2/0x188
 system_call+0xd8/0x2b4

Fix it by using cgroup_ino().

Fixes: 743210386c03 ("cgroup: use cgrp->kn->id as the cgroup ID")
Signed-off-by: Qian Cai <cai@lca.pw>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: stable@vger.kernel.org # v5.5
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/cgroup/cgroup.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3547,21 +3547,21 @@ static int cpu_stat_show(struct seq_file
 static int cgroup_io_pressure_show(struct seq_file *seq, void *v)
 {
 	struct cgroup *cgrp = seq_css(seq)->cgroup;
-	struct psi_group *psi = cgroup_id(cgrp) == 1 ? &psi_system : &cgrp->psi;
+	struct psi_group *psi = cgroup_ino(cgrp) == 1 ? &psi_system : &cgrp->psi;
 
 	return psi_show(seq, psi, PSI_IO);
 }
 static int cgroup_memory_pressure_show(struct seq_file *seq, void *v)
 {
 	struct cgroup *cgrp = seq_css(seq)->cgroup;
-	struct psi_group *psi = cgroup_id(cgrp) == 1 ? &psi_system : &cgrp->psi;
+	struct psi_group *psi = cgroup_ino(cgrp) == 1 ? &psi_system : &cgrp->psi;
 
 	return psi_show(seq, psi, PSI_MEM);
 }
 static int cgroup_cpu_pressure_show(struct seq_file *seq, void *v)
 {
 	struct cgroup *cgrp = seq_css(seq)->cgroup;
-	struct psi_group *psi = cgroup_id(cgrp) == 1 ? &psi_system : &cgrp->psi;
+	struct psi_group *psi = cgroup_ino(cgrp) == 1 ? &psi_system : &cgrp->psi;
 
 	return psi_show(seq, psi, PSI_CPU);
 }


