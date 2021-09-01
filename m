Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB71E3FDCBD
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345323AbhIAMxM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:53:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:54330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345335AbhIAMvK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:51:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B63F61248;
        Wed,  1 Sep 2021 12:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630500153;
        bh=sxUAfc4R5j2nxs0JJGqrOQagiwboMjPApeuMEDPL8zA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QkiHBh7bc4EBP3k18OF6BMyGieH8V99Kvaa5DjQJBRPd6aPCmljVj2fhVtPgLEriw
         9CkIYxEggVPCo0KMlzZ5TN4LcHqag6smTUQ4zPUB2ODMvmiQc8KCc8Hh7SsGtmxEmb
         kYUnosXOuH0pEJvi26rXZ0WgcYM92hW2dV7fc1Xw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Collingbourne <pcc@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.14 10/11] net: dont unconditionally copy_from_user a struct ifreq for socket ioctls
Date:   Wed,  1 Sep 2021 14:29:18 +0200
Message-Id: <20210901122249.851652409@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122249.520249736@linuxfoundation.org>
References: <20210901122249.520249736@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Collingbourne <pcc@google.com>

commit d0efb16294d145d157432feda83877ae9d7cdf37 upstream.

A common implementation of isatty(3) involves calling a ioctl passing
a dummy struct argument and checking whether the syscall failed --
bionic and glibc use TCGETS (passing a struct termios), and musl uses
TIOCGWINSZ (passing a struct winsize). If the FD is a socket, we will
copy sizeof(struct ifreq) bytes of data from the argument and return
-EFAULT if that fails. The result is that the isatty implementations
may return a non-POSIX-compliant value in errno in the case where part
of the dummy struct argument is inaccessible, as both struct termios
and struct winsize are smaller than struct ifreq (at least on arm64).

Although there is usually enough stack space following the argument
on the stack that this did not present a practical problem up to now,
with MTE stack instrumentation it's more likely for the copy to fail,
as the memory following the struct may have a different tag.

Fix the problem by adding an early check for whether the ioctl is a
valid socket ioctl, and return -ENOTTY if it isn't.

Fixes: 44c02a2c3dc5 ("dev_ioctl(): move copyin/copyout to callers")
Link: https://linux-review.googlesource.com/id/I869da6cf6daabc3e4b7b82ac979683ba05e27d4d
Signed-off-by: Peter Collingbourne <pcc@google.com>
Cc: <stable@vger.kernel.org> # 4.19
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/netdevice.h |    4 ++++
 net/socket.c              |    6 +++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4012,6 +4012,10 @@ int netdev_rx_handler_register(struct ne
 void netdev_rx_handler_unregister(struct net_device *dev);
 
 bool dev_valid_name(const char *name);
+static inline bool is_socket_ioctl_cmd(unsigned int cmd)
+{
+	return _IOC_TYPE(cmd) == SOCK_IOC_TYPE;
+}
 int dev_ioctl(struct net *net, unsigned int cmd, struct ifreq *ifr,
 		bool *need_copyout);
 int dev_ifconf(struct net *net, struct ifconf *, int);
--- a/net/socket.c
+++ b/net/socket.c
@@ -1109,7 +1109,7 @@ static long sock_do_ioctl(struct net *ne
 		rtnl_unlock();
 		if (!err && copy_to_user(argp, &ifc, sizeof(struct ifconf)))
 			err = -EFAULT;
-	} else {
+	} else if (is_socket_ioctl_cmd(cmd)) {
 		struct ifreq ifr;
 		bool need_copyout;
 		if (copy_from_user(&ifr, argp, sizeof(struct ifreq)))
@@ -1118,6 +1118,8 @@ static long sock_do_ioctl(struct net *ne
 		if (!err && need_copyout)
 			if (copy_to_user(argp, &ifr, sizeof(struct ifreq)))
 				return -EFAULT;
+	} else {
+		err = -ENOTTY;
 	}
 	return err;
 }
@@ -3306,6 +3308,8 @@ static int compat_ifr_data_ioctl(struct
 	struct ifreq ifreq;
 	u32 data32;
 
+	if (!is_socket_ioctl_cmd(cmd))
+		return -ENOTTY;
 	if (copy_from_user(ifreq.ifr_name, u_ifreq32->ifr_name, IFNAMSIZ))
 		return -EFAULT;
 	if (get_user(data32, &u_ifreq32->ifr_data))


