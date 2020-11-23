Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAF192C0BE5
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:57:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730265AbgKWNci (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:32:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:36968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730241AbgKWM1D (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:27:03 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9ABFC20728;
        Mon, 23 Nov 2020 12:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134423;
        bh=nzfg4Je3v8X3FMgIxzuCOwLQWyWWxmVyGSEI3map3KQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YGw0oXHWMCtDpZ5mpcNizaRZxRSDzvpedsnAwW24xrUaJlVC+D41FoCsibnxy/L/T
         tA7Z2wAblanBFOFXRkpSyFEdjvJZ20bsW/YyzPfqz9Nu1UfemDQ26PuIpinJuNJnml
         MU91u6yeyoJXBYgNMDiQJjuJEtLhvtsqYoVVKU5s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Schiller <ms@dev.tdt.de>,
        Xie He <xie.he.0141@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.14 14/60] net: x25: Increase refcnt of "struct x25_neigh" in x25_rx_call_request
Date:   Mon, 23 Nov 2020 13:21:56 +0100
Message-Id: <20201123121805.721776206@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121805.028396732@linuxfoundation.org>
References: <20201123121805.028396732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xie He <xie.he.0141@gmail.com>

[ Upstream commit 4ee18c179e5e815fa5575e0d2db0c05795a804ee ]

The x25_disconnect function in x25_subr.c would decrease the refcount of
"x25->neighbour" (struct x25_neigh) and reset this pointer to NULL.

However, the x25_rx_call_request function in af_x25.c, which is called
when we receive a connection request, does not increase the refcount when
it assigns the pointer.

Fix this issue by increasing the refcount of "struct x25_neigh" in
x25_rx_call_request.

This patch fixes frequent kernel crashes when using AF_X25 sockets.

Fixes: 4becb7ee5b3d ("net/x25: Fix x25_neigh refcnt leak when x25 disconnect")
Cc: Martin Schiller <ms@dev.tdt.de>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
Link: https://lore.kernel.org/r/20201112103506.5875-1-xie.he.0141@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/x25/af_x25.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -1048,6 +1048,7 @@ int x25_rx_call_request(struct sk_buff *
 	makex25->lci           = lci;
 	makex25->dest_addr     = dest_addr;
 	makex25->source_addr   = source_addr;
+	x25_neigh_hold(nb);
 	makex25->neighbour     = nb;
 	makex25->facilities    = facilities;
 	makex25->dte_facilities= dte_facilities;


