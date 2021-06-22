Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 368AA3AFD6E
	for <lists+stable@lfdr.de>; Tue, 22 Jun 2021 08:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbhFVGzT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Jun 2021 02:55:19 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:11078 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbhFVGzT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Jun 2021 02:55:19 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G8H8B0qbpzZhQD;
        Tue, 22 Jun 2021 14:50:02 +0800 (CST)
Received: from dggpemm000003.china.huawei.com (7.185.36.128) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 22 Jun 2021 14:53:02 +0800
Received: from localhost.localdomain (10.67.165.2) by
 dggpemm000003.china.huawei.com (7.185.36.128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 22 Jun 2021 14:53:01 +0800
From:   Zeng Tao <prime.zeng@hisilicon.com>
To:     <prime.zeng@hisilicon.com>
CC:     Alexey Dobriyan <adobriyan@gmail.com>,
        Andi Kleen <andi@firstfloor.org>,
        David Howells <dhowells@redhat.com>, <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH] afs: fix tracepoint string placement with built-in AFS
Date:   Tue, 22 Jun 2021 14:51:37 +0800
Message-ID: <20210622065137.3849512-1-prime.zeng@hisilicon.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.2]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm000003.china.huawei.com (7.185.36.128)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Dobriyan <adobriyan@gmail.com>

I was adding custom tracepoint to the kernel, grabbed full F34 kernel
.config, disabled modules and booted whole shebang as VM kernel.

Then did

	perf record -a -e ...

It crashed:

	general protection fault, probably for non-canonical address 0x435f5346592e4243: 0000 [#1] SMP PTI
	CPU: 1 PID: 842 Comm: cat Not tainted 5.12.6+ #26
	Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-1.fc33 04/01/2014
	RIP: 0010:t_show+0x22/0xd0

Then reproducer was narrowed to

	# cat /sys/kernel/tracing/printk_formats

Original F34 kernel with modules didn't crash.

So I started to disable options and after disabling AFS everything started
working again.

The root cause is that AFS was placing char arrays content into a section
full of _pointers_ to strings with predictable consequences.

Non canonical address 435f5346592e4243 is "CB.YFS_" which came from
CM_NAME macro.

The fix is to create char array and pointer to it separatedly.

Steps to reproduce:

	CONFIG_AFS=y
	CONFIG_TRACING=y

	# cat /sys/kernel/tracing/printk_formats

Link: https://lkml.kernel.org/r/YLAXfvZ+rObEOdc/@localhost.localdomain
Fixes: 8e8d7f13b6d5a9 ("afs: Add some tracepoints")
Signed-off-by: Alexey Dobriyan (SK hynix) <adobriyan@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Howells <dhowells@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 fs/afs/cmservice.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/afs/cmservice.c b/fs/afs/cmservice.c
index d3c6bb22c5f4..d39c63b13d9f 100644
--- a/fs/afs/cmservice.c
+++ b/fs/afs/cmservice.c
@@ -30,8 +30,9 @@ static void SRXAFSCB_TellMeAboutYourself(struct work_struct *);
 static int afs_deliver_yfs_cb_callback(struct afs_call *);
 
 #define CM_NAME(name) \
-	char afs_SRXCB##name##_name[] __tracepoint_string =	\
-		"CB." #name
+	const char afs_SRXCB##name##_name[] = "CB." #name;		\
+	static const char *_afs_SRXCB##name##_name __tracepoint_string =\
+		afs_SRXCB##name##_name
 
 /*
  * CB.CallBack operation type
-- 
2.30.0

