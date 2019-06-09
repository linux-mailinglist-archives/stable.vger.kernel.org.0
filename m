Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 404743A6E8
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 18:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729242AbfFIQoZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:44:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:41482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729226AbfFIQoW (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:44:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6A8C2083D;
        Sun,  9 Jun 2019 16:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560098662;
        bh=IbZY1wu0VIF6IEEECk34YajSJdzWdpQU43F8PIme+90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cmDgqHXNvtrmrOuqGrMlErWQtWjmSZMrS9fJ/DvwJbsiEq7xU7ETxIklNc5rtbj9U
         ilBZX2HHcePsHiNjtmrCQTKG2MgaSkfTMzNqlI4bsIUyJHQz7U3MItCDfOfh2kP9wC
         Ba9T8RfuIlNtL1n5wLIr39keIVFsoELgJowdQg8g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ian Kumlien <ian.kumlien@gmail.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        David Ahern <dsahern@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.1 16/70] neighbor: Reset gc_entries counter if new entry is released before insert
Date:   Sun,  9 Jun 2019 18:41:27 +0200
Message-Id: <20190609164128.410311194@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164127.541128197@linuxfoundation.org>
References: <20190609164127.541128197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

[ Upstream commit 64c6f4bbca748c3b2101469a76d88b7cd1c00476 ]

Ian and Alan both reported seeing overflows after upgrades to 5.x kernels:
  neighbour: arp_cache: neighbor table overflow!

Alan's mpls script helped get to the bottom of this bug. When a new entry
is created the gc_entries counter is bumped in neigh_alloc to check if a
new one is allowed to be created. ___neigh_create then searches for an
existing entry before inserting the just allocated one. If an entry
already exists, the new one is dropped in favor of the existing one. In
this case the cleanup path needs to drop the gc_entries counter. There
is no memory leak, only a counter leak.

Fixes: 58956317c8d ("neighbor: Improve garbage collection")
Reported-by: Ian Kumlien <ian.kumlien@gmail.com>
Reported-by: Alan Maguire <alan.maguire@oracle.com>
Signed-off-by: David Ahern <dsahern@gmail.com>
Tested-by: Alan Maguire <alan.maguire@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/neighbour.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -663,6 +663,8 @@ out:
 out_tbl_unlock:
 	write_unlock_bh(&tbl->lock);
 out_neigh_release:
+	if (!exempt_from_gc)
+		atomic_dec(&tbl->gc_entries);
 	neigh_release(n);
 	goto out;
 }


