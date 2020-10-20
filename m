Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A648D29442B
	for <lists+stable@lfdr.de>; Tue, 20 Oct 2020 23:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409696AbgJTVAe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Oct 2020 17:00:34 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:50312 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2409695AbgJTVAe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Oct 2020 17:00:34 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09KKwrWx013365;
        Tue, 20 Oct 2020 21:00:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=kSbtZnXMFm0ExYt6wHYlkfY5suJfSjQUM9oOZ0pBw38=;
 b=GX2YCz+GY+Gx6griVAKbW9N2F+0EhnrxsO5Rf+C+JTqhfl+IvVP+a9U2XE6di5GjsZns
 LdCkjhNd2B5prDAm+NnGgH6qvRyu/Kr2mq1pytPTq4on6JlTOap7cGVD1wGSwbk2n/y+
 K0zQcfQZKJEMD3xvioeo922LtzY05JBad9s3bAVdy8bnxeRVvlAk0ZcwTd132UBWomia
 h6G7Vysle7NupbQK42c5hrl8/OXq/J+hTbOfAXtHFl/1IhNUG3QRCqXE+aK/a05xKUes
 s2phDzR8ggwGL9GYVJykTZis8IiW+okw40lp47UsGYEN5foJ+jqXK7QoBL5GTEQDbHDW zg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 347p4awh15-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 20 Oct 2020 21:00:32 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09KKsu7A144200;
        Tue, 20 Oct 2020 20:58:31 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 348ahwrm4v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Oct 2020 20:58:31 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09KKwT0n027367;
        Tue, 20 Oct 2020 20:58:29 GMT
Received: from char.us.oracle.com (/10.152.32.25)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 20 Oct 2020 13:58:29 -0700
Received: by char.us.oracle.com (Postfix, from userid 1000)
        id 437B66A5D96; Tue, 20 Oct 2020 17:00:08 -0400 (EDT)
From:   Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To:     eric.snowberg@oracle.com, john.haxby@oracle.com,
        todd.vierling@oracle.com
Cc:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH RFC UEK5 6/7] debugfs: Return -EPERM when locked down
Date:   Tue, 20 Oct 2020 17:00:03 -0400
Message-Id: <20201020210004.18977-7-konrad.wilk@oracle.com>
X-Mailer: git-send-email 2.13.6
In-Reply-To: <20201020210004.18977-1-konrad.wilk@oracle.com>
References: <20201020210004.18977-1-konrad.wilk@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9780 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010200142
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9780 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 priorityscore=1501
 clxscore=1011 malwarescore=0 mlxscore=0 bulkscore=0 lowpriorityscore=0
 phishscore=0 adultscore=0 mlxlogscore=999 impostorscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010200143
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Snowberg <eric.snowberg@oracle.com>

When lockdown is enabled, debugfs_is_locked_down returns 1. It will then
trigger the following:

WARNING: CPU: 48 PID: 3747
CPU: 48 PID: 3743 Comm: bash Not tainted 5.4.0-1946.x86_64 #1
Hardware name: Oracle Corporation ORACLE SERVER X7-2/ASM, MB, X7-2, BIOS 41060400 05/20/2019
RIP: 0010:do_dentry_open+0x343/0x3a0
Code: 00 40 08 00 45 31 ff 48 c7 43 28 40 5b e7 89 e9 02 ff ff ff 48 8b 53 28 4c 8b 72 70 4d 85 f6 0f 84 10 fe ff ff e9 f5 fd ff ff <0f> 0b 41 bf ea ff ff ff e9 3b ff ff ff 41 bf e6 ff ff ff e9 b4 fe
RSP: 0018:ffffb8740dde7ca0 EFLAGS: 00010202
RAX: ffffffff89e88a40 RBX: ffff928c8e6b6f00 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffff928dbfd97778 RDI: ffff9285cff685c0
RBP: ffffb8740dde7cc8 R08: 0000000000000821 R09: 0000000000000030
R10: 0000000000000057 R11: ffffb8740dde7a98 R12: ffff926ec781c900
R13: ffff928c8e6b6f10 R14: ffffffff8936e190 R15: 0000000000000001
FS:  00007f45f6777740(0000) GS:ffff928dbfd80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fff95e0d5d8 CR3: 0000001ece562006 CR4: 00000000007606e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
 vfs_open+0x2d/0x30
 path_openat+0x2d4/0x1680
 ? tty_mode_ioctl+0x298/0x4c0
 do_filp_open+0x93/0x100
 ? strncpy_from_user+0x57/0x1b0
 ? __alloc_fd+0x46/0x150
 do_sys_open+0x182/0x230
 __x64_sys_openat+0x20/0x30
 do_syscall_64+0x60/0x1b0
 entry_SYSCALL_64_after_hwframe+0x170/0x1d5
