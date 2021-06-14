Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1E43A6183
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234078AbhFNKsZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:48:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:50472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233739AbhFNKqW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:46:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A88BE6144A;
        Mon, 14 Jun 2021 10:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667010;
        bh=cSSZtWTxyszh/SBp1NWHgj5QWtKwtsxFTlJUAbCAIvY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bNySSo40AZq5lGzcDgCW3j0V4I6yCus+2m5UhJtqRGcrNbeEhM5zG5En0mzkWnkZt
         7ds0nI7monPM14xEO8gP+oT5lpFu5dGyV6IZ93yasSZq+lYwF4GsLtqb6womFHXCUT
         pHG2WLot5Tw29h74kPeYiLpZCSuv2IkpHecj9VnM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dai Ngo <dai.ngo@oracle.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 4.19 62/67] NFSv4: nfs4_proc_set_acl needs to restore NFS_CAP_UIDGID_NOMAP on error.
Date:   Mon, 14 Jun 2021 12:27:45 +0200
Message-Id: <20210614102645.869690450@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102643.797691914@linuxfoundation.org>
References: <20210614102643.797691914@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dai Ngo <dai.ngo@oracle.com>

commit f8849e206ef52b584cd9227255f4724f0cc900bb upstream.

Currently if __nfs4_proc_set_acl fails with NFS4ERR_BADOWNER it
re-enables the idmapper by clearing NFS_CAP_UIDGID_NOMAP before
retrying again. The NFS_CAP_UIDGID_NOMAP remains cleared even if
the retry fails. This causes problem for subsequent setattr
requests for v4 server that does not have idmapping configured.

This patch modifies nfs4_proc_set_acl to detect NFS4ERR_BADOWNER
and NFS4ERR_BADNAME and skips the retry, since the kernel isn't
involved in encoding the ACEs, and return -EINVAL.

Steps to reproduce the problem:

 # mount -o vers=4.1,sec=sys server:/export/test /tmp/mnt
 # touch /tmp/mnt/file1
 # chown 99 /tmp/mnt/file1
 # nfs4_setfacl -a A::unknown.user@xyz.com:wrtncy /tmp/mnt/file1
 Failed setxattr operation: Invalid argument
 # chown 99 /tmp/mnt/file1
 chown: changing ownership of ‘/tmp/mnt/file1’: Invalid argument
 # umount /tmp/mnt
 # mount -o vers=4.1,sec=sys server:/export/test /tmp/mnt
 # chown 99 /tmp/mnt/file1
 #

v2: detect NFS4ERR_BADOWNER and NFS4ERR_BADNAME and skip retry
       in nfs4_proc_set_acl.
Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/nfs4proc.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -5580,6 +5580,14 @@ static int nfs4_proc_set_acl(struct inod
 	do {
 		err = __nfs4_proc_set_acl(inode, buf, buflen);
 		trace_nfs4_set_acl(inode, err);
+		if (err == -NFS4ERR_BADOWNER || err == -NFS4ERR_BADNAME) {
+			/*
+			 * no need to retry since the kernel
+			 * isn't involved in encoding the ACEs.
+			 */
+			err = -EINVAL;
+			break;
+		}
 		err = nfs4_handle_exception(NFS_SERVER(inode), err,
 				&exception);
 	} while (exception.retry);


