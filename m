Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 031734D5CF
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbfFTSBR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:01:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:50718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727198AbfFTSBR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:01:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6A7E2084A;
        Thu, 20 Jun 2019 18:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561053676;
        bh=U+Fw+56pmtSjJpXkynyZcARIJ3ukFQN6yVeJ/gkDaHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s4k4z47FnnDT3HxbfyJYFvC0hIMWhu9Jyal7DG2TUxz5M8/BSpgVhYAs4HYPV234O
         8vurF3m2xEM+HfIUiUfmQA10JLzPjgOlB+YZAkiX0J2V5WkPZ+jzPsEZ8s99CZl/8Y
         b1hAV9Jhm4uao3O3Dq/WOCtYUB4DkEQpgNZOi66c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 65/84] ipv6: flowlabel: fl6_sock_lookup() must use atomic_inc_not_zero
Date:   Thu, 20 Jun 2019 19:57:02 +0200
Message-Id: <20190620174348.118555462@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174337.538228162@linuxfoundation.org>
References: <20190620174337.538228162@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 65a3c497c0e965a552008db8bc2653f62bc925a1 ]

Before taking a refcount, make sure the object is not already
scheduled for deletion.

Same fix is needed in ipv6_flowlabel_opt()

Fixes: 18367681a10b ("ipv6 flowlabel: Convert np->ipv6_fl_list to RCU.")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_flowlabel.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/net/ipv6/ip6_flowlabel.c
+++ b/net/ipv6/ip6_flowlabel.c
@@ -254,9 +254,9 @@ struct ip6_flowlabel *fl6_sock_lookup(st
 	rcu_read_lock_bh();
 	for_each_sk_fl_rcu(np, sfl) {
 		struct ip6_flowlabel *fl = sfl->fl;
-		if (fl->label == label) {
+
+		if (fl->label == label && atomic_inc_not_zero(&fl->users)) {
 			fl->lastuse = jiffies;
-			atomic_inc(&fl->users);
 			rcu_read_unlock_bh();
 			return fl;
 		}
@@ -622,7 +622,8 @@ int ipv6_flowlabel_opt(struct sock *sk,
 						goto done;
 					}
 					fl1 = sfl->fl;
-					atomic_inc(&fl1->users);
+					if (!atomic_inc_not_zero(&fl1->users))
+						fl1 = NULL;
 					break;
 				}
 			}


