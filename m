Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3E414B921
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733302AbgA1O1j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:27:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:55408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733304AbgA1O1h (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:27:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D990121739;
        Tue, 28 Jan 2020 14:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221655;
        bh=pHfKayhJkEP0+Z8XbmIK/wAEZYdTwzNIrJUxBK/RCGY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QvuQ7yvZtLheRmuoSnpvFeVtDUSBVPffGMqdxyuu2HCLH3p4es6MRl5XeEpA1B1sP
         sXzifK6s+uIr0syyAUxTkrbhGqoTH6TH11uXE38t0s/2mgbzQsOq5xXu8EInYnhCih
         dHIj8aHLhCxnxJ+JKuue6d9z/VyEQvEG8CfVkJZI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Petar Penkov <ppenkov@google.com>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 21/92] tun: add mutex_unlock() call and napi.skb clearing in tun_get_user()
Date:   Tue, 28 Jan 2020 15:07:49 +0100
Message-Id: <20200128135811.856076624@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135809.344954797@linuxfoundation.org>
References: <20200128135809.344954797@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 1efba987c48629c0c64703bb4ea76ca1a3771d17 ]

If both IFF_NAPI_FRAGS mode and XDP are enabled, and the XDP program
consumes the skb, we need to clear the napi.skb (or risk
a use-after-free) and release the mutex (or risk a deadlock)

WARNING: lock held when returning to user space!
5.5.0-rc6-syzkaller #0 Not tainted
------------------------------------------------
syz-executor.0/455 is leaving the kernel with locks still held!
1 lock held by syz-executor.0/455:
 #0: ffff888098f6e748 (&tfile->napi_mutex){+.+.}, at: tun_get_user+0x1604/0x3fc0 drivers/net/tun.c:1835

Fixes: 90e33d459407 ("tun: enable napi_gro_frags() for TUN/TAP driver")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: Petar Penkov <ppenkov@google.com>
Cc: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/tun.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1900,6 +1900,10 @@ drop:
 			if (ret != XDP_PASS) {
 				rcu_read_unlock();
 				local_bh_enable();
+				if (frags) {
+					tfile->napi.skb = NULL;
+					mutex_unlock(&tfile->napi_mutex);
+				}
 				return total_len;
 			}
 		}


