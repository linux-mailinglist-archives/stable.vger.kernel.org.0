Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B44231EAF39
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 21:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728547AbgFATAQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 15:00:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:37148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728619AbgFAR4g (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 13:56:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D3E0206E2;
        Mon,  1 Jun 2020 17:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034196;
        bh=1Pm6gaFiAxl5+Jo1O7iSY7cXigm9jLrMs2GVPLwkq48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pgILq50OjFhayT3FL+AEO7MBBrAMncYTcSVj0zMvUekO/gkiYOihYqo90Iov5FPox
         sg1G3jcxQgLkhKHZpiKQtg+oypvGvRdH22TBduTc54Hjnel3aCEw5SrOf0Em43lPDm
         Z93T05ioI0vCn8PZnJtqDolLcmMV2kmGVoPaNLmo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Dmitry V. Levin" <ldv@altlinux.org>,
        "David S. Miller" <davem@davemloft.net>,
        Asbjoern Sloth Toennesen <asbjorn@asbjorn.st>
Subject: [PATCH 4.4 07/48] uapi: fix linux/if_pppol2tp.h userspace compilation errors
Date:   Mon,  1 Jun 2020 19:53:17 +0200
Message-Id: <20200601173954.188258319@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601173952.175939894@linuxfoundation.org>
References: <20200601173952.175939894@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry V. Levin <ldv@altlinux.org>

commit a725eb15db80643a160310ed6bcfd6c5a6c907f2 upstream.

Because of <linux/libc-compat.h> interface limitations, <netinet/in.h>
provided by libc cannot be included after <linux/in.h>, therefore any
header that includes <netinet/in.h> cannot be included after <linux/in.h>.

Change uapi/linux/l2tp.h, the last uapi header that includes
<netinet/in.h>, to include <linux/in.h> and <linux/in6.h> instead of
<netinet/in.h> and use __SOCK_SIZE__ instead of sizeof(struct sockaddr)
the same way as uapi/linux/in.h does, to fix linux/if_pppol2tp.h userspace
compilation errors like this:

In file included from /usr/include/linux/l2tp.h:12:0,
                 from /usr/include/linux/if_pppol2tp.h:21,
/usr/include/netinet/in.h:31:8: error: redefinition of 'struct in_addr'

Fixes: 47c3e7783be4 ("net: l2tp: deprecate PPPOL2TP_MSG_* in favour of L2TP_MSG_*")
Signed-off-by: Dmitry V. Levin <ldv@altlinux.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Asbjoern Sloth Toennesen <asbjorn@asbjorn.st>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/l2tp.h |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/include/uapi/linux/l2tp.h
+++ b/include/uapi/linux/l2tp.h
@@ -9,9 +9,8 @@
 
 #include <linux/types.h>
 #include <linux/socket.h>
-#ifndef __KERNEL__
-#include <netinet/in.h>
-#endif
+#include <linux/in.h>
+#include <linux/in6.h>
 
 #define IPPROTO_L2TP		115
 
@@ -31,7 +30,7 @@ struct sockaddr_l2tpip {
 	__u32		l2tp_conn_id;	/* Connection ID of tunnel */
 
 	/* Pad to size of `struct sockaddr'. */
-	unsigned char	__pad[sizeof(struct sockaddr) -
+	unsigned char	__pad[__SOCK_SIZE__ -
 			      sizeof(__kernel_sa_family_t) -
 			      sizeof(__be16) - sizeof(struct in_addr) -
 			      sizeof(__u32)];


