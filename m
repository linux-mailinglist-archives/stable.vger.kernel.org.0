Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51DB83A6232
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234232AbhFNK5Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:57:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:58492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235042AbhFNKzL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:55:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B899D613DC;
        Mon, 14 Jun 2021 10:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667236;
        bh=ZbsIBKogva6+ok/KJsCK8K593COkgpVxF4mfG1LUmtY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zc1v5nA8gtOFFUGc3qWoi0SgbKySWfkKItQlG0dL1fnDl28whIfTeJ4kVVTXC+kI/
         FKePTchirFsYdbSUZ3dhioRvDs3AHkG58i9JoXE2IfxqCI3v4AUlGrNIcPSIN8pfGC
         al3eJJTtWshaNIb/8cSJJLGm+8zy0b2W4zRuFh9E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dai Ngo <dai.ngo@oracle.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.4 78/84] NFSv4: nfs4_proc_set_acl needs to restore NFS_CAP_UIDGID_NOMAP on error.
Date:   Mon, 14 Jun 2021 12:27:56 +0200
Message-Id: <20210614102649.018730936@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102646.341387537@linuxfoundation.org>
References: <20210614102646.341387537@linuxfoundation.org>
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
@@ -5799,6 +5799,14 @@ static int nfs4_proc_set_acl(struct inod
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


