Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 674342D049C
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 12:52:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729265AbgLFLri (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 06:47:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:42378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729064AbgLFLnD (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Dec 2020 06:43:03 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Wiedmann <jwi@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 03/39] net/af_iucv: set correct sk_protocol for child sockets
Date:   Sun,  6 Dec 2020 12:17:07 +0100
Message-Id: <20201206111554.832788972@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201206111554.677764505@linuxfoundation.org>
References: <20201206111554.677764505@linuxfoundation.org>
User-Agent: quilt/0.66
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
@@ -1785,7 +1785,7 @@ static int iucv_callback_connreq(struct
 	}
 
 	/* Create the new socket */
-	nsk = iucv_sock_alloc(NULL, sk->sk_type, GFP_ATOMIC, 0);
+	nsk = iucv_sock_alloc(NULL, sk->sk_protocol, GFP_ATOMIC, 0);
 	if (!nsk) {
 		err = pr_iucv->path_sever(path, user_data);
 		iucv_path_free(path);
@@ -1991,7 +1991,7 @@ static int afiucv_hs_callback_syn(struct
 		goto out;
 	}
 
-	nsk = iucv_sock_alloc(NULL, sk->sk_type, GFP_ATOMIC, 0);
+	nsk = iucv_sock_alloc(NULL, sk->sk_protocol, GFP_ATOMIC, 0);
 	bh_lock_sock(sk);
 	if ((sk->sk_state != IUCV_LISTEN) ||
 	    sk_acceptq_is_full(sk) ||