RIP: 0033:0x7f45f5e5ce02
Code: 25 00 00 41 00 3d 00 00 41 00 74 4c 48 8d 05 25 59 2d 00 8b 00 85 c0 75 6d 89 f2 b8 01 01 00 00 48 89 fe bf 9c ff ff ff 0f 05 <48> 3d 00 f0 ff ff 0f 87 a2 00 00 00 48 8b 4c 24 28 64 48 33 0c 25
RSP: 002b:00007fff95e0d2e0 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 0000561178c069b0 RCX: 00007f45f5e5ce02
RDX: 0000000000000241 RSI: 0000561178c08800 RDI: 00000000ffffff9c
RBP: 00007fff95e0d3e0 R08: 0000000000000020 R09: 0000000000000005
R10: 00000000000001b6 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000003 R14: 0000000000000001 R15: 0000561178c08800

Change the return type to int and return -EPERM when lockdown is enabled
to remove the warning above. Also rename debugfs_is_locked_down to
debugfs_locked_down to make it sound less like it returns a boolean.

Fixes: 5496197f9b08 ("debugfs: Restrict debugfs when the kernel is locked down")
Signed-off-by: Eric Snowberg <eric.snowberg@oracle.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: stable <stable@vger.kernel.org>
Acked-by: James Morris <jamorris@linux.microsoft.com>
Link: https://lore.kernel.org/r/20191207161603.35907-1-eric.snowberg@oracle.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

(cherry picked from commit a37f4958f7b63d2b3cd17a76151fdfc29ce1da5f)
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

[Backport:

 Mostly the same, but needed to add an extra return for the
 confidentiality mode]
---
 fs/debugfs/file.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
index 86c7235dfd57b..87cd56dc637d7 100644
--- a/fs/debugfs/file.c
+++ b/fs/debugfs/file.c
@@ -103,21 +103,24 @@ EXPORT_SYMBOL_GPL(debugfs_use_file_finish);
  * We also need to exclude any file that has ways to write or alter it as root
  * can bypass the permissions check.
  */
-static bool debugfs_is_locked_down(struct inode *inode,
-				   struct file *filp,
-				   const struct file_operations *real_fops)
+static int debugfs_locked_down(struct inode *inode,
+			       struct file *filp,
+			       const struct file_operations *real_fops)
 {
 	if (__kernel_is_confidentiality_mode())
-		return true;
+		return -EPERM;
 
 	if ((inode->i_mode & 07777) == 0444 &&
 	    !(filp->f_mode & FMODE_WRITE) &&
 	    !real_fops->unlocked_ioctl &&
 	    !real_fops->compat_ioctl &&
 	    !real_fops->mmap)
-		return false;
+		return 0;
+
+	if (kernel_is_locked_down("debugfs"))
+		return -EPERM;
 
-	return kernel_is_locked_down("debugfs");
+	return 0;
 }
 
 static int open_proxy_open(struct inode *inode, struct file *filp)
@@ -271,7 +274,7 @@ static int full_proxy_open(struct inode *inode, struct file *filp)
 
 	real_fops = debugfs_real_fops(filp);
 
-	r = debugfs_is_locked_down(inode, filp, real_fops);
+	r = debugfs_locked_down(inode, filp, real_fops);
 	if (r)
 		goto out;
 
-- 
2.13.6

