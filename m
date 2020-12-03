Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB2E2CDDCE
	for <lists+stable@lfdr.de>; Thu,  3 Dec 2020 19:37:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731739AbgLCSeZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 13:34:25 -0500
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:42296 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729250AbgLCSeZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Dec 2020 13:34:25 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R931e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=wenyang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UHRBP2t_1607020413;
Received: from localhost(mailfrom:wenyang@linux.alibaba.com fp:SMTPD_---0UHRBP2t_1607020413)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 04 Dec 2020 02:33:42 +0800
From:   Wen Yang <wenyang@linux.alibaba.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Xunlei Pang <xlpang@linux.alibaba.com>,
        linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        stable@vger.kernel.org, Wen Yang <wenyang@linux.alibaba.com>
Subject: [PATCH 08/10] proc: Clear the pieces of proc_inode that proc_evict_inode cares about
Date:   Fri,  4 Dec 2020 02:32:02 +0800
Message-Id: <20201203183204.63759-9-wenyang@linux.alibaba.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20201203183204.63759-1-wenyang@linux.alibaba.com>
References: <20201203183204.63759-1-wenyang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

[ Upstream commit 71448011ea2a1cd36d8f5cbdab0ed716c454d565 ]

This just keeps everything tidier, and allows for using flags like
SLAB_TYPESAFE_BY_RCU where slabs are not always cleared before reuse.
I don't see reuse without reinitializing happening with the proc_inode
but I had a false alarm while reworking flushing of proc dentries and
indoes when a process dies that caused me to tidy this up.

The code is a little easier to follow and reason about this
way so I figured the changes might as well be kept.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: <stable@vger.kernel.org> # 4.9.x
Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
---
 fs/proc/inode.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 920c761..739fb9c 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -32,21 +32,27 @@ static void proc_evict_inode(struct inode *inode)
 {
 	struct proc_dir_entry *de;
 	struct ctl_table_header *head;
+	struct proc_inode *ei = PROC_I(inode);
 
 	truncate_inode_pages_final(&inode->i_data);
 	clear_inode(inode);
 
 	/* Stop tracking associated processes */
-	put_pid(PROC_I(inode)->pid);
+	if (ei->pid) {
+		put_pid(ei->pid);
+		ei->pid = NULL;
+	}
 
 	/* Let go of any associated proc directory entry */
-	de = PDE(inode);
-	if (de)
+	de = ei->pde;
+	if (de) {
 		pde_put(de);
+		ei->pde = NULL;
+	}
 
-	head = PROC_I(inode)->sysctl;
+	head = ei->sysctl;
 	if (head) {
-		RCU_INIT_POINTER(PROC_I(inode)->sysctl, NULL);
+		RCU_INIT_POINTER(ei->sysctl, NULL);
 		proc_sys_evict_inode(inode, head);
 	}
 }
-- 
1.8.3.1

