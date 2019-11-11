Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1843DF7AD4
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:30:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727077AbfKKSaH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:30:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:46308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727151AbfKKSaG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:30:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73F8B21655;
        Mon, 11 Nov 2019 18:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497006;
        bh=DDWfPY0DTZh4yKgt0zwfnQi8k5El7XW/eyDN47BTXbg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZPo5/H6x0CxWYsc5wvXq5mxdZDFsk8Lb4ZGrGRyqxNYtwcjnxW1SJyGL/yLojT//0
         dn25l6Tb5JHRfi1HEUnBxNEwt8IgLVSuupz8lLBkrNXGP/94qmocXMFV9qS5XP8Q7O
         IAfWe71RKasEhL2XMBZYwBBcuyDY25gV9mc7kdXY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luis Henriques <lhenriques@suse.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 4.4 14/43] ceph: fix use-after-free in __ceph_remove_cap()
Date:   Mon, 11 Nov 2019 19:28:28 +0100
Message-Id: <20191111181305.245711276@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181246.772983347@linuxfoundation.org>
References: <20191111181246.772983347@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luis Henriques <lhenriques@suse.com>

commit ea60ed6fcf29eebc78f2ce91491e6309ee005a01 upstream.

KASAN reports a use-after-free when running xfstest generic/531, with the
following trace:

[  293.903362]  kasan_report+0xe/0x20
[  293.903365]  rb_erase+0x1f/0x790
[  293.903370]  __ceph_remove_cap+0x201/0x370
[  293.903375]  __ceph_remove_caps+0x4b/0x70
[  293.903380]  ceph_evict_inode+0x4e/0x360
[  293.903386]  evict+0x169/0x290
[  293.903390]  __dentry_kill+0x16f/0x250
[  293.903394]  dput+0x1c6/0x440
[  293.903398]  __fput+0x184/0x330
[  293.903404]  task_work_run+0xb9/0xe0
[  293.903410]  exit_to_usermode_loop+0xd3/0xe0
[  293.903413]  do_syscall_64+0x1a0/0x1c0
[  293.903417]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

This happens because __ceph_remove_cap() may queue a cap release
(__ceph_queue_cap_release) which can be scheduled before that cap is
removed from the inode list with

	rb_erase(&cap->ci_node, &ci->i_caps);

And, when this finally happens, the use-after-free will occur.

This can be fixed by removing the cap from the inode list before being
removed from the session list, and thus eliminating the risk of an UAF.

Cc: stable@vger.kernel.org
Signed-off-by: Luis Henriques <lhenriques@suse.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ceph/caps.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -926,6 +926,11 @@ void __ceph_remove_cap(struct ceph_cap *
 
 	dout("__ceph_remove_cap %p from %p\n", cap, &ci->vfs_inode);
 
+	/* remove from inode's cap rbtree, and clear auth cap */
+	rb_erase(&cap->ci_node, &ci->i_caps);
+	if (ci->i_auth_cap == cap)
+		ci->i_auth_cap = NULL;
+
 	/* remove from session list */
 	spin_lock(&session->s_cap_lock);
 	if (session->s_cap_iterator == cap) {
@@ -961,11 +966,6 @@ void __ceph_remove_cap(struct ceph_cap *
 
 	spin_unlock(&session->s_cap_lock);
 
-	/* remove from inode list */
-	rb_erase(&cap->ci_node, &ci->i_caps);
-	if (ci->i_auth_cap == cap)
-		ci->i_auth_cap = NULL;
-
 	if (removed)
 		ceph_put_cap(mdsc, cap);
 


