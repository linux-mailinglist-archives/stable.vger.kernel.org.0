Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ECB53643C9
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240899AbhDSNVb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:21:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:56846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241384AbhDSNU2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:20:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E9DB613EF;
        Mon, 19 Apr 2021 13:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618838187;
        bh=HNSAbn1dJChIE2tqJjtRXwhmvHD7qjazVNsMwlUNazM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=abPj3s6Ck7KfA86rp97WFthz7zS84qKx11qZvzDHCqtZ1/XIyooWY96gf/GYav+QT
         ekGFsj+SOYBv5Bmx7hs0l7h0ONGP3kiPHRJLfnVHNJp4HQk/qUIRPDtT6AvrlOy512
         W5CphUd1pmcd0U+aa6Dw4k3mf4D0BQAc08Vw44Fs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathon Reinhart <jonathon.reinhart@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 073/103] net: Make tcp_allowed_congestion_control readonly in non-init netns
Date:   Mon, 19 Apr 2021 15:06:24 +0200
Message-Id: <20210419130530.324159057@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130527.791982064@linuxfoundation.org>
References: <20210419130527.791982064@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathon Reinhart <jonathon.reinhart@gmail.com>

commit 97684f0970f6e112926de631fdd98d9693c7e5c1 upstream.

Currently, tcp_allowed_congestion_control is global and writable;
writing to it in any net namespace will leak into all other net
namespaces.

tcp_available_congestion_control and tcp_allowed_congestion_control are
the only sysctls in ipv4_net_table (the per-netns sysctl table) with a
NULL data pointer; their handlers (proc_tcp_available_congestion_control
and proc_allowed_congestion_control) have no other way of referencing a
struct net. Thus, they operate globally.

Because ipv4_net_table does not use designated initializers, there is no
easy way to fix up this one "bad" table entry. However, the data pointer
updating logic shouldn't be applied to NULL pointers anyway, so we
instead force these entries to be read-only.

These sysctls used to exist in ipv4_table (init-net only), but they were
moved to the per-net ipv4_net_table, presumably without realizing that
tcp_allowed_congestion_control was writable and thus introduced a leak.

Because the intent of that commit was only to know (i.e. read) "which
congestion algorithms are available or allowed", this read-only solution
should be sufficient.

The logic added in recent commit
31c4d2f160eb: ("net: Ensure net namespace isolation of sysctls")
does not and cannot check for NULL data pointers, because
other table entries (e.g. /proc/sys/net/netfilter/nf_log/) have
.data=NULL but use other methods (.extra2) to access the struct net.

Fixes: 9cb8e048e5d9 ("net/ipv4/sysctl: show tcp_{allowed, available}_congestion_control in non-initial netns")
Signed-off-by: Jonathon Reinhart <jonathon.reinhart@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/sysctl_net_ipv4.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -1369,9 +1369,19 @@ static __net_init int ipv4_sysctl_init_n
 		if (!table)
 			goto err_alloc;
 
-		/* Update the variables to point into the current struct net */
-		for (i = 0; i < ARRAY_SIZE(ipv4_net_table) - 1; i++)
-			table[i].data += (void *)net - (void *)&init_net;
+		for (i = 0; i < ARRAY_SIZE(ipv4_net_table) - 1; i++) {
+			if (table[i].data) {
+				/* Update the variables to point into
+				 * the current struct net
+				 */
+				table[i].data += (void *)net - (void *)&init_net;
+			} else {
+				/* Entries without data pointer are global;
+				 * Make them read-only in non-init_net ns
+				 */
+				table[i].mode &= ~0222;
+			}
+		}
 	}
 
 	net->ipv4.ipv4_hdr = register_net_sysctl(net, "net/ipv4", table);


