Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B479329063
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:09:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242867AbhCAUIN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:08:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:60520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241088AbhCAT4K (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:56:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7DCA65378;
        Mon,  1 Mar 2021 17:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621327;
        bh=19yHZoK3HBP0lkuxRqJoUuivNNBKkBGfXJo4NM9PD30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zKN5CEoen7ebXiaceO5SJgvPBxxaRLcDQ6Z3qvTQ3fi/z5Syki4Z4wPsMqUPC7czd
         xa9C8W2GiK+uvBs2DprZ2xCXcnWYyiuus/ksfRaZeB/4n/TTwZ/IPCPIyZjaI85Wku
         E2POtFG+1D69Tnv6sWapuYLy0+s4CD3FIRlOfUuo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nico@fluxnic.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        patches@armlinux.org.uk, Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH 5.11 476/775] ARM: 9065/1: OABI compat: fix build when EPOLL is not enabled
Date:   Mon,  1 Mar 2021 17:10:44 +0100
Message-Id: <20210301161225.066076417@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit fd749fe4bcb00ad80d9eece709f804bb4ac6bf1e ]

When CONFIG_EPOLL is not set/enabled, sys_oabi-compat.c has build
errors. Fix these by surrounding them with ifdef CONFIG_EPOLL/endif
and providing stubs for the "EPOLL is not set" case.

../arch/arm/kernel/sys_oabi-compat.c: In function 'sys_oabi_epoll_ctl':
../arch/arm/kernel/sys_oabi-compat.c:257:6: error: implicit declaration of function 'ep_op_has_event' [-Werror=implicit-function-declaration]
  257 |  if (ep_op_has_event(op) &&
      |      ^~~~~~~~~~~~~~~
../arch/arm/kernel/sys_oabi-compat.c:264:9: error: implicit declaration of function 'do_epoll_ctl'; did you mean 'sys_epoll_ctl'? [-Werror=implicit-function-declaration]
  264 |  return do_epoll_ctl(epfd, op, fd, &kernel, false);
      |         ^~~~~~~~~~~~

Fixes: c281634c8652 ("ARM: compat: remove KERNEL_DS usage in sys_oabi_epoll_ctl()")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com> # from an lkp .config file
Cc: linux-arm-kernel@lists.infradead.org
Cc: Nicolas Pitre <nico@fluxnic.net>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: patches@armlinux.org.uk
Acked-by: Nicolas Pitre <nico@fluxnic.net>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/kernel/sys_oabi-compat.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm/kernel/sys_oabi-compat.c b/arch/arm/kernel/sys_oabi-compat.c
index 0203e545bbc8d..075a2e0ed2c15 100644
--- a/arch/arm/kernel/sys_oabi-compat.c
+++ b/arch/arm/kernel/sys_oabi-compat.c
@@ -248,6 +248,7 @@ struct oabi_epoll_event {
 	__u64 data;
 } __attribute__ ((packed,aligned(4)));
 
+#ifdef CONFIG_EPOLL
 asmlinkage long sys_oabi_epoll_ctl(int epfd, int op, int fd,
 				   struct oabi_epoll_event __user *event)
 {
@@ -298,6 +299,20 @@ asmlinkage long sys_oabi_epoll_wait(int epfd,
 	kfree(kbuf);
 	return err ? -EFAULT : ret;
 }
+#else
+asmlinkage long sys_oabi_epoll_ctl(int epfd, int op, int fd,
+				   struct oabi_epoll_event __user *event)
+{
+	return -EINVAL;
+}
+
+asmlinkage long sys_oabi_epoll_wait(int epfd,
+				    struct oabi_epoll_event __user *events,
+				    int maxevents, int timeout)
+{
+	return -EINVAL;
+}
+#endif
 
 struct oabi_sembuf {
 	unsigned short	sem_num;
-- 
2.27.0



