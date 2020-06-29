Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D11920E7A4
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbgF2V7H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:59:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:56890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726432AbgF2Sf1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:27 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78D402478F;
        Mon, 29 Jun 2020 15:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444098;
        bh=0yx4bJ3B+m+aCTmdxosbdG7iughP3yPsSPVXS6vM4vg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iOfMOM/wPTMIXXwz7q5FBZr+xa/nzrTtnNVmcHvEs/cQPjU/rLGdbofd6y9pxtnoA
         s1rxBfQaZeqygxc4MBu8HIQTKO6uEbsStnYFp0XM1uz2/UBfAj3DpCynUdYlByHprp
         kjrtmOO8nEdlNQinBR/s8QJvS3rDygzR745zilp4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiri Slaby <jslaby@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
        Brian Gerst <brgerst@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.7 208/265] syscalls: Fix offset type of ksys_ftruncate()
Date:   Mon, 29 Jun 2020 11:17:21 -0400
Message-Id: <20200629151818.2493727-209-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>

commit 8e742aa79780b13cd300a42198c1a4cea9c89905 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/syscalls.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 1815065d52f37..1b0c7813197b0 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -1358,7 +1358,7 @@ static inline long ksys_lchown(const char __user *filename, uid_t user,
 
 extern long do_sys_ftruncate(unsigned int fd, loff_t length, int small);
 
-static inline long ksys_ftruncate(unsigned int fd, unsigned long length)
+static inline long ksys_ftruncate(unsigned int fd, loff_t length)
 {
 	return do_sys_ftruncate(fd, length, 1);
 }
-- 
2.25.1

