Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66A101D0DF5
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387675AbgEMJ4u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:56:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:59680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732964AbgEMJ4J (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:56:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01625205ED;
        Wed, 13 May 2020 09:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363768;
        bh=rKeULQkRxUhRHLjybAHWdbegXlR743VjXvWhU6otZ+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OLX7GabJALJe2h+/QeI9rC4H8T48BDQFbGqJUenLsvjSe6sVHqWh/gapmDi8C3Owd
         4sI6etYKQnh53calmDUcBB8XnIqd3f3fddVWh0bwS4GtO7TGwFTh0x/avLfqM229gj
         7384kdaRBtHtaGJwC3NHdE/LAiFoFBjT67ID3NuI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.6 108/118] netfilter: nf_osf: avoid passing pointer to local var
Date:   Wed, 13 May 2020 11:45:27 +0200
Message-Id: <20200513094427.531893899@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094417.618129545@linuxfoundation.org>
References: <20200513094417.618129545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit c165d57b552aaca607fa5daf3fb524a6efe3c5a3 upstream.

gcc-10 points out that a code path exists where a pointer to a stack
variable may be passed back to the caller:

net/netfilter/nfnetlink_osf.c: In function 'nf_osf_hdr_ctx_init':
cc1: warning: function may return address of local variable [-Wreturn-local-addr]
net/netfilter/nfnetlink_osf.c:171:16: note: declared here
  171 |  struct tcphdr _tcph;
      |                ^~~~~

I am not sure whether this can happen in practice, but moving the
variable declaration into the callers avoids the problem.

Fixes: 31a9c29210e2 ("netfilter: nf_osf: add struct nf_osf_hdr_ctx")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/nfnetlink_osf.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/net/netfilter/nfnetlink_osf.c
+++ b/net/netfilter/nfnetlink_osf.c
@@ -165,12 +165,12 @@ static bool nf_osf_match_one(const struc
 static const struct tcphdr *nf_osf_hdr_ctx_init(struct nf_osf_hdr_ctx *ctx,
 						const struct sk_buff *skb,
 						const struct iphdr *ip,
-						unsigned char *opts)
+						unsigned char *opts,
+						struct tcphdr *_tcph)
 {
 	const struct tcphdr *tcp;
-	struct tcphdr _tcph;
 
-	tcp = skb_header_pointer(skb, ip_hdrlen(skb), sizeof(struct tcphdr), &_tcph);
+	tcp = skb_header_pointer(skb, ip_hdrlen(skb), sizeof(struct tcphdr), _tcph);
 	if (!tcp)
 		return NULL;
 
@@ -205,10 +205,11 @@ nf_osf_match(const struct sk_buff *skb,
 	int fmatch = FMATCH_WRONG;
 	struct nf_osf_hdr_ctx ctx;
 	const struct tcphdr *tcp;
+	struct tcphdr _tcph;
 
 	memset(&ctx, 0, sizeof(ctx));
 
-	tcp = nf_osf_hdr_ctx_init(&ctx, skb, ip, opts);
+	tcp = nf_osf_hdr_ctx_init(&ctx, skb, ip, opts, &_tcph);
 	if (!tcp)
 		return false;
 
@@ -265,10 +266,11 @@ bool nf_osf_find(const struct sk_buff *s
 	const struct nf_osf_finger *kf;
 	struct nf_osf_hdr_ctx ctx;
 	const struct tcphdr *tcp;
+	struct tcphdr _tcph;
 
 	memset(&ctx, 0, sizeof(ctx));
 
-	tcp = nf_osf_hdr_ctx_init(&ctx, skb, ip, opts);
+	tcp = nf_osf_hdr_ctx_init(&ctx, skb, ip, opts, &_tcph);
 	if (!tcp)
 		return false;
 


