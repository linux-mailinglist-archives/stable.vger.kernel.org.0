Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24211359AFF
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 12:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233071AbhDIKHM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 06:07:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:50620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233682AbhDIKDr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 06:03:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2426561178;
        Fri,  9 Apr 2021 10:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617962443;
        bh=Ntx4B/gkWdYQiNk75QpdafJc5sL4qmnAOxN5wPYgw+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bg+upDgQPs7vMPgMYkN02NCQpDPKUzdq6Wae2t4ACRcjkMcJXhuA5q06tRRUsa8rc
         gZkGhy2raKAM0jFUW488r9qrU8lKMmYGMnehmwbX4hNQ33QPKo41jIKeHAI7U7jn+F
         NPvNSn6roUHEBmV1JA3CtGB123/LnkEvH4OZ2Oms=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 18/45] netfilter: nftables: skip hook overlap logic if flowtable is stale
Date:   Fri,  9 Apr 2021 11:53:44 +0200
Message-Id: <20210409095305.986446592@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210409095305.397149021@linuxfoundation.org>
References: <20210409095305.397149021@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 86fe2c19eec4728fd9a42ba18f3b47f0d5f9fd7c ]

If the flowtable has been previously removed in this batch, skip the
hook overlap checks. This fixes spurious EEXIST errors when removing and
adding the flowtable in the same batch.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 24a7a6b17268..93d4bb39afb3 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6749,6 +6749,9 @@ static int nft_register_flowtable_net_hooks(struct net *net,
 
 	list_for_each_entry(hook, hook_list, list) {
 		list_for_each_entry(ft, &table->flowtables, list) {
+			if (!nft_is_active_next(net, ft))
+				continue;
+
 			list_for_each_entry(hook2, &ft->hook_list, list) {
 				if (hook->ops.dev == hook2->ops.dev &&
 				    hook->ops.pf == hook2->ops.pf) {
-- 
2.30.2



