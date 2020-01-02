Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECE6E12F0CC
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:55:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727984AbgABWzv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:55:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:34452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728077AbgABWSv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:18:51 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCE112253D;
        Thu,  2 Jan 2020 22:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003531;
        bh=tgF6Sbt5iFtppaBm3Np8pjSbN/00wXiEhv1ndWcJCWI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mNjDa/thaUCn6h2RjiVGgYjM6yFlHs6KuiEXtSLADUorwF3Vi1TqHrIW8kavQYgNp
         DBalCkJz674fDm9jTzESq8aPPDHI1LRg2f7qpZkdbjId1xDCOHsGpwkLJanYekHWWK
         gP3uSpQ6xntcf9wZP3iPyasg8UnGLZ4XLIJ/diPo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <gnault@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 170/191] net/dst: add new function skb_dst_update_pmtu_no_confirm
Date:   Thu,  2 Jan 2020 23:07:32 +0100
Message-Id: <20200102215847.522437349@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
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
@@ -519,6 +519,15 @@ static inline void skb_dst_update_pmtu(s
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
 static inline void skb_tunnel_check_pmtu(struct sk_buff *skb,
 					 struct dst_entry *encap_dst,
 					 int headroom)


