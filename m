Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C55702E6930
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:47:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728620AbgL1Mzs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 07:55:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:52070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727753AbgL1Mzr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 07:55:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F135F229C5;
        Mon, 28 Dec 2020 12:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160131;
        bh=owhsRuGIO55+9gnazWXkz4HofZ08rWMcjfMjujq6K8o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fAs1VT77T1WdYOE/gpFUH8W6sKd5+NicEqbnbK03J+A03rZ7tF/3y3D39YX/HdpIs
         bw/GNzlTZSHV6fpC9U9v8si/ojWriuC+z2S/oqrPe2raaxutu1NL4oGH+hzwbuGQWI
         cW+J710wBwkKNUUFMhs96dFaPTY+LBqwXTtrgiVY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?=C2=A0Cheng=C2=A0Lin=C2=A0?= <cheng.lin130@zte.com.cn>,
        =?UTF-8?q?=C2=A0Yi=C2=A0Wang=C2=A0?= <wang.yi59@zte.com.cn>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 079/132] nfs_common: need lock during iterate through the list
Date:   Mon, 28 Dec 2020 13:49:23 +0100
Message-Id: <20201228124850.254193588@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124846.409999325@linuxfoundation.org>
References: <20201228124846.409999325@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cheng Lin <cheng.lin130@zte.com.cn>

[ Upstream commit 4a9d81caf841cd2c0ae36abec9c2963bf21d0284 ]

If the elem is deleted during be iterated on it, the iteration
process will fall into an endless loop.

kernel: NMI watchdog: BUG: soft lockup - CPU#4 stuck for 22s! [nfsd:17137]

PID: 17137  TASK: ffff8818d93c0000  CPU: 4   COMMAND: "nfsd"
    [exception RIP: __state_in_grace+76]
    RIP: ffffffffc00e817c  RSP: ffff8818d3aefc98  RFLAGS: 00000246
    RAX: ffff881dc0c38298  RBX: ffffffff81b03580  RCX: ffff881dc02c9f50
    RDX: ffff881e3fce8500  RSI: 0000000000000001  RDI: ffffffff81b03580
    RBP: ffff8818d3aefca0   R8: 0000000000000020   R9: ffff8818d3aefd40
    R10: ffff88017fc03800  R11: ffff8818e83933c0  R12: ffff8818d3aefd40
    R13: 0000000000000000  R14: ffff8818e8391068  R15: ffff8818fa6e4000
    CS: 0010  SS: 0018
 #0 [ffff8818d3aefc98] opens_in_grace at ffffffffc00e81e3 [grace]
 #1 [ffff8818d3aefca8] nfs4_preprocess_stateid_op at ffffffffc02a3e6c [nfsd]
 #2 [ffff8818d3aefd18] nfsd4_write at ffffffffc028ed5b [nfsd]
 #3 [ffff8818d3aefd80] nfsd4_proc_compound at ffffffffc0290a0d [nfsd]
 #4 [ffff8818d3aefdd0] nfsd_dispatch at ffffffffc027b800 [nfsd]
 #5 [ffff8818d3aefe08] svc_process_common at ffffffffc02017f3 [sunrpc]
 #6 [ffff8818d3aefe70] svc_process at ffffffffc0201ce3 [sunrpc]
 #7 [ffff8818d3aefe98] nfsd at ffffffffc027b117 [nfsd]
 #8 [ffff8818d3aefec8] kthread at ffffffff810b88c1
 #9 [ffff8818d3aeff50] ret_from_fork at ffffffff816d1607

The troublemake elem:
crash> lock_manager ffff881dc0c38298
struct lock_manager {
  list = {
    next = 0xffff881dc0c38298,
    prev = 0xffff881dc0c38298
  },
  block_opens = false
}

Fixes: c87fb4a378f9 ("lockd: NLM grace period shouldn't block NFSv4 opens")
Signed-off-by: Cheng Lin <cheng.lin130@zte.com.cn>
Signed-off-by: Yi Wang <wang.yi59@zte.com.cn>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs_common/grace.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/nfs_common/grace.c b/fs/nfs_common/grace.c
index 77d136ac89099..c21fca0dcba74 100644
--- a/fs/nfs_common/grace.c
+++ b/fs/nfs_common/grace.c
@@ -75,10 +75,14 @@ __state_in_grace(struct net *net, bool open)
 	if (!open)
 		return !list_empty(grace_list);
 
+	spin_lock(&grace_lock);
 	list_for_each_entry(lm, grace_list, list) {
-		if (lm->block_opens)
+		if (lm->block_opens) {
+			spin_unlock(&grace_lock);
 			return true;
+		}
 	}
+	spin_unlock(&grace_lock);
 	return false;
 }
 
-- 
2.27.0



