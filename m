Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10C7B140023
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:48:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390513AbgAPXT7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:19:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:46136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730002AbgAPXT6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:19:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DEA712073A;
        Thu, 16 Jan 2020 23:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579216797;
        bh=4M9gQFM78wM2WrIqZDaeHB1Aj7tV3sKoVIynd1TWKFw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cZW4QZ8Z5bU3RfFweOJuHxiguxhKEwUTh4FuWrXRZzSvS0UKS7SKCskMBg6Mzm4+y
         fAC3YHkCsFAZDLQzeUcehp1f44S/4vQr00JeWaochm0T+BXh15OdZqTLUmsnwfO6wJ
         WbPiAXHUaI9upETw9qAGpO9bv8EJ/V/J7BUvIabI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Roman Gushchin <guro@fb.com>, Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.4 023/203] bpf: cgroup: prevent out-of-order release of cgroup bpf
Date:   Fri, 17 Jan 2020 00:15:40 +0100
Message-Id: <20200116231746.557786137@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roman Gushchin <guro@fb.com>

commit e10360f815ca6367357b2c2cfef17fc663e50f7b upstream.

Before commit 4bfc0bb2c60e ("bpf: decouple the lifetime of cgroup_bpf from cgroup itself")
cgroup bpf structures were released with
corresponding cgroup structures. It guaranteed the hierarchical order
of destruction: children were always first. It preserved attached
programs from being released before their propagated copies.

But with cgroup auto-detachment there are no such guarantees anymore:
cgroup bpf is released as soon as the cgroup is offline and there are
no live associated sockets. It means that an attached program can be
detached and released, while its propagated copy is still living
in the cgroup subtree. This will obviously lead to an use-after-free
bug.

To reproduce the issue the following script can be used:

  #!/bin/bash

  CGROOT=/sys/fs/cgroup

  mkdir -p ${CGROOT}/A ${CGROOT}/B ${CGROOT}/A/C
  sleep 1

  ./test_cgrp2_attach ${CGROOT}/A egress &
  A_PID=$!
  ./test_cgrp2_attach ${CGROOT}/B egress &
  B_PID=$!

  echo $$ > ${CGROOT}/A/C/cgroup.procs
  iperf -s &
  S_PID=$!
  iperf -c localhost -t 100 &
  C_PID=$!

  sleep 1

  echo $$ > ${CGROOT}/B/cgroup.procs
  echo ${S_PID} > ${CGROOT}/B/cgroup.procs
  echo ${C_PID} > ${CGROOT}/B/cgroup.procs

  sleep 1

  rmdir ${CGROOT}/A/C
  rmdir ${CGROOT}/A

  sleep 1

  kill -9 ${S_PID} ${C_PID} ${A_PID} ${B_PID}

On the unpatched kernel the following stacktrace can be obtained:

[   33.619799] BUG: unable to handle page fault for address: ffffbdb4801ab002
[   33.620677] #PF: supervisor read access in kernel mode
[   33.621293] #PF: error_code(0x0000) - not-present page
[   33.622754] Oops: 0000 [#1] SMP NOPTI
[   33.623202] CPU: 0 PID: 601 Comm: iperf Not tainted 5.5.0-rc2+ #23
[   33.625545] RIP: 0010:__cgroup_bpf_run_filter_skb+0x29f/0x3d0
[   33.635809] Call Trace:
[   33.636118]  ? __cgroup_bpf_run_filter_skb+0x2bf/0x3d0
[   33.636728]  ? __switch_to_asm+0x40/0x70
[   33.637196]  ip_finish_output+0x68/0xa0
[   33.637654]  ip_output+0x76/0xf0
[   33.638046]  ? __ip_finish_output+0x1c0/0x1c0
[   33.638576]  __ip_queue_xmit+0x157/0x410
[   33.639049]  __tcp_transmit_skb+0x535/0xaf0
[   33.639557]  tcp_write_xmit+0x378/0x1190
[   33.640049]  ? _copy_from_iter_full+0x8d/0x260
[   33.640592]  tcp_sendmsg_locked+0x2a2/0xdc0
[   33.641098]  ? sock_has_perm+0x10/0xa0
[   33.641574]  tcp_sendmsg+0x28/0x40
[   33.641985]  sock_sendmsg+0x57/0x60
[   33.642411]  sock_write_iter+0x97/0x100
[   33.642876]  new_sync_write+0x1b6/0x1d0
[   33.643339]  vfs_write+0xb6/0x1a0
[   33.643752]  ksys_write+0xa7/0xe0
[   33.644156]  do_syscall_64+0x5b/0x1b0
[   33.644605]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fix this by grabbing a reference to the bpf structure of each ancestor
on the initialization of the cgroup bpf structure, and dropping the
reference at the end of releasing the cgroup bpf structure.

This will restore the hierarchical order of cgroup bpf releasing,
without adding any operations on hot paths.

Thanks to Josef Bacik for the debugging and the initial analysis of
the problem.

Fixes: 4bfc0bb2c60e ("bpf: decouple the lifetime of cgroup_bpf from cgroup itself")
Reported-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/bpf/cgroup.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -35,8 +35,8 @@ void cgroup_bpf_offline(struct cgroup *c
  */
 static void cgroup_bpf_release(struct work_struct *work)
 {
-	struct cgroup *cgrp = container_of(work, struct cgroup,
-					   bpf.release_work);
+	struct cgroup *p, *cgrp = container_of(work, struct cgroup,
+					       bpf.release_work);
 	enum bpf_cgroup_storage_type stype;
 	struct bpf_prog_array *old_array;
 	unsigned int type;
@@ -65,6 +65,9 @@ static void cgroup_bpf_release(struct wo
 
 	mutex_unlock(&cgroup_mutex);
 
+	for (p = cgroup_parent(cgrp); p; p = cgroup_parent(p))
+		cgroup_bpf_put(p);
+
 	percpu_ref_exit(&cgrp->bpf.refcnt);
 	cgroup_put(cgrp);
 }
@@ -199,6 +202,7 @@ int cgroup_bpf_inherit(struct cgroup *cg
  */
 #define	NR ARRAY_SIZE(cgrp->bpf.effective)
 	struct bpf_prog_array *arrays[NR] = {};
+	struct cgroup *p;
 	int ret, i;
 
 	ret = percpu_ref_init(&cgrp->bpf.refcnt, cgroup_bpf_release_fn, 0,
@@ -206,6 +210,9 @@ int cgroup_bpf_inherit(struct cgroup *cg
 	if (ret)
 		return ret;
 
+	for (p = cgroup_parent(cgrp); p; p = cgroup_parent(p))
+		cgroup_bpf_get(p);
+
 	for (i = 0; i < NR; i++)
 		INIT_LIST_HEAD(&cgrp->bpf.progs[i]);
 


