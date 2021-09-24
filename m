Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1282C417287
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 14:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343874AbhIXMtH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 08:49:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:44452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343934AbhIXMsV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:48:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3CF3A61251;
        Fri, 24 Sep 2021 12:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487608;
        bh=cxH5tFD7r1Kz2FjW7qzGM8lC10WyjahiyZjbszVcCjc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HLlJUxg3apWI4AdYzUYJvjp0bOkywNZcm+InM6h+OGf5FZchhB2B0Y4qqyWbN9z4g
         vkv0eRIjXLmiaIKX7asZ/6Mw9w4gZfh3N3f5nwI/Uff+6Hwtp3wZPcQs/4TgTiYAyS
         f5ATDOQBUSoHYapjDALsThueV5pK5EeMldqGyrTo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ilja Van Sprundel <ivansprundel@ioactive.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 26/26] sctp: validate from_addr_param return
Date:   Fri, 24 Sep 2021 14:44:14 +0200
Message-Id: <20210924124329.210487794@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124328.336953942@linuxfoundation.org>
References: <20210924124328.336953942@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

commit 0c5dc070ff3d6246d22ddd931f23a6266249e3db upstream.

Ilja reported that, simply putting it, nothing was validating that
from_addr_param functions were operating on initialized memory. That is,
the parameter itself was being validated by sctp_walk_params, but it
doesn't check for types and their specific sizes and it could be a 0-length
one, causing from_addr_param to potentially work over the next parameter or
even uninitialized memory.

The fix here is to, in all calls to from_addr_param, check if enough space
is there for the wanted IP address type.

Reported-by: Ilja Van Sprundel <ivansprundel@ioactive.com>
Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/sctp/structs.h |    2 +-
 net/sctp/bind_addr.c       |   20 +++++++++++---------
 net/sctp/input.c           |    6 ++++--
 net/sctp/ipv6.c            |    7 ++++++-
 net/sctp/protocol.c        |    7 ++++++-
 net/sctp/sm_make_chunk.c   |   29 ++++++++++++++++-------------
 6 files changed, 44 insertions(+), 27 deletions(-)

--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -470,7 +470,7 @@ struct sctp_af {
 					 int saddr);
 	void		(*from_sk)	(union sctp_addr *,
 					 struct sock *sk);
