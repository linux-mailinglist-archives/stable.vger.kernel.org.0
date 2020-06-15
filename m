Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B0211F9333
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 11:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729065AbgFOJVo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 05:21:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728865AbgFOJVn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 05:21:43 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEE8AC061A0E;
        Mon, 15 Jun 2020 02:21:43 -0700 (PDT)
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1jklJA-0005qE-LA; Mon, 15 Jun 2020 11:21:36 +0200
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id F20A11C00ED;
        Mon, 15 Jun 2020 11:21:35 +0200 (CEST)
Date:   Mon, 15 Jun 2020 09:21:35 -0000
From:   "tip-bot2 for Jiri Slaby" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] syscalls: Fix offset type of ksys_ftruncate()
Cc:     Jiri Slaby <jslaby@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
        Brian Gerst <brgerst@gmail.com>, stable@vger.kernel.org,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20200610114851.28549-1-jslaby@suse.cz>
References: <20200610114851.28549-1-jslaby@suse.cz>
MIME-Version: 1.0
Message-ID: <159221289568.16989.17711770547953767180.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     8e742aa79780b13cd300a42198c1a4cea9c89905
Gitweb:        https://git.kernel.org/tip/8e742aa79780b13cd300a42198c1a4cea9c89905
Author:        Jiri Slaby <jslaby@suse.cz>
AuthorDate:    Wed, 10 Jun 2020 13:48:51 +02:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Mon, 15 Jun 2020 11:16:27 +02:00

syscalls: Fix offset type of ksys_ftruncate()

After the commit below, truncate() on x86 32bit uses ksys_ftruncate(). But
ksys_ftruncate() truncates the offset to unsigned long.

Switch the type of offset to loff_t which is what do_sys_ftruncate()
expects.

Fixes: 121b32a58a3a (x86/entry/32: Use IA32-specific wrappers for syscalls taking 64-bit arguments)
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Brian Gerst <brgerst@gmail.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20200610114851.28549-1-jslaby@suse.cz
---
 include/linux/syscalls.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 7c354c2..b951a87 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -1360,7 +1360,7 @@ static inline long ksys_lchown(const char __user *filename, uid_t user,
 
 extern long do_sys_ftruncate(unsigned int fd, loff_t length, int small);
 
-static inline long ksys_ftruncate(unsigned int fd, unsigned long length)
+static inline long ksys_ftruncate(unsigned int fd, loff_t length)
 {
 	return do_sys_ftruncate(fd, length, 1);
 }
