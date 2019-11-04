Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8F77EEF80
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:22:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388401AbfKDV4f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 16:56:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:52164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388349AbfKDV4e (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:56:34 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F00D217F4;
        Mon,  4 Nov 2019 21:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904593;
        bh=NLWDYhQ7BlPtONutR4aCq9O3/nd9q7B7s6ExkFNCdB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=liLk3Jx5tDSZK2D2hRirpzxHyhpPhGRx40wM3TOfo7C5VF2EYCGQ8UdLrANiMx5jZ
         b1ErH4iWpVA7AUh5/7xeY2TjhZ8zmNch+M+UB4iedQDbuwbXmwbkOg70L4fpmurMBR
         bmb4CFfxUNmDCcqUG8zNfxEsabADr051YkcYOnYo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 54/95] NFSv4: Fix leak of clp->cl_acceptor string
Date:   Mon,  4 Nov 2019 22:44:52 +0100
Message-Id: <20191104212105.269891026@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212038.056365853@linuxfoundation.org>
References: <20191104212038.056365853@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 1047ec868332034d1fbcb2fae19fe6d4cb869ff2 ]

Our client can issue multiple SETCLIENTID operations to the same
server in some circumstances. Ensure that calls to
nfs4_proc_setclientid() after the first one do not overwrite the
previously allocated cl_acceptor string.

unreferenced object 0xffff888461031800 (size 32):
  comm "mount.nfs", pid 2227, jiffies 4294822467 (age 1407.749s)
  hex dump (first 32 bytes):
    6e 66 73 40 6b 6c 69 6d 74 2e 69 62 2e 31 30 31  nfs@klimt.ib.101
    35 67 72 61 6e 67 65 72 2e 6e 65 74 00 00 00 00  5granger.net....
  backtrace:
    [<00000000ab820188>] __kmalloc+0x128/0x176
    [<00000000eeaf4ec8>] gss_stringify_acceptor+0xbd/0x1a7 [auth_rpcgss]
    [<00000000e85e3382>] nfs4_proc_setclientid+0x34e/0x46c [nfsv4]
    [<000000003d9cf1fa>] nfs40_discover_server_trunking+0x7a/0xed [nfsv4]
    [<00000000b81c3787>] nfs4_discover_server_trunking+0x81/0x244 [nfsv4]
    [<000000000801b55f>] nfs4_init_client+0x1b0/0x238 [nfsv4]
    [<00000000977daf7f>] nfs4_set_client+0xfe/0x14d [nfsv4]
    [<0000000053a68a2a>] nfs4_create_server+0x107/0x1db [nfsv4]
    [<0000000088262019>] nfs4_remote_mount+0x2c/0x59 [nfsv4]
    [<00000000e84a2fd0>] legacy_get_tree+0x2d/0x4c
    [<00000000797e947c>] vfs_get_tree+0x20/0xc7
    [<00000000ecabaaa8>] fc_mount+0xe/0x36
    [<00000000f15fafc2>] vfs_kern_mount+0x74/0x8d
    [<00000000a3ff4e26>] nfs_do_root_mount+0x8a/0xa3 [nfsv4]
    [<00000000d1c2b337>] nfs4_try_mount+0x58/0xad [nfsv4]
    [<000000004c9bddee>] nfs_fs_mount+0x820/0x869 [nfs]

Fixes: f11b2a1cfbf5 ("nfs4: copy acceptor name from context ... ")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 6409ff4876cb5..af062e9f45803 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -5655,6 +5655,7 @@ int nfs4_proc_setclientid(struct nfs_client *clp, u32 program,
 	}
 	status = task->tk_status;
 	if (setclientid.sc_cred) {
+		kfree(clp->cl_acceptor);
 		clp->cl_acceptor = rpcauth_stringify_acceptor(setclientid.sc_cred);
 		put_rpccred(setclientid.sc_cred);
 	}
-- 
2.20.1



