Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB39C29B5FC
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:20:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1796455AbgJ0PSq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:18:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:56236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1796450AbgJ0PSo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:18:44 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC97C22275;
        Tue, 27 Oct 2020 15:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811923;
        bh=slcNo6rQp0yZP8Y3cVBNuNxvl1o0ed4eHlue0K/A/kc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2arfxcRauUXcK6RUDNTnbFQ5jCr19cuU/OVhoTeAJ7U29tFEX3FRD/gXxGgOSO3Bj
         YTu6Jo6hBi5P0txdJzNOgoS/e24r4/wsRgfcEsuFpveO8P+7SN9xdgiF/4PwTsjzfx
         NG3iheBW7/NS6CYpq28sib7e22zba0wj0ka8Bm2g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Maloy <jmaloy@redhat.com>,
        Hoang Huu Le <hoang.h.le@dektech.com.au>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 030/757] tipc: fix incorrect setting window for bcast link
Date:   Tue, 27 Oct 2020 14:44:40 +0100
Message-Id: <20201027135451.938463545@linuxfoundation.org>
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

[ Upstream commit ec78e31852c9bb7d96b6557468fecb6f6f3b28f3 ]

In commit 16ad3f4022bb
("tipc: introduce variable window congestion control"), we applied
the algorithm to select window size from minimum window to the
configured maximum window for unicast link, and, besides we chose
to keep the window size for broadcast link unchanged and equal (i.e
fix window 50)

However, when setting maximum window variable via command, the window
variable was re-initialized to unexpect value (i.e 32).

We fix this by updating the fix window for broadcast as we stated.

Fixes: 16ad3f4022bb ("tipc: introduce variable window congestion control")
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Hoang Huu Le <hoang.h.le@dektech.com.au>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/bcast.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/tipc/bcast.c
+++ b/net/tipc/bcast.c
@@ -109,6 +109,7 @@ static void tipc_bcbase_select_primary(s
 	struct tipc_bc_base *bb = tipc_bc_base(net);
 	int all_dests =  tipc_link_bc_peers(bb->link);
 	int max_win = tipc_link_max_win(bb->link);
+	int min_win = tipc_link_min_win(bb->link);
 	int i, mtu, prim;
 
 	bb->primary_bearer = INVALID_BEARER_ID;
@@ -124,7 +125,8 @@ static void tipc_bcbase_select_primary(s
 		mtu = tipc_bearer_mtu(net, i);
 		if (mtu < tipc_link_mtu(bb->link)) {
 			tipc_link_set_mtu(bb->link, mtu);
-			tipc_link_set_queue_limits(bb->link, max_win,
+			tipc_link_set_queue_limits(bb->link,
+						   min_win,
 						   max_win);
 		}
 		bb->bcast_support &= tipc_bearer_bcast_support(net, i);
@@ -589,7 +591,7 @@ static int tipc_bc_link_set_queue_limits
 	if (max_win > TIPC_MAX_LINK_WIN)
 		return -EINVAL;
 	tipc_bcast_lock(net);
-	tipc_link_set_queue_limits(l, BCLINK_WIN_MIN, max_win);
+	tipc_link_set_queue_limits(l, tipc_link_min_win(l), max_win);
 	tipc_bcast_unlock(net);
 	return 0;
 }


