Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E62435BEFB
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239167AbhDLJCc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:02:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:49340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239577AbhDLJAr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:00:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0ADE61366;
        Mon, 12 Apr 2021 08:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217908;
        bh=6hMHcfNsXegBxvicubT+G0krRqp7yljon99rLrdlMbQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gFU9egHtTOv3pyMxpDXRCY8fDzWRacpDyh4UGJOxXwefGWqqyX8sQK2EuVFhnlk34
         wZ6bD7XHsVC6R0CJRrgMZcnhQk/4gC431EUBp+Uqyb2VvRI9/lIhyTRCpbFDRWaenu
         j/UY4bh7aLj8k4zlr28bjia7IVkAdfC52HbE+4Pc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+001516d86dbe88862cec@syzkaller.appspotmail.com,
        Phillip Potter <phil@philpotter.co.uk>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 176/188] net: tun: set tun->dev->addr_len during TUNSETLINK processing
Date:   Mon, 12 Apr 2021 10:41:30 +0200
Message-Id: <20210412084019.483778757@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
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
@@ -69,6 +69,14 @@
 #include <linux/bpf.h>
 #include <linux/bpf_trace.h>
 #include <linux/mutex.h>
+#include <linux/ieee802154.h>
+#include <linux/if_ltalk.h>
+#include <uapi/linux/if_fddi.h>
+#include <uapi/linux/if_hippi.h>
+#include <uapi/linux/if_fc.h>
+#include <net/ax25.h>
+#include <net/rose.h>
+#include <net/6lowpan.h>
 
 #include <linux/uaccess.h>
 #include <linux/proc_fs.h>
@@ -2978,6 +2986,45 @@ static int tun_set_ebpf(struct tun_struc
 	return __tun_set_ebpf(tun, prog_p, prog);
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
@@ -3133,6 +3180,7 @@ static long __tun_chr_ioctl(struct file
 			ret = -EBUSY;
 		} else {
 			tun->dev->type = (int) arg;
+			tun->dev->addr_len = tun_get_addr_len(tun->dev->type);
 			netif_info(tun, drv, tun->dev, "linktype set to %d\n",
 				   tun->dev->type);
 			ret = 0;


