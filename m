Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 035233A8597
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 17:54:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232620AbhFOP4v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 11:56:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:47006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231992AbhFOPyM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 11:54:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 490FB6188B;
        Tue, 15 Jun 2021 15:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623772250;
        bh=rqa7uLt5zbrbSm2o0hI3ygw37YDPgAXOjaBTCMyJEX8=;
        h=From:To:Cc:Subject:Date:From;
        b=p/ySSkFpGtguBKGxJ5A7s/hsgItE4QdIsZYF65Zw3uasQ8IjamSt5LqISNDfboyMx
         VVaz3BUYa9fc2pNzZsa1H7UEcPCYN93SleBpdFFvWo+GTfqmqQ4Tqzav/RzGRY3faK
         1c9kG+5o2dJRA0mbedLDRvX7DUtWL2fwlf70vFAAOPIZKto8lyfcHw3aYRw5WGCjUz
         suZJnteHuuTk6OdMIdM7c9Nk3By6P/AhkOj5zfvhD7eyPWbJ1CtXv6I2DKCRSa630M
         +TFbebnuKFt0qOnOpnYofcNEcayUhyj1BnmC/fGW1GUKNCqmqaaQ9GiXA57lbSoR+T
         Bv3pBw6CREp5g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dai Ngo <dai.ngo@oracle.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 1/3] NFSv4: nfs4_proc_set_acl needs to restore NFS_CAP_UIDGID_NOMAP on error.
Date:   Tue, 15 Jun 2021 11:50:45 -0400
Message-Id: <20210615155048.63448-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dai Ngo <dai.ngo@oracle.com>

[ Upstream commit f8849e206ef52b584cd9227255f4724f0cc900bb ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 92ca753723b5..e10bada12361 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -4887,6 +4887,14 @@ static int nfs4_proc_set_acl(struct inode *inode, const void *buf, size_t buflen
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
-- 
2.30.2

