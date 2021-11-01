Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96672441798
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:37:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233242AbhKAJh4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:37:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:43648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233247AbhKAJfx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:35:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3592611C1;
        Mon,  1 Nov 2021 09:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758770;
        bh=Wgx6c5gxkazsw3Ke5GOdyoRZli/JiREwlHKRxCfRe94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wFccwaTOoIMo44FcWkJDsc0jMF8u21BrG+b2O5Ch8tEC2fUfEtTWiDqaw0D604GLl
         dJKpaKnNOhhn6CyyKro/CAuKXG5XJMnTIwqY1+CgEkWecZBumZGGqZz3Xrhcthpz2W
         QHN2XOgSFCumUa5CHirhkOwX6gNiaT1TrWM0c44k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Quanyang Wang <quanyang.wang@windriver.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Roman Gushchin <guro@fb.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [PATCH 5.10 34/77] cgroup: Fix memory leak caused by missing cgroup_bpf_offline
Date:   Mon,  1 Nov 2021 10:17:22 +0100
Message-Id: <20211101082519.077356429@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082511.254155853@linuxfoundation.org>
References: <20211101082511.254155853@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quanyang Wang <quanyang.wang@windriver.com>

commit 04f8ef5643bcd8bcde25dfdebef998aea480b2ba upstream.

When enabling CONFIG_CGROUP_BPF, kmemleak can be observed by running
the command as below:

    $mount -t cgroup -o none,name=foo cgroup cgroup/
    $umount cgroup/

unreferenced object 0xc3585c40 (size 64):
  comm "mount", pid 425, jiffies 4294959825 (age 31.990s)
  hex dump (first 32 bytes):
    01 00 00 80 84 8c 28 c0 00 00 00 00 00 00 00 00  ......(.........
    00 00 00 00 00 00 00 00 6c 43 a0 c3 00 00 00 00  ........lC......
  backtrace:
    [<e95a2f9e>] cgroup_bpf_inherit+0x44/0x24c
    [<1f03679c>] cgroup_setup_root+0x174/0x37c
    [<ed4b0ac5>] cgroup1_get_tree+0x2c0/0x4a0
    [<f85b12fd>] vfs_get_tree+0x24/0x108
    [<f55aec5c>] path_mount+0x384/0x988
    [<e2d5e9cd>] do_mount+0x64/0x9c
    [<208c9cfe>] sys_mount+0xfc/0x1f4
    [<06dd06e0>] ret_fast_syscall+0x0/0x48
    [<a8308cb3>] 0xbeb4daa8

This is because that since the commit 2b0d3d3e4fcf ("percpu_ref: reduce
memory footprint of percpu_ref in fast path") root_cgrp->bpf.refcnt.data
is allocated by the function percpu_ref_init in cgroup_bpf_inherit which
is called by cgroup_setup_root when mounting, but not freed along with
root_cgrp when umounting. Adding cgroup_bpf_offline which calls
percpu_ref_kill to cgroup_kill_sb can free root_cgrp->bpf.refcnt.data in
umount path.

This patch also fixes the commit 4bfc0bb2c60e ("bpf: decouple the lifetime
of cgroup_bpf from cgroup itself"). A cgroup_bpf_offline is needed to do a
cleanup that frees the resources which are allocated by cgroup_bpf_inherit
in cgroup_setup_root.

And inside cgroup_bpf_offline, cgroup_get() is at the beginning and
cgroup_put is at the end of cgroup_bpf_release which is called by
cgroup_bpf_offline. So cgroup_bpf_offline can keep the balance of
cgroup's refcount.

Fixes: 2b0d3d3e4fcf ("percpu_ref: reduce memory footprint of percpu_ref in fast path")
Fixes: 4bfc0bb2c60e ("bpf: decouple the lifetime of cgroup_bpf from cgroup itself")
Signed-off-by: Quanyang Wang <quanyang.wang@windriver.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Roman Gushchin <guro@fb.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/bpf/20211018075623.26884-1-quanyang.wang@windriver.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/cgroup.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2147,8 +2147,10 @@ static void cgroup_kill_sb(struct super_
 	 * And don't kill the default root.
 	 */
 	if (list_empty(&root->cgrp.self.children) && root != &cgrp_dfl_root &&
-	    !percpu_ref_is_dying(&root->cgrp.self.refcnt))
+	    !percpu_ref_is_dying(&root->cgrp.self.refcnt)) {
+		cgroup_bpf_offline(&root->cgrp);
 		percpu_ref_kill(&root->cgrp.self.refcnt);
+	}
 	cgroup_put(&root->cgrp);
 	kernfs_kill_sb(sb);
 }


