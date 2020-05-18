Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01AFB1D86F1
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729263AbgERRlY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:41:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:37650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728622AbgERRlY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:41:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CBAEC207C4;
        Mon, 18 May 2020 17:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589823682;
        bh=JqRgiC5oYKqAVpV4yT7oxR7d3y6q8ssrO6NFSNzpyT4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pf8Nx2EIjoTYIsQW0reBYxgCgs/4peMnXWlSJLyfQ1wGmRe++V8Gr19elSqq5d6Ag
         L5t2S+GOXj3krCWAF78HgAONLjaB9ojWsono2537lPAQGwenLqA+A2IuJ3RWMkivGS
         f2ljdXZI4dv45BawbHy6HgJUL119QdTAREfyCzXQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 53/86] netfilter: conntrack: avoid gcc-10 zero-length-bounds warning
Date:   Mon, 18 May 2020 19:36:24 +0200
Message-Id: <20200518173501.293333661@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.254571947@linuxfoundation.org>
References: <20200518173450.254571947@linuxfoundation.org>
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
index 636e9e11bd5f6..e3f73fd1d53a9 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -98,7 +98,7 @@ struct nf_conn {
 	possible_net_t ct_net;
 
 	/* all members below initialized via memset */
-	u8 __nfct_init_offset[0];
+	struct { } __nfct_init_offset;
 
 	/* If we were expected by an expectation, this will be it */
 	struct nf_conn *master;
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index de0aad12b91d2..e58516274e86a 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -898,9 +898,9 @@ __nf_conntrack_alloc(struct net *net,
 	/* Don't set timer yet: wait for confirmation */
 	setup_timer(&ct->timeout, death_by_timeout, (unsigned long)ct);
 	write_pnet(&ct->ct_net, net);
-	memset(&ct->__nfct_init_offset[0], 0,
+	memset(&ct->__nfct_init_offset, 0,
 	       offsetof(struct nf_conn, proto) -
-	       offsetof(struct nf_conn, __nfct_init_offset[0]));
+	       offsetof(struct nf_conn, __nfct_init_offset));
 
 	if (zone && nf_ct_zone_add(ct, GFP_ATOMIC, zone) < 0)
 		goto out_free;
-- 
2.20.1



