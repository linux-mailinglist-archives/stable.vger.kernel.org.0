Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E36DD1D812B
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728737AbgERRpe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:45:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:44408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729936AbgERRpd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:45:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B5EB20671;
        Mon, 18 May 2020 17:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589823932;
        bh=XjSsmsaj+0cGZzRkm6yFrZT7XEPAlcmNRcivnp2RI7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V2jEr/F9y/AjBbczEQYkc0S0N3hjO5ljfi0+SGppjJFDVtMvqTF5VQ5TVBbH8vE5j
         9gB5jstcVJesEacO+r0v+oaJ9yL4GgtY8y9LqyWXrOZCCAiAqsusk1Ecre7cPVHakd
         yqPsbrG4YStUxdDxOgLY6SFOklf++blJOISyRXsM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthew Sheets <matthew.sheets@gd-ms.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Paul Moore <paul@paul-moore.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 69/90] netlabel: cope with NULL catmap
Date:   Mon, 18 May 2020 19:36:47 +0200
Message-Id: <20200518173505.262109414@linuxfoundation.org>
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
@@ -1272,7 +1272,8 @@ static int cipso_v4_parsetag_rbm(const s
 			return ret_val;
 		}
 
-		secattr->flags |= NETLBL_SECATTR_MLS_CAT;
+		if (secattr->attr.mls.cat)
+			secattr->flags |= NETLBL_SECATTR_MLS_CAT;
 	}
 
 	return 0;
@@ -1453,7 +1454,8 @@ static int cipso_v4_parsetag_rng(const s
 			return ret_val;
 		}
 
-		secattr->flags |= NETLBL_SECATTR_MLS_CAT;
+		if (secattr->attr.mls.cat)
+			secattr->flags |= NETLBL_SECATTR_MLS_CAT;
 	}
 
 	return 0;
--- a/net/ipv6/calipso.c
+++ b/net/ipv6/calipso.c
@@ -1061,7 +1061,8 @@ static int calipso_opt_getattr(const uns
 			goto getattr_return;
 		}
 
-		secattr->flags |= NETLBL_SECATTR_MLS_CAT;
+		if (secattr->attr.mls.cat)
+			secattr->flags |= NETLBL_SECATTR_MLS_CAT;
 	}
 
 	secattr->type = NETLBL_NLTYPE_CALIPSO;
--- a/net/netlabel/netlabel_kapi.c
+++ b/net/netlabel/netlabel_kapi.c
@@ -748,6 +748,12 @@ int netlbl_catmap_getlong(struct netlbl_
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


