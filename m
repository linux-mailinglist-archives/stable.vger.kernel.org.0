Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1CCF12EFE7
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:50:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728936AbgABWtJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:49:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:55236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729620AbgABW1J (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:27:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B75820863;
        Thu,  2 Jan 2020 22:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578004028;
        bh=k6bgISmFVXAejLhew9BLRgiogl5bQXZsj+xCKYwJyhg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jIM2LRJILMmGa5+YAU4PfOw7emn6c8iRt+rAN/m1j2auR8KSdwK8pKPOBdrgptxky
         y2Cq5d+9USzn4JYquG3J9CboTs4yz08Ud6iffG+2HHEeT7N7HnMAhrRMLD5DdbMg7g
         +2lTUO0PGuqnhOfae7nav2Q/L5vPofyfcgqVDuzs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <gnault@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 82/91] net/dst: add new function skb_dst_update_pmtu_no_confirm
Date:   Thu,  2 Jan 2020 23:08:04 +0100
Message-Id: <20200102220450.485033666@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220356.856162165@linuxfoundation.org>
References: <20200102220356.856162165@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 07dc35c6e3cc3c001915d05f5bf21f80a39a0970 ]

Add a new function skb_dst_update_pmtu_no_confirm() for callers who need
update pmtu but should not do neighbor confirm.

v5: No change.
v4: No change.
v3: Do not remove dst_confirm_neigh, but add a new bool parameter in
    dst_ops.update_pmtu to control whether we should do neighbor confirm.
    Also split the big patch to small ones for each area.
v2: Remove dst_confirm_neigh in __ip6_rt_update_pmtu.

Reviewed-by: Guillaume Nault <gnault@redhat.com>
Acked-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/dst.h |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -531,4 +531,13 @@ static inline void skb_dst_update_pmtu(s
 		dst->ops->update_pmtu(dst, NULL, skb, mtu, true);
 }
 
+/* update dst pmtu but not do neighbor confirm */
+static inline void skb_dst_update_pmtu_no_confirm(struct sk_buff *skb, u32 mtu)
+{
+	struct dst_entry *dst = skb_dst(skb);
+
+	if (dst && dst->ops->update_pmtu)
+		dst->ops->update_pmtu(dst, NULL, skb, mtu, false);
+}
+
 #endif /* _NET_DST_H */


