Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69EE01BC888
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728933AbgD1Sd3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:33:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:49890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729930AbgD1Sd2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:33:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3CEF621744;
        Tue, 28 Apr 2020 18:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098807;
        bh=T231jytq/Jjb/V/ng/1HlJWfk3kS0SkG/6ihv0iha88=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hkbMtruTtdt7LRKEXyQ9YeGZMxZ6ZooSAgcsA9Q5zVM0m46QPHGTi5AbEyIH1uBPg
         BOzSNqloRVPhNcWNivWmWdnZkWxMLY45tGjBaSLGHrkikVLcDJCV6948B7RzN8d1RA
         zAsu2tskQZWMuMxob5hNow+jj4CgUDOt6yfSHVpY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 059/131] net: netrom: Fix potential nr_neigh refcnt leak in nr_add_node
Date:   Tue, 28 Apr 2020 20:24:31 +0200
Message-Id: <20200428182232.383045286@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182224.822179290@linuxfoundation.org>
References: <20200428182224.822179290@linuxfoundation.org>
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
@@ -211,6 +211,7 @@ static int __must_check nr_add_node(ax25
 		/* refcount initialized at 1 */
 		spin_unlock_bh(&nr_node_list_lock);
 
+		nr_neigh_put(nr_neigh);
 		return 0;
 	}
 	nr_node_lock(nr_node);


