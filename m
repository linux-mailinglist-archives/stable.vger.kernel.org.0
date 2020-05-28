Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DBDB1E6981
	for <lists+stable@lfdr.de>; Thu, 28 May 2020 20:37:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405792AbgE1Sgw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 May 2020 14:36:52 -0400
Received: from mail.asbjorn.biz ([185.38.24.25]:36522 "EHLO mail.asbjorn.biz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405932AbgE1Sgp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 May 2020 14:36:45 -0400
Received: from x201s.roaming.asbjorn.biz (space.labitat.dk [185.38.175.0])
        by mail.asbjorn.biz (Postfix) with ESMTPSA id 54E411C29736;
        Thu, 28 May 2020 18:31:27 +0000 (UTC)
Received: by x201s.roaming.asbjorn.biz (Postfix, from userid 1000)
        id 84198204CBA; Thu, 28 May 2020 18:30:58 +0000 (UTC)
From:   Asbjoern Sloth Toennesen <asbjorn@asbjorn.st>
To:     stable@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        "Dmitry V . Levin" <ldv@altlinux.org>,
        Giuliano Procida <gprocida@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Asbjoern Sloth Toennesen <asbjorn@asbjorn.st>
Subject: [PATCH 4.4] uapi: fix linux/if_pppol2tp.h userspace compilation errors
Date:   Thu, 28 May 2020 18:30:40 +0000
Message-Id: <20200528183040.14557-1-asbjorn@asbjorn.st>
X-Mailer: git-send-email 2.27.0.rc2
MIME-Version: 1.0
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

Fixes: a471a623e780 ("net: l2tp: deprecate PPPOL2TP_MSG_* in favour of L2TP_MSG_*")
Signed-off-by: Dmitry V. Levin <ldv@altlinux.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Asbjoern Sloth Toennesen <asbjorn@asbjorn.st>
---

Notes:
    Sorry for not submitting this in the review cycle,
    was waiting for a response to my initial mail,
    when the cycle was cut short, had planned to
    reply to the review if I hadn't got a reply half
    way through it.
    
    https://lore.kernel.org/stable/25373712-4390-5a7a-d3f9-97bd7f2d8a2a@asbjorn.st/
    
    I was unsure which commit, to put in Fixes:,
    ended up with the stable commit, and not the
    one from mainline. I hope that's correct.
    
    Original patch thread:
    https://lore.kernel.org/netdev/20170214103353.GA8394@altlinux.org/

 include/uapi/linux/l2tp.h | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/l2tp.h b/include/uapi/linux/l2tp.h
index dedfb2b1832a..c3a5c99f565b 100644
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
-- 
2.27.0.rc2

