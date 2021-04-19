Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2FC3643B6
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240763AbhDSNVW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:21:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:56988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241154AbhDSNUC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:20:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7345E613E2;
        Mon, 19 Apr 2021 13:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618838144;
        bh=dAF5/SqOJKnqmlYgI+dE0TsDA1M5hV6EL+szpzELn/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0S82r/YzbbXP2rej74QIvGjw2NsA006n4WWDYmpO4qruuMg1Hvv6HxgzckVu6+rMw
         S+hCjeVsxcko5Wgo4ZRbQtT6W3ZgJHvw4cgmGaZtElgGj01DAEnFiGSrJ+5yhbvvUT
         YL9oqAnW87oU/nY6ohs4NlIpIghYkhoAo7za0T10=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.10 058/103] netfilter: flowtable: fix NAT IPv6 offload mangling
Date:   Mon, 19 Apr 2021 15:06:09 +0200
Message-Id: <20210419130529.798526389@linuxfoundation.org>
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 0e07e25b481aa021e4b48085ecb8a049e9614510 upstream.

Fix out-of-bound access in the address array.

Fixes: 5c27d8d76ce8 ("netfilter: nf_flow_table_offload: add IPv6 support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_flow_table_offload.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -305,12 +305,12 @@ static void flow_offload_ipv6_mangle(str
 				     const __be32 *addr, const __be32 *mask)
 {
 	struct flow_action_entry *entry;
-	int i;
+	int i, j;
 
-	for (i = 0; i < sizeof(struct in6_addr) / sizeof(u32); i += sizeof(u32)) {
+	for (i = 0, j = 0; i < sizeof(struct in6_addr) / sizeof(u32); i += sizeof(u32), j++) {
 		entry = flow_action_entry_next(flow_rule);
 		flow_offload_mangle(entry, FLOW_ACT_MANGLE_HDR_TYPE_IP6,
-				    offset + i, &addr[i], mask);
+				    offset + i, &addr[j], mask);
 	}
 }
 


