Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13AC61C13A9
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730210AbgEANbw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:31:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:56564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730196AbgEANbv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:31:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8073E24955;
        Fri,  1 May 2020 13:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588339911;
        bh=tTsw+yYwD3xrXKCecdUfo4izDlAh6sniyrh8KljU0Nc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fb2hXHS8RYW93r6kG89ycWAC0moXV3h9IpsjKfdwyTmW+JiASWRzyLLdCuZFCTX+A
         4oHJGxcuxsAnorM/dBx/6pANW6RZa76r3PWx4NAhH2CaCalpFhmc5tn3eOfLO8qLnU
         fzaXilY92eDYkP/F9joPrzJVXHypIKHNr6Fuz3/4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 029/117] net: netrom: Fix potential nr_neigh refcnt leak in nr_add_node
Date:   Fri,  1 May 2020 15:21:05 +0200
Message-Id: <20200501131548.323070885@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131544.291247695@linuxfoundation.org>
References: <20200501131544.291247695@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiyu Yang <xiyuyang19@fudan.edu.cn>

[ Upstream commit d03f228470a8c0a22b774d1f8d47071e0de4f6dd ]

nr_add_node() invokes nr_neigh_get_dev(), which returns a local
reference of the nr_neigh object to "nr_neigh" with increased refcnt.

When nr_add_node() returns, "nr_neigh" becomes invalid, so the refcount
should be decreased to keep refcount balanced.

The issue happens in one normal path of nr_add_node(), which forgets to
decrease the refcnt increased by nr_neigh_get_dev() and causes a refcnt
leak. It should decrease the refcnt before the function returns like
other normal paths do.

Fix this issue by calling nr_neigh_put() before the nr_add_node()
returns.

Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netrom/nr_route.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/netrom/nr_route.c
+++ b/net/netrom/nr_route.c
@@ -199,6 +199,7 @@ static int __must_check nr_add_node(ax25
 		/* refcount initialized at 1 */
 		spin_unlock_bh(&nr_node_list_lock);
 
+		nr_neigh_put(nr_neigh);
 		return 0;
 	}
 	nr_node_lock(nr_node);


