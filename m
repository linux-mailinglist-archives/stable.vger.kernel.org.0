Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8FED36436F
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240792AbhDSNS0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:18:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:47554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239808AbhDSNQZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:16:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D9E46128C;
        Mon, 19 Apr 2021 13:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618838032;
        bh=LI9j5sJGSRyy67Dz4+2pisjvgfpL1uEl7OCjomsKw/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lUsJQiKxKe+wA+Iotrkhl9/3ZMgdq+ndmZkI6ht6t5a2ZgvLSV7nyekYdl6YSA3Mf
         Bi0fbib/dtri60kvnlvG/GRIfbJLLF3zGOM/RXzIiiaC+IJuyeGh4SZP+oNQxkb+QR
         un7sSW/Zy1Wt8AigirOvOW/1bRqYHunby+GnvLC4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiumei Mu <xmu@redhat.com>,
        Xin Long <lucien.xin@gmail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 019/103] xfrm: BEET mode doesnt support fragments for inner packets
Date:   Mon, 19 Apr 2021 15:05:30 +0200
Message-Id: <20210419130528.451528720@linuxfoundation.org>
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

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 68dc022d04eb0fd60a540e242dcb11ec1bee07e2 ]

BEET mode replaces the IP(6) Headers with new IP(6) Headers when sending
packets. However, when it's a fragment before the replacement, currently
kernel keeps the fragment flag and replace the address field then encaps
it with ESP. It would cause in RX side the fragments to get reassembled
before decapping with ESP, which is incorrect.

In Xiumei's testing, these fragments went over an xfrm interface and got
encapped with ESP in the device driver, and the traffic was broken.

I don't have a good way to fix it, but only to warn this out in dmesg.

Reported-by: Xiumei Mu <xmu@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_output.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index b81ca117dac7..e4cb0ff4dcf4 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -660,6 +660,12 @@ static int xfrm4_extract_output(struct xfrm_state *x, struct sk_buff *skb)
 {
 	int err;
 
+	if (x->outer_mode.encap == XFRM_MODE_BEET &&
+	    ip_is_fragment(ip_hdr(skb))) {
+		net_warn_ratelimited("BEET mode doesn't support inner IPv4 fragments\n");
+		return -EAFNOSUPPORT;
+	}
+
 	err = xfrm4_tunnel_check_size(skb);
 	if (err)
 		return err;
@@ -705,8 +711,15 @@ out:
 static int xfrm6_extract_output(struct xfrm_state *x, struct sk_buff *skb)
 {
 #if IS_ENABLED(CONFIG_IPV6)
+	unsigned int ptr = 0;
 	int err;
 
+	if (x->outer_mode.encap == XFRM_MODE_BEET &&
+	    ipv6_find_hdr(skb, &ptr, NEXTHDR_FRAGMENT, NULL, NULL) >= 0) {
+		net_warn_ratelimited("BEET mode doesn't support inner IPv6 fragments\n");
+		return -EAFNOSUPPORT;
+	}
+
 	err = xfrm6_tunnel_check_size(skb);
 	if (err)
 		return err;
-- 
2.30.2



