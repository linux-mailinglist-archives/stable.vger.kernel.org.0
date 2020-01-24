Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3F251483A3
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:37:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404259AbgAXLak (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:30:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:48488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404254AbgAXLai (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:30:38 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A602320718;
        Fri, 24 Jan 2020 11:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865438;
        bh=Uh4aNxe8/JAx3JLzX6OWoRpKzrnZEiNXfmgqLwdzFY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2ccKSdRvkNaBuqpjblcFNjwZrLGnvC+u/pMSb2Pg+nDOFHDWDDfSg4uDiwWu8MCrN
         D3FaOHNoTMiIvNtgatG+gy7iJ0HY5bcPaMguchUcMjbEUf7hSZyvcTfCE7/kgyomAE
         iUvdoIyGsu/eCSoxtih2ovyq6hM2+i4RfX+y31ac=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 538/639] netfilter: ctnetlink: honor IPS_OFFLOAD flag
Date:   Fri, 24 Jan 2020 10:31:48 +0100
Message-Id: <20200124093156.417764754@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit b067fa009c884401d23846251031c1f14d8a9c77 ]

If this flag is set, timeout and state are irrelevant to userspace.

Fixes: 90964016e5d3 ("netfilter: nf_conntrack: add IPS_OFFLOAD status bit")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_netlink.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 7ba9ea55816a6..31fa94064a620 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -555,10 +555,8 @@ ctnetlink_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 		goto nla_put_failure;
 
 	if (ctnetlink_dump_status(skb, ct) < 0 ||
-	    ctnetlink_dump_timeout(skb, ct) < 0 ||
 	    ctnetlink_dump_acct(skb, ct, type) < 0 ||
 	    ctnetlink_dump_timestamp(skb, ct) < 0 ||
-	    ctnetlink_dump_protoinfo(skb, ct) < 0 ||
 	    ctnetlink_dump_helpinfo(skb, ct) < 0 ||
 	    ctnetlink_dump_mark(skb, ct) < 0 ||
 	    ctnetlink_dump_secctx(skb, ct) < 0 ||
@@ -570,6 +568,11 @@ ctnetlink_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 	    ctnetlink_dump_ct_synproxy(skb, ct) < 0)
 		goto nla_put_failure;
 
+	if (!test_bit(IPS_OFFLOAD_BIT, &ct->status) &&
+	    (ctnetlink_dump_timeout(skb, ct) < 0 ||
+	     ctnetlink_dump_protoinfo(skb, ct) < 0))
+		goto nla_put_failure;
+
 	nlmsg_end(skb, nlh);
 	return skb->len;
 
-- 
2.20.1



