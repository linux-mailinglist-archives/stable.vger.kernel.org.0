Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 169311578A1
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:09:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730144AbgBJNJG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:09:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:36988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728936AbgBJMjX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:39:23 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5662124672;
        Mon, 10 Feb 2020 12:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338362;
        bh=i1mSUe6A6LJ4dPfQYfV2aON2tGIaHSNAxEvXsdyOTdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dbsWap5J3SRINMYIGFrmV5SYVS5iQQznsECqeMR6Itiuw+7mZmXM9w9WnJqs7nB7/
         ELNYtMY/oRjqrTP3eXjH15uAzOihk3Is5OS3QwuD5Fx8O9zT2OGKah6BgG8rRUeKdH
         fWaB2kWRXJhUEI0/Dn8vCcPpzj0vHrvXbI5OlcUw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 003/367] gtp: use __GFP_NOWARN to avoid memalloc warning
Date:   Mon, 10 Feb 2020 04:28:36 -0800
Message-Id: <20200210122424.114861507@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit bd5cd35b782abf5437fbd01dfaee12437d20e832 ]

gtp hashtable size is received by user-space.
So, this hashtable size could be too large. If so, kmalloc will internally
print a warning message.
This warning message is actually not necessary for the gtp module.
So, this patch adds __GFP_NOWARN to avoid this message.

Splat looks like:
[ 2171.200049][ T1860] WARNING: CPU: 1 PID: 1860 at mm/page_alloc.c:4713 __alloc_pages_nodemask+0x2f3/0x740
[ 2171.238885][ T1860] Modules linked in: gtp veth openvswitch nsh nf_conncount nf_nat nf_conntrack nf_defrag_ipv]
[ 2171.262680][ T1860] CPU: 1 PID: 1860 Comm: gtp-link Not tainted 5.5.0+ #321
[ 2171.263567][ T1860] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[ 2171.264681][ T1860] RIP: 0010:__alloc_pages_nodemask+0x2f3/0x740
[ 2171.265332][ T1860] Code: 64 fe ff ff 65 48 8b 04 25 c0 0f 02 00 48 05 f0 12 00 00 41 be 01 00 00 00 49 89 47 0
[ 2171.267301][ T1860] RSP: 0018:ffff8880b51af1f0 EFLAGS: 00010246
[ 2171.268320][ T1860] RAX: ffffed1016a35e43 RBX: 0000000000000000 RCX: 0000000000000000
[ 2171.269517][ T1860] RDX: 0000000000000000 RSI: 000000000000000b RDI: 0000000000000000
[ 2171.270305][ T1860] RBP: 0000000000040cc0 R08: ffffed1018893109 R09: dffffc0000000000
[ 2171.275973][ T1860] R10: 0000000000000001 R11: ffffed1018893108 R12: 1ffff11016a35e43
[ 2171.291039][ T1860] R13: 000000000000000b R14: 000000000000000b R15: 00000000000f4240
[ 2171.292328][ T1860] FS:  00007f53cbc83740(0000) GS:ffff8880da000000(0000) knlGS:0000000000000000
[ 2171.293409][ T1860] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2171.294586][ T1860] CR2: 000055f540014508 CR3: 00000000b49f2004 CR4: 00000000000606e0
[ 2171.295424][ T1860] Call Trace:
[ 2171.295756][ T1860]  ? mark_held_locks+0xa5/0xe0
[ 2171.296659][ T1860]  ? __alloc_pages_slowpath+0x21b0/0x21b0
[ 2171.298283][ T1860]  ? gtp_encap_enable_socket+0x13e/0x400 [gtp]
[ 2171.298962][ T1860]  ? alloc_pages_current+0xc1/0x1a0
[ 2171.299475][ T1860]  kmalloc_order+0x22/0x80
[ 2171.299936][ T1860]  kmalloc_order_trace+0x1d/0x140
[ 2171.300437][ T1860]  __kmalloc+0x302/0x3a0
[ 2171.300896][ T1860]  gtp_newlink+0x293/0xba0 [gtp]
[ ... ]

Fixes: 459aa660eb1d ("gtp: add initial driver for datapath of GPRS Tunneling Protocol (GTP-U)")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/gtp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -767,12 +767,12 @@ static int gtp_hashtable_new(struct gtp_
 	int i;
 
 	gtp->addr_hash = kmalloc_array(hsize, sizeof(struct hlist_head),
-				       GFP_KERNEL);
+				       GFP_KERNEL | __GFP_NOWARN);
 	if (gtp->addr_hash == NULL)
 		return -ENOMEM;
 
 	gtp->tid_hash = kmalloc_array(hsize, sizeof(struct hlist_head),
-				      GFP_KERNEL);
+				      GFP_KERNEL | __GFP_NOWARN);
 	if (gtp->tid_hash == NULL)
 		goto err1;
 


