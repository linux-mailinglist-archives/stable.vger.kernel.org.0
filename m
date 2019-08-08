Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80926869F8
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 21:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405483AbfHHTL2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 15:11:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:46036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405479AbfHHTL1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 15:11:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6A3A208C3;
        Thu,  8 Aug 2019 19:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565291486;
        bh=j5jpMjo5oEaoUSdMS8Fct4KzjrEEhl9gdTlH/ZDSijY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0PlyTUmeNbbclV3uhqXOIfJM2s6Pjm9WQ1X2G5l9iqRcehhkX8hmFDC/de94lSwFC
         /H5UNMx17rYSaFaJRDf3d1/OO79HXWG/HSHVzuNjJa48hHwS8vrRUhJBZz6X/eq/hH
         QMFM8cX00cSTy4qirLPCxSIcitnRom+0tPc12xs0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexis Bauvin <abauvin@scaleway.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 25/33] tun: mark small packets as owned by the tap sock
Date:   Thu,  8 Aug 2019 21:05:32 +0200
Message-Id: <20190808190454.870452369@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808190453.582417307@linuxfoundation.org>
References: <20190808190453.582417307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexis Bauvin <abauvin@scaleway.com>

[ Upstream commit 4b663366246be1d1d4b1b8b01245b2e88ad9e706 ]

- v1 -> v2: Move skb_set_owner_w to __tun_build_skb to reduce patch size

Small packets going out of a tap device go through an optimized code
path that uses build_skb() rather than sock_alloc_send_pskb(). The
latter calls skb_set_owner_w(), but the small packet code path does not.

The net effect is that small packets are not owned by the userland
application's socket (e.g. QEMU), while large packets are.
This can be seen with a TCP session, where packets are not owned when
the window size is small enough (around PAGE_SIZE), while they are once
the window grows (note that this requires the host to support virtio
tso for the guest to offload segmentation).
All this leads to inconsistent behaviour in the kernel, especially on
netfilter modules that uses sk->socket (e.g. xt_owner).

Fixes: 66ccbc9c87c2 ("tap: use build_skb() for small packet")
Signed-off-by: Alexis Bauvin <abauvin@scaleway.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/tun.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1350,6 +1350,7 @@ static struct sk_buff *tun_build_skb(str
 
 	skb_reserve(skb, pad - delta);
 	skb_put(skb, len + delta);
+	skb_set_owner_w(skb, tfile->socket.sk);
 	get_page(alloc_frag->page);
 	alloc_frag->offset += buflen;
 


