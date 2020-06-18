Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25BCB1FE74A
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729034AbgFRCkD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:40:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:41640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728992AbgFRBMs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:12:48 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD81A21D7E;
        Thu, 18 Jun 2020 01:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442767;
        bh=YoXqK3VwWX/NJk5sqjpoTnUJTm/gb4JObnMUytC2uk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nlJsqIaqZyhgZhOKTa0sm/ptKzCypbD0wVBHD/gZGZvS+xNagDzMeoWwlZqboFnBW
         agxV8l4Oe7Gcna4AGdjvkz4ItJG2pEIq0bZ4ZdnuLFBAXWs1f4gk3vJTr797EeDrx8
         P0KzA+t4wihnxEAD7CedsHM97RmaQSMdXImoxAYY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Feng Tang <feng.tang@intel.com>,
        Corey Minyard <cminyard@mvista.com>,
        Sasha Levin <sashal@kernel.org>,
        openipmi-developer@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.7 216/388] ipmi: use vzalloc instead of kmalloc for user creation
Date:   Wed, 17 Jun 2020 21:05:13 -0400
Message-Id: <20200618010805.600873-216-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Feng Tang <feng.tang@intel.com>

[ Upstream commit 7c47a219b95d0e06b5ef5fcc7bad807895015eac ]

We met mulitple times of failure of staring bmc-watchdog,
due to the runtime memory allocation failure of order 4.

     bmc-watchdog: page allocation failure: order:4, mode:0x40cc0(GFP_KERNEL|__GFP_COMP), nodemask=(null),cpuset=/,mems_allowed=0-1
     CPU: 1 PID: 2571 Comm: bmc-watchdog Not tainted 5.5.0-00045-g7d6bb61d6188c #1
     Hardware name: Intel Corporation S2600WFT/S2600WFT, BIOS SE5C620.86B.00.01.0015.110720180833 11/07/2018
     Call Trace:
      dump_stack+0x66/0x8b
      warn_alloc+0xfe/0x160
      __alloc_pages_slowpath+0xd3e/0xd80
      __alloc_pages_nodemask+0x2f0/0x340
      kmalloc_order+0x18/0x70
      kmalloc_order_trace+0x1d/0xb0
      ipmi_create_user+0x55/0x2c0 [ipmi_msghandler]
      ipmi_open+0x72/0x110 [ipmi_devintf]
      chrdev_open+0xcb/0x1e0
      do_dentry_open+0x1ce/0x380
      path_openat+0x305/0x14f0
      do_filp_open+0x9b/0x110
      do_sys_open+0x1bd/0x250
      do_syscall_64+0x5b/0x1f0
      entry_SYSCALL_64_after_hwframe+0x44/0xa9

Using vzalloc/vfree for creating ipmi_user heals the
problem

Thanks to Stephen Rothwell for finding the vmalloc.h
inclusion issue.

Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/ipmi/ipmi_msghandler.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
index c48d8f086382..9afd220cd824 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -33,6 +33,7 @@
 #include <linux/workqueue.h>
 #include <linux/uuid.h>
 #include <linux/nospec.h>
+#include <linux/vmalloc.h>
 
 #define IPMI_DRIVER_VERSION "39.2"
 
@@ -1153,7 +1154,7 @@ static void free_user_work(struct work_struct *work)
 					      remove_work);
 
 	cleanup_srcu_struct(&user->release_barrier);
-	kfree(user);
+	vfree(user);
 }
 
 int ipmi_create_user(unsigned int          if_num,
@@ -1185,7 +1186,7 @@ int ipmi_create_user(unsigned int          if_num,
 	if (rv)
 		return rv;
 
-	new_user = kmalloc(sizeof(*new_user), GFP_KERNEL);
+	new_user = vzalloc(sizeof(*new_user));
 	if (!new_user)
 		return -ENOMEM;
 
@@ -1232,7 +1233,7 @@ int ipmi_create_user(unsigned int          if_num,
 
 out_kfree:
 	srcu_read_unlock(&ipmi_interfaces_srcu, index);
-	kfree(new_user);
+	vfree(new_user);
 	return rv;
 }
 EXPORT_SYMBOL(ipmi_create_user);
-- 
2.25.1

