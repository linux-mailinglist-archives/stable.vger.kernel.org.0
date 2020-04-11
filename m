Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80C9D1A5165
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 14:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbgDKMZE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 08:25:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:51514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728337AbgDKMQ7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 08:16:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BBAD22173E;
        Sat, 11 Apr 2020 12:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607419;
        bh=7UERCu65CgP0U500+F+o3KO4ii49B6mhq0xWCr9GZ+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1b5mkGqP2lY+mol2FczUVlFrWRaFy18aCYQKYsY5dsd6bnTWlMgsS2pzlNT7ySK2K
         mtxP8gucIjSZQiuyVc/35PEbGKqlKEo+h6ftL/WJrTV+DzurafHbWtFhv1ATlMa9rb
         YZPymndxd6vUq7KGzKab9k24PgfZ8HH8zjXg+Iys=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Jason Wang <jasowang@redhat.com>, Will Deacon <will@kernel.org>
Subject: [PATCH 5.4 12/41] tun: Dont put_page() for all negative return values from XDP program
Date:   Sat, 11 Apr 2020 14:09:21 +0200
Message-Id: <20200411115504.966396550@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200411115504.124035693@linuxfoundation.org>
References: <20200411115504.124035693@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will@kernel.org>

[ Upstream commit bee348907d19d654e8524d3a946dcd25b693aa7e ]

When an XDP program is installed, tun_build_skb() grabs a reference to
the current page fragment page if the program returns XDP_REDIRECT or
XDP_TX. However, since tun_xdp_act() passes through negative return
values from the XDP program, it is possible to trigger the error path by
mistake and accidentally drop a reference to the fragments page without
taking one, leading to a spurious free. This is believed to be the cause
of some KASAN use-after-free reports from syzbot [1], although without a
reproducer it is not possible to confirm whether this patch fixes the
problem.

Ensure that we only drop a reference to the fragments page if the XDP
transmit or redirect operations actually fail.

[1] https://syzkaller.appspot.com/bug?id=e76a6af1be4acd727ff6bbca669833f98cbf5d95

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
CC: Eric Dumazet <edumazet@google.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Fixes: 8ae1aff0b331 ("tuntap: split out XDP logic")
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/tun.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1715,8 +1715,12 @@ static struct sk_buff *tun_build_skb(str
 			alloc_frag->offset += buflen;
 		}
 		err = tun_xdp_act(tun, xdp_prog, &xdp, act);
-		if (err < 0)
-			goto err_xdp;
+		if (err < 0) {
+			if (act == XDP_REDIRECT || act == XDP_TX)
+				put_page(alloc_frag->page);
+			goto out;
+		}
+
 		if (err == XDP_REDIRECT)
 			xdp_do_flush_map();
 		if (err != XDP_PASS)
@@ -1730,8 +1734,6 @@ static struct sk_buff *tun_build_skb(str
 
 	return __tun_build_skb(tfile, alloc_frag, buf, buflen, len, pad);
 
-err_xdp:
-	put_page(alloc_frag->page);
 out:
 	rcu_read_unlock();
 	local_bh_enable();


