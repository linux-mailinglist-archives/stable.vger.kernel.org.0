Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF03120D964
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387894AbgF2TrT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:47:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:47680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387794AbgF2Tkj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:40:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8095C248D7;
        Mon, 29 Jun 2020 15:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444431;
        bh=/q+qOelypj9paAncMc+MFV0NSJjRqBqJuUssfTPdSaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RMLkNaB67tOnHOpuffntDWrxYi05mosxj4aYNJbDXTRBUwYAWT4e8K4BBHdpczJyO
         4UBFpPTeUiI1fBylc+01Adlu1U3+oUQUoK2RGavbnZKWvRigh3wrXY+G1HlDJNSodq
         Q15KEpsbI1iNdzfnZ/tlakI1iL+ldLf9p5mT5MCI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 109/178] netfilter: ipset: fix unaligned atomic access
Date:   Mon, 29 Jun 2020 11:24:14 -0400
Message-Id: <20200629152523.2494198-110-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629152523.2494198-1-sashal@kernel.org>
References: <20200629152523.2494198-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.50-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.50-rc1
X-KernelTest-Deadline: 2020-07-01T15:25+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

[ Upstream commit 715028460082d07a7ec6fcd87b14b46784346a72 ]

When using ip_set with counters and comment, traffic causes the kernel
to panic on 32-bit ARM:

Alignment trap: not handling instruction e1b82f9f at [<bf01b0dc>]
Unhandled fault: alignment exception (0x221) at 0xea08133c
PC is at ip_set_match_extensions+0xe0/0x224 [ip_set]

The problem occurs when we try to update the 64-bit counters - the
faulting address above is not 64-bit aligned.  The problem occurs
due to the way elements are allocated, for example:

	set->dsize = ip_set_elem_len(set, tb, 0, 0);
	map = ip_set_alloc(sizeof(*map) + elements * set->dsize);

If the element has a requirement for a member to be 64-bit aligned,
and set->dsize is not a multiple of 8, but is a multiple of four,
then every odd numbered elements will be misaligned - and hitting
an atomic64_add() on that element will cause the kernel to panic.

ip_set_elem_len() must return a size that is rounded to the maximum
alignment of any extension field stored in the element.  This change
ensures that is the case.

Fixes: 95ad1f4a9358 ("netfilter: ipset: Fix extension alignment")
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipset/ip_set_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 75da200aa5d87..133a3f1b6f56c 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -382,6 +382,8 @@ ip_set_elem_len(struct ip_set *set, struct nlattr *tb[], size_t len,
 	for (id = 0; id < IPSET_EXT_ID_MAX; id++) {
 		if (!add_extension(id, cadt_flags, tb))
 			continue;
+		if (align < ip_set_extensions[id].align)
+			align = ip_set_extensions[id].align;
 		len = ALIGN(len, ip_set_extensions[id].align);
 		set->offset[id] = len;
 		set->extensions |= ip_set_extensions[id].type;
-- 
2.25.1

