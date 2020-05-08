Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46E9C1CB011
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728339AbgEHMiL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:38:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:52962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726951AbgEHMiJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:38:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A446E21473;
        Fri,  8 May 2020 12:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941489;
        bh=Lxrqk0639GIY5+sYCjtar44CTjoi4LVfNTlKaP/Wz8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YaenskBzTNKPCnfeYQ2+xjPO6iEPw0C7vtAwFUwsZUBL8gP2hw6W+fL7808RXeVhi
         j8yqYbnnoUlmPyJvXnTvG8+LJAZrKunGu7zUIGpuv9lFoIcQGXs6x7bklFEESMTJuT
         Phi3ZeL/pxX6eXV11gN+EYJh1+wzErnNcGz7Sn9g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.4 051/312] netfilter: nfnetlink: use original skbuff when acking batches
Date:   Fri,  8 May 2020 14:30:42 +0200
Message-Id: <20200508123128.141293657@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 7c7bdf35991bb8f7cfaeaf22ea3a2f2d1967c166 upstream.

Since bd678e09dc17 ("netfilter: nfnetlink: fix splat due to incorrect
socket memory accounting in skbuff clones"), we don't manually attach
the sk to the skbuff clone anymore, so we have to use the original
skbuff from netlink_ack() which needs to access the sk pointer.

Fixes: bd678e09dc17 ("netfilter: nfnetlink: fix splat due to incorrect socket memory accounting in skbuff clones")
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/nfnetlink.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -309,14 +309,14 @@ replay:
 #endif
 		{
 			nfnl_unlock(subsys_id);
-			netlink_ack(skb, nlh, -EOPNOTSUPP);
+			netlink_ack(oskb, nlh, -EOPNOTSUPP);
 			return kfree_skb(skb);
 		}
 	}
 
 	if (!ss->commit || !ss->abort) {
 		nfnl_unlock(subsys_id);
-		netlink_ack(skb, nlh, -EOPNOTSUPP);
+		netlink_ack(oskb, nlh, -EOPNOTSUPP);
 		return kfree_skb(skb);
 	}
 
@@ -406,7 +406,7 @@ ack:
 				 * pointing to the batch header.
 				 */
 				nfnl_err_reset(&err_list);
-				netlink_ack(skb, nlmsg_hdr(oskb), -ENOMEM);
+				netlink_ack(oskb, nlmsg_hdr(oskb), -ENOMEM);
 				status |= NFNL_BATCH_FAILURE;
 				goto done;
 			}


