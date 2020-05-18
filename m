Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D92101D82FC
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731521AbgERSBG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:01:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:43116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731150AbgERSBF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:01:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB269207C4;
        Mon, 18 May 2020 18:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824864;
        bh=vJwxjENKjponhZzinjr7aum5pc/rXKXOdzUWMBC5U60=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yucnuTgu2D6LEY2dsVHLkBKWO1vmWb0nM+Kltaww81eafMi/aKNt3Okp3XW4OgKC1
         NofwQoP4d4osHihWGI5Bz0PaCjwSJNknFjhoKg/HqPfBFzwwsK9vjAI/ihgN6Fq/0U
         CIDKrNAppfJKt+zoInk3JRivBWvnni4xTUwLetVo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthew Sheets <matthew.sheets@gd-ms.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Paul Moore <paul@paul-moore.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 033/194] netlabel: cope with NULL catmap
Date:   Mon, 18 May 2020 19:35:23 +0200
Message-Id: <20200518173534.346207764@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit eead1c2ea2509fd754c6da893a94f0e69e83ebe4 ]

The cipso and calipso code can set the MLS_CAT attribute on
successful parsing, even if the corresponding catmap has
not been allocated, as per current configuration and external
input.

Later, selinux code tries to access the catmap if the MLS_CAT flag
is present via netlbl_catmap_getlong(). That may cause null ptr
dereference while processing incoming network traffic.

Address the issue setting the MLS_CAT flag only if the catmap is
really allocated. Additionally let netlbl_catmap_getlong() cope
with NULL catmap.

Reported-by: Matthew Sheets <matthew.sheets@gd-ms.com>
Fixes: 4b8feff251da ("netlabel: fix the horribly broken catmap functions")
Fixes: ceba1832b1b2 ("calipso: Set the calipso socket label to match the secattr.")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Acked-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/cipso_ipv4.c        |    6 ++++--
 net/ipv6/calipso.c           |    3 ++-
 net/netlabel/netlabel_kapi.c |    6 ++++++
 3 files changed, 12 insertions(+), 3 deletions(-)

--- a/net/ipv4/cipso_ipv4.c
+++ b/net/ipv4/cipso_ipv4.c
@@ -1258,7 +1258,8 @@ static int cipso_v4_parsetag_rbm(const s
 			return ret_val;
 		}
 
-		secattr->flags |= NETLBL_SECATTR_MLS_CAT;
+		if (secattr->attr.mls.cat)
+			secattr->flags |= NETLBL_SECATTR_MLS_CAT;
 	}
 
 	return 0;
@@ -1439,7 +1440,8 @@ static int cipso_v4_parsetag_rng(const s
 			return ret_val;
 		}
 
-		secattr->flags |= NETLBL_SECATTR_MLS_CAT;
+		if (secattr->attr.mls.cat)
+			secattr->flags |= NETLBL_SECATTR_MLS_CAT;
 	}
 
 	return 0;
--- a/net/ipv6/calipso.c
+++ b/net/ipv6/calipso.c
@@ -1047,7 +1047,8 @@ static int calipso_opt_getattr(const uns
 			goto getattr_return;
 		}
 
-		secattr->flags |= NETLBL_SECATTR_MLS_CAT;
+		if (secattr->attr.mls.cat)
+			secattr->flags |= NETLBL_SECATTR_MLS_CAT;
 	}
 
 	secattr->type = NETLBL_NLTYPE_CALIPSO;
--- a/net/netlabel/netlabel_kapi.c
+++ b/net/netlabel/netlabel_kapi.c
@@ -734,6 +734,12 @@ int netlbl_catmap_getlong(struct netlbl_
 	if ((off & (BITS_PER_LONG - 1)) != 0)
 		return -EINVAL;
 
+	/* a null catmap is equivalent to an empty one */
+	if (!catmap) {
+		*offset = (u32)-1;
+		return 0;
+	}
+
 	if (off < catmap->startbit) {
 		off = catmap->startbit;
 		*offset = off;


