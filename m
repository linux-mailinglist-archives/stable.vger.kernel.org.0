Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71A5029B95F
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:11:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802402AbgJ0PsP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:48:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:56052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1796444AbgJ0PSl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:18:41 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 008922064B;
        Tue, 27 Oct 2020 15:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811920;
        bh=GDDgLjCvdP9hJNwmJ1F7bl4nLQrkpUorMjVj4T51kKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tJDkA8XM1XOrgUu8bs6gmYQ/NdQ6TwIJNXACY3wtz+7c9ACRATv7EvI+B+KGqLiAo
         rr1oGBH8HJnGKLo5VrSnd3pdyfwAgAKWTULEeqYKvq7vfGUCHkCPsc6M9oUTB/iatV
         T5zIqFU/86aZGOOtp0vLKNQ0HQijS5LsLjuy+gJw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Maloy <jmaloy@redhat.com>,
        Hoang Huu Le <hoang.h.le@dektech.com.au>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 029/757] tipc: re-configure queue limit for broadcast link
Date:   Tue, 27 Oct 2020 14:44:39 +0100
Message-Id: <20201027135451.891158496@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hoang Huu Le <hoang.h.le@dektech.com.au>

[ Upstream commit 75cee397ae6f1020fbb75db90aa22a51bc3318ac ]

The queue limit of the broadcast link is being calculated base on initial
MTU. However, when MTU value changed (e.g manual changing MTU on NIC
device, MTU negotiation etc.,) we do not re-calculate queue limit.
This gives throughput does not reflect with the change.

So fix it by calling the function to re-calculate queue limit of the
broadcast link.

Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Hoang Huu Le <hoang.h.le@dektech.com.au>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/bcast.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/net/tipc/bcast.c
+++ b/net/tipc/bcast.c
@@ -108,6 +108,7 @@ static void tipc_bcbase_select_primary(s
 {
 	struct tipc_bc_base *bb = tipc_bc_base(net);
 	int all_dests =  tipc_link_bc_peers(bb->link);
+	int max_win = tipc_link_max_win(bb->link);
 	int i, mtu, prim;
 
 	bb->primary_bearer = INVALID_BEARER_ID;
@@ -121,8 +122,11 @@ static void tipc_bcbase_select_primary(s
 			continue;
 
 		mtu = tipc_bearer_mtu(net, i);
-		if (mtu < tipc_link_mtu(bb->link))
+		if (mtu < tipc_link_mtu(bb->link)) {
 			tipc_link_set_mtu(bb->link, mtu);
+			tipc_link_set_queue_limits(bb->link, max_win,
+						   max_win);
+		}
 		bb->bcast_support &= tipc_bearer_bcast_support(net, i);
 		if (bb->dests[i] < all_dests)
 			continue;


