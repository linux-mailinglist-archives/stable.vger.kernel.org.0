Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4517B1D81E4
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730704AbgERRvq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:51:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:54668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730740AbgERRvp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:51:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 496F02083E;
        Mon, 18 May 2020 17:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824304;
        bh=apyINV/WR9h+x6sTsPQBpcA3la2uvXtDenbZTh6bPSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zc8ZGneMQYd1qOG0DVmdJK1LKtz58cp6Rmj31PpsZ+m0XXiKxXXy83MdmKH3b96Vf
         qPOAbxwPl85M07vS/A+C+mIbMgjvV8JW5+ljBUNu9rkXAySR58Z4abQgovZk5opcLR
         YqyuTSJP9muOD66OoGuWw92SUm2ouXVmXjGfgaXI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 39/80] netfilter: conntrack: avoid gcc-10 zero-length-bounds warning
Date:   Mon, 18 May 2020 19:36:57 +0200
Message-Id: <20200518173458.224369406@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.097837707@linuxfoundation.org>
References: <20200518173450.097837707@linuxfoundation.org>
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
index f45141bdbb837..ac4d70aeee129 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -85,7 +85,7 @@ struct nf_conn {
 	struct hlist_node	nat_bysource;
 #endif
 	/* all members below initialized via memset */
-	u8 __nfct_init_offset[0];
+	struct { } __nfct_init_offset;
 
 	/* If we were expected by an expectation, this will be it */
 	struct nf_conn *master;
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index c6073d17c3244..ad1da6b2fb607 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1352,9 +1352,9 @@ __nf_conntrack_alloc(struct net *net,
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



