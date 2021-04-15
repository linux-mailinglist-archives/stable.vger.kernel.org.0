Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1789360CC6
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 16:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234196AbhDOOy2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 10:54:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:38804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233672AbhDOOws (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 10:52:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 79C41613CC;
        Thu, 15 Apr 2021 14:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498336;
        bh=YuNTBLbC7rEeFr9uHOdBAar3Ew/yx4Ri5rXggYX/TOQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HeRhOjor5XRtPPpNev7rIBBGyLM+Igsr2CcpX03DwcJkvu7CjMJ+Xf1YRF1/UK/8c
         rJjjoIAQyLYqtVpjmXCtpFTRzTlHgBBk01NtMTMhRYyHcW9aTGc8AO/FR6Nam6YxKs
         EFXLLypPrc/ucV5VAHaKxvGupXcUksDm9A4oaZWM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+001516d86dbe88862cec@syzkaller.appspotmail.com,
        Phillip Potter <phil@philpotter.co.uk>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 30/47] net: tun: set tun->dev->addr_len during TUNSETLINK processing
Date:   Thu, 15 Apr 2021 16:47:22 +0200
Message-Id: <20210415144414.429033580@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415144413.487943796@linuxfoundation.org>
References: <20210415144413.487943796@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Phillip Potter <phil@philpotter.co.uk>

commit cca8ea3b05c972ffb5295367e6c544369b45fbdd upstream.

When changing type with TUNSETLINK ioctl command, set tun->dev->addr_len
to match the appropriate type, using new tun_get_addr_len utility function
which returns appropriate address length for given type. Fixes a
KMSAN-found uninit-value bug reported by syzbot at:
https://syzkaller.appspot.com/bug?id=0766d38c656abeace60621896d705743aeefed51

Reported-by: syzbot+001516d86dbe88862cec@syzkaller.appspotmail.com
Diagnosed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/tun.c |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -72,6 +72,14 @@
 #include <linux/seq_file.h>
 #include <linux/uio.h>
 #include <linux/skb_array.h>
+#include <linux/ieee802154.h>
+#include <linux/if_ltalk.h>
+#include <uapi/linux/if_fddi.h>
+#include <uapi/linux/if_hippi.h>
+#include <uapi/linux/if_fc.h>
+#include <net/ax25.h>
+#include <net/rose.h>
+#include <net/6lowpan.h>
 
 #include <asm/uaccess.h>
 
@@ -2021,6 +2029,45 @@ unlock:
 	return ret;
 }
 
+/* Return correct value for tun->dev->addr_len based on tun->dev->type. */
+static unsigned char tun_get_addr_len(unsigned short type)
+{
+	switch (type) {
+	case ARPHRD_IP6GRE:
+	case ARPHRD_TUNNEL6:
+		return sizeof(struct in6_addr);
+	case ARPHRD_IPGRE:
+	case ARPHRD_TUNNEL:
+	case ARPHRD_SIT:
+		return 4;
+	case ARPHRD_ETHER:
+		return ETH_ALEN;
+	case ARPHRD_IEEE802154:
+	case ARPHRD_IEEE802154_MONITOR:
+		return IEEE802154_EXTENDED_ADDR_LEN;
+	case ARPHRD_PHONET_PIPE:
+	case ARPHRD_PPP:
+	case ARPHRD_NONE:
+		return 0;
+	case ARPHRD_6LOWPAN:
+		return EUI64_ADDR_LEN;
+	case ARPHRD_FDDI:
+		return FDDI_K_ALEN;
+	case ARPHRD_HIPPI:
+		return HIPPI_ALEN;
+	case ARPHRD_IEEE802:
+		return FC_ALEN;
+	case ARPHRD_ROSE:
+		return ROSE_ADDR_LEN;
+	case ARPHRD_NETROM:
+		return AX25_ADDR_LEN;
+	case ARPHRD_LOCALTLK:
+		return LTALK_ALEN;
+	default:
+		return 0;
+	}
+}
+
 static long __tun_chr_ioctl(struct file *file, unsigned int cmd,
 			    unsigned long arg, int ifreq_len)
 {
@@ -2159,6 +2206,7 @@ static long __tun_chr_ioctl(struct file
 			ret = -EBUSY;
 		} else {
 			tun->dev->type = (int) arg;
+			tun->dev->addr_len = tun_get_addr_len(tun->dev->type);
 			tun_debug(KERN_INFO, tun, "linktype set to %d\n",
 				  tun->dev->type);
 			ret = 0;


