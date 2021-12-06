Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC12469A9E
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:05:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347682AbhLFPJO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:09:14 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56900 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345322AbhLFPHP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:07:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0701B6133C;
        Mon,  6 Dec 2021 15:03:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA11EC341D9;
        Mon,  6 Dec 2021 15:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803025;
        bh=PEyXbukgZr0OOtdejwGzBQ8mOdn5dk7yRZjatk5suwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nIo7o0jjs3pKWMj3JvgqoA3XUTRY8XL/ErgwcHe5DNrDo/wBsIWOU0CALWtCb5EOZ
         TB6zlVVNXW0f5niGnXLvSVrz6aUP6xXJz/lvZPZySpYr94g/3Zi4ws4kzruS/Lpxkk
         jqoLLXeHEj6jOhejbdwJ2C/JysRrZdgqHtDLIgEA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Suryaputra <ssuryaextr@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.9 48/62] vrf: Reset IPCB/IP6CB when processing outbound pkts in vrf dev xmit
Date:   Mon,  6 Dec 2021 15:56:31 +0100
Message-Id: <20211206145550.866469715@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145549.155163074@linuxfoundation.org>
References: <20211206145549.155163074@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Suryaputra <ssuryaextr@gmail.com>

commit ee201011c1e1563c114a55c86eb164b236f18e84 upstream.

IPCB/IP6CB need to be initialized when processing outbound v4 or v6 pkts
in the codepath of vrf device xmit function so that leftover garbage
doesn't cause futher code that uses the CB to incorrectly process the
pkt.

One occasion of the issue might occur when MPLS route uses the vrf
device as the outgoing device such as when the route is added using "ip
-f mpls route add <label> dev <vrf>" command.

The problems seems to exist since day one. Hence I put the day one
commits on the Fixes tags.

Fixes: 193125dbd8eb ("net: Introduce VRF device driver")
Fixes: 35402e313663 ("net: Add IPv6 support to VRF device")
Cc: stable@vger.kernel.org
Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20211130162637.3249-1-ssuryaextr@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vrf.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -226,6 +226,7 @@ static netdev_tx_t vrf_process_v6_outbou
 	/* strip the ethernet header added for pass through VRF device */
 	__skb_pull(skb, skb_network_offset(skb));
 
+	memset(IP6CB(skb), 0, sizeof(*IP6CB(skb)));
 	ret = vrf_ip6_local_out(net, skb->sk, skb);
 	if (unlikely(net_xmit_eval(ret)))
 		dev->stats.tx_errors++;
@@ -332,6 +333,7 @@ static netdev_tx_t vrf_process_v4_outbou
 					       RT_SCOPE_LINK);
 	}
 
+	memset(IPCB(skb), 0, sizeof(*IPCB(skb)));
 	ret = vrf_ip_local_out(dev_net(skb_dst(skb)->dev), skb->sk, skb);
 	if (unlikely(net_xmit_eval(ret)))
 		vrf_dev->stats.tx_errors++;


