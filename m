Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7EE32D66BF
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 20:41:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390262AbgLJThu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 14:37:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:36554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390176AbgLJO2v (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:28:51 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Wiedmann <jwi@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.9 01/45] net/af_iucv: set correct sk_protocol for child sockets
Date:   Thu, 10 Dec 2020 15:26:15 +0100
Message-Id: <20201210142602.429421533@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142602.361598591@linuxfoundation.org>
References: <20201210142602.361598591@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>

[ Upstream commit c5dab0941fcdc9664eb0ec0d4d51433216d91336 ]

Child sockets erroneously inherit their parent's sk_type (ie. SOCK_*),
instead of the PF_IUCV protocol that the parent was created with in
iucv_sock_create().

We're currently not using sk->sk_protocol ourselves, so this shouldn't
have much impact (except eg. getting the output in skb_dump() right).

Fixes: eac3731bd04c ("[S390]: Add AF_IUCV socket support")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Link: https://lore.kernel.org/r/20201120100657.34407-1-jwi@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/iucv/af_iucv.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -1753,7 +1753,7 @@ static int iucv_callback_connreq(struct
 	}
 
 	/* Create the new socket */
-	nsk = iucv_sock_alloc(NULL, sk->sk_type, GFP_ATOMIC, 0);
+	nsk = iucv_sock_alloc(NULL, sk->sk_protocol, GFP_ATOMIC, 0);
 	if (!nsk) {
 		err = pr_iucv->path_sever(path, user_data);
 		iucv_path_free(path);
@@ -1963,7 +1963,7 @@ static int afiucv_hs_callback_syn(struct
 		goto out;
 	}
 
-	nsk = iucv_sock_alloc(NULL, sk->sk_type, GFP_ATOMIC, 0);
+	nsk = iucv_sock_alloc(NULL, sk->sk_protocol, GFP_ATOMIC, 0);
 	bh_lock_sock(sk);
 	if ((sk->sk_state != IUCV_LISTEN) ||
 	    sk_acceptq_is_full(sk) ||


