Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D298434C898
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233392AbhC2IX3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:23:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:38936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233565AbhC2IVo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:21:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C16C61477;
        Mon, 29 Mar 2021 08:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006104;
        bh=oKF2EdFp4LFU64t6o/t8+Ntpy2+vBZHmEEZlUl2iWFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PgTP5AgTQTc25EmW/Z7wX9bJXzXRpTFyB1rKDHiF2wJa3HDMb4bf9J5O+4g+Mt4qF
         LuqzEbvbFK3UKiMBiWMOcw1FVR9631yKU8hM+7Xue8CCQJF4JnzjlqSXxJ50awKIDt
         gxzZGguIQR2ntMgLy/RP2lSHENIp6gekPxT5GkQg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 119/221] netfilter: ctnetlink: fix dump of the expect mask attribute
Date:   Mon, 29 Mar 2021 09:57:30 +0200
Message-Id: <20210329075633.180770262@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit b58f33d49e426dc66e98ed73afb5d97b15a25f2d ]

Before this change, the mask is never included in the netlink message, so
"conntrack -E expect" always prints 0.0.0.0.

In older kernels the l3num callback struct was passed as argument, based
on tuple->src.l3num. After the l3num indirection got removed, the call
chain is based on m.src.l3num, but this value is 0xffff.

Init l3num to the correct value.

Fixes: f957be9d349a3 ("netfilter: conntrack: remove ctnetlink callbacks from l3 protocol trackers")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_netlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 3d0fd33be018..c1bfd8181341 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2960,6 +2960,7 @@ static int ctnetlink_exp_dump_mask(struct sk_buff *skb,
 	memset(&m, 0xFF, sizeof(m));
 	memcpy(&m.src.u3, &mask->src.u3, sizeof(m.src.u3));
 	m.src.u.all = mask->src.u.all;
+	m.src.l3num = tuple->src.l3num;
 	m.dst.protonum = tuple->dst.protonum;
 
 	nest_parms = nla_nest_start(skb, CTA_EXPECT_MASK);
-- 
2.30.1