-	void		(*from_addr_param) (union sctp_addr *,
+	bool		(*from_addr_param) (union sctp_addr *,
 					    union sctp_addr_param *,
 					    __be16 port, int iif);
 	int		(*to_addr_param) (const union sctp_addr *,
--- a/net/sctp/bind_addr.c
+++ b/net/sctp/bind_addr.c
@@ -285,20 +285,16 @@ int sctp_raw_to_bind_addrs(struct sctp_b
 		rawaddr = (union sctp_addr_param *)raw_addr_list;
 
 		af = sctp_get_af_specific(param_type2af(param->type));
-		if (unlikely(!af)) {
+		if (unlikely(!af) ||
+		    !af->from_addr_param(&addr, rawaddr, htons(port), 0)) {
 			retval = -EINVAL;
-			sctp_bind_addr_clean(bp);
-			break;
+			goto out_err;
 		}
 
-		af->from_addr_param(&addr, rawaddr, htons(port), 0);
 		retval = sctp_add_bind_addr(bp, &addr, sizeof(addr),
 					    SCTP_ADDR_SRC, gfp);
-		if (retval) {
-			/* Can't finish building the list, clean up. */
-			sctp_bind_addr_clean(bp);
-			break;
-		}
+		if (retval)
+			goto out_err;
 
 		len = ntohs(param->length);
 		addrs_len -= len;
@@ -306,6 +302,12 @@ int sctp_raw_to_bind_addrs(struct sctp_b
 	}
 
 	return retval;
+
+out_err:
+	if (retval)
+		sctp_bind_addr_clean(bp);
+
+	return retval;
 }
 
 /********************************************************************
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -1051,7 +1051,8 @@ static struct sctp_association *__sctp_r
 		if (!af)
 			continue;
 
-		af->from_addr_param(paddr, params.addr, sh->source, 0);
+		if (!af->from_addr_param(paddr, params.addr, sh->source, 0))
+			continue;
 
 		asoc = __sctp_lookup_association(net, laddr, paddr, transportp);
 		if (asoc)
@@ -1097,7 +1098,8 @@ static struct sctp_association *__sctp_r
 	if (unlikely(!af))
 		return NULL;
 
-	af->from_addr_param(&paddr, param, peer_port, 0);
+	if (af->from_addr_param(&paddr, param, peer_port, 0))
+		return NULL;
 
 	return __sctp_lookup_association(net, laddr, &paddr, transportp);
 }
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -490,15 +490,20 @@ static void sctp_v6_to_sk_daddr(union sc
 }
 
 /* Initialize a sctp_addr from an address parameter. */
-static void sctp_v6_from_addr_param(union sctp_addr *addr,
+static bool sctp_v6_from_addr_param(union sctp_addr *addr,
 				    union sctp_addr_param *param,
 				    __be16 port, int iif)
 {
+	if (ntohs(param->v6.param_hdr.length) < sizeof(struct sctp_ipv6addr_param))
+		return false;
+
 	addr->v6.sin6_family = AF_INET6;
 	addr->v6.sin6_port = port;
 	addr->v6.sin6_flowinfo = 0; /* BUG */
 	addr->v6.sin6_addr = param->v6.addr;
 	addr->v6.sin6_scope_id = iif;
+
+	return true;
 }
 
 /* Initialize an address parameter from a sctp_addr and return the length
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -274,14 +274,19 @@ static void sctp_v4_to_sk_daddr(union sc
 }
 
 /* Initialize a sctp_addr from an address parameter. */
-static void sctp_v4_from_addr_param(union sctp_addr *addr,
+static bool sctp_v4_from_addr_param(union sctp_addr *addr,
 				    union sctp_addr_param *param,
 				    __be16 port, int iif)
 {
+	if (ntohs(param->v4.param_hdr.length) < sizeof(struct sctp_ipv4addr_param))
+		return false;
+
 	addr->v4.sin_family = AF_INET;
 	addr->v4.sin_port = port;
 	addr->v4.sin_addr.s_addr = param->v4.addr.s_addr;
 	memset(addr->v4.sin_zero, 0, sizeof(addr->v4.sin_zero));
+
+	return true;
 }
 
 /* Initialize an address parameter from a sctp_addr and return the length
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -2342,11 +2342,13 @@ int sctp_process_init(struct sctp_associ
 
 	/* Process the initialization parameters.  */
 	sctp_walk_params(param, peer_init, init_hdr.params) {
-		if (!src_match && (param.p->type == SCTP_PARAM_IPV4_ADDRESS ||
-		    param.p->type == SCTP_PARAM_IPV6_ADDRESS)) {
+		if (!src_match &&
+		    (param.p->type == SCTP_PARAM_IPV4_ADDRESS ||
+		     param.p->type == SCTP_PARAM_IPV6_ADDRESS)) {
 			af = sctp_get_af_specific(param_type2af(param.p->type));
-			af->from_addr_param(&addr, param.addr,
-					    chunk->sctp_hdr->source, 0);
+			if (!af->from_addr_param(&addr, param.addr,
+						 chunk->sctp_hdr->source, 0))
+				continue;
 			if (sctp_cmp_addr_exact(sctp_source(chunk), &addr))
 				src_match = 1;
 		}
@@ -2540,7 +2542,8 @@ static int sctp_process_param(struct sct
 			break;
 do_addr_param:
 		af = sctp_get_af_specific(param_type2af(param.p->type));
-		af->from_addr_param(&addr, param.addr, htons(asoc->peer.port), 0);
+		if (!af->from_addr_param(&addr, param.addr, htons(asoc->peer.port), 0))
+			break;
 		scope = sctp_scope(peer_addr);
 		if (sctp_in_scope(net, &addr, scope))
 			if (!sctp_assoc_add_peer(asoc, &addr, gfp, SCTP_UNCONFIRMED))
@@ -2633,15 +2636,13 @@ do_addr_param:
 		addr_param = param.v + sizeof(sctp_addip_param_t);
 
 		af = sctp_get_af_specific(param_type2af(addr_param->p.type));
-		if (af == NULL)
+		if (!af)
 			break;
 
-		af->from_addr_param(&addr, addr_param,
-				    htons(asoc->peer.port), 0);
+		if (!af->from_addr_param(&addr, addr_param,
+					 htons(asoc->peer.port), 0))
+			break;
 
-		/* if the address is invalid, we can't process it.
-		 * XXX: see spec for what to do.
-		 */
 		if (!af->addr_valid(&addr, NULL, NULL))
 			break;
 
@@ -3053,7 +3054,8 @@ static __be16 sctp_process_asconf_param(
 	if (unlikely(!af))
 		return SCTP_ERROR_DNS_FAILED;
 
-	af->from_addr_param(&addr, addr_param, htons(asoc->peer.port), 0);
+	if (!af->from_addr_param(&addr, addr_param, htons(asoc->peer.port), 0))
+		return SCTP_ERROR_DNS_FAILED;
 
 	/* ADDIP 4.2.1  This parameter MUST NOT contain a broadcast
 	 * or multicast address.
@@ -3318,7 +3320,8 @@ static void sctp_asconf_param_success(st
 
 	/* We have checked the packet before, so we do not check again.	*/
 	af = sctp_get_af_specific(param_type2af(addr_param->p.type));
-	af->from_addr_param(&addr, addr_param, htons(bp->port), 0);
+	if (!af->from_addr_param(&addr, addr_param, htons(bp->port), 0))
+		return;
 
 	switch (asconf_param->param_hdr.type) {
 	case SCTP_PARAM_ADD_IP:


