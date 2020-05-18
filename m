Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B23161D8654
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729673AbgERRoE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:44:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:42032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729650AbgERRoB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:44:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43F52207C4;
        Mon, 18 May 2020 17:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589823840;
        bh=55PKlhmg1rmfRguUkGNgpg1h9UfCnaM6roGxuu9k3bA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MeHs8rx51KjpLOeGLfBxFioS3orUU6j2CSay1DozoCbChJywlgKCCmz9snO9MUwaF
         LfVXiL52tr45QpJW3xGzbZaiRnhd6hQlhBKlrmr0p0p3X0PCd/nY4RFa8PTdkCBxTt
         q+cAICmtfaFPawRxwTKaPo6LGXBT26BFuUyWaqAo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 56/90] netfilter: conntrack: avoid gcc-10 zero-length-bounds warning
Date:   Mon, 18 May 2020 19:36:34 +0200
Message-Id: <20200518173502.512499313@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.930655662@linuxfoundation.org>
References: <20200518173450.930655662@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 2c407aca64977ede9b9f35158e919773cae2082f ]

gcc-10 warns around a suspicious access to an empty struct member:

net/netfilter/nf_conntrack_core.c: In function '__nf_conntrack_alloc':
net/netfilter/nf_conntrack_core.c:1522:9: warning: array subscript 0 is outside the bounds of an interior zero-length array 'u8[0]' {aka 'unsigned char[0]'} [-Wzero-length-bounds]
 1522 |  memset(&ct->__nfct_init_offset[0], 0,
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from net/netfilter/nf_conntrack_core.c:37:
include/net/netfilter/nf_conntrack.h:90:5: note: while referencing '__nfct_init_offset'
   90 |  u8 __nfct_init_offset[0];
      |     ^~~~~~~~~~~~~~~~~~

The code is correct but a bit unusual. Rework it slightly in a way that
does not trigger the warning, using an empty struct instead of an empty
array. There are probably more elegant ways to do this, but this is the
smallest change.

Fixes: c41884ce0562 ("netfilter: conntrack: avoid zeroing timer")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_conntrack.h | 2 +-
 net/netfilter/nf_conntrack_core.c    | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index b57a9f37c297b..7befec513295d 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -103,7 +103,7 @@ struct nf_conn {
 	struct hlist_node	nat_bysource;
 #endif
 	/* all members below initialized via memset */
-	u8 __nfct_init_offset[0];
+	struct { } __nfct_init_offset;
 
 	/* If we were expected by an expectation, this will be it */
 	struct nf_conn *master;
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 1bdae8f188e1f..d507d0fc7858a 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1124,9 +1124,9 @@ __nf_conntrack_alloc(struct net *net,
 	*(unsigned long *)(&ct->tuplehash[IP_CT_DIR_REPLY].hnnode.pprev) = hash;
 	ct->status = 0;
 	write_pnet(&ct->ct_net, net);
-	memset(&ct->__nfct_init_offset[0], 0,
+	memset(&ct->__nfct_init_offset, 0,
 	       offsetof(struct nf_conn, proto) -
-	       offsetof(struct nf_conn, __nfct_init_offset[0]));
+	       offsetof(struct nf_conn, __nfct_init_offset));
 
 	nf_ct_zone_add(ct, zone);
 
-- 
2.20.1



