Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2D8222689E
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387413AbgGTQIg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:08:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:46072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387409AbgGTQIf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:08:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5EB9D2065E;
        Mon, 20 Jul 2020 16:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261314;
        bh=KAUBHfNwxbKnzJLcVMk/cSri8349h1Tn/g/QFc3VZ3o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tLR/03Fl4UHyuYL3Yv6uXG/IVujzZjXDMrVablD2T2lmfmiQ0x3hh2hNj5gnvtP8f
         hiXcNJsX9mDgdpDQwz/V5+IvtVa/1krciz1RWH6/LGGZ4ilRWOfP0QFlBATQPHquYK
         4jYsDsTJvuD/lLuFgIkfL/NwkAYRvmPfX/BpmVh4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 070/244] xen/xenbus: Fix a double free in xenbus_map_ring_pv()
Date:   Mon, 20 Jul 2020 17:35:41 +0200
Message-Id: <20200720152829.176928741@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit ba8c423488974f02b538e9dc1730f0334f9b85aa ]

When there is an error the caller frees "info->node" so the free here
will result in a double free.  We should just delete first kfree().

Fixes: 3848e4e0a32a ("xen/xenbus: avoid large structs and arrays on the stack")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20200710113610.GA92345@mwanda
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/xenbus/xenbus_client.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/xen/xenbus/xenbus_client.c b/drivers/xen/xenbus/xenbus_client.c
index 4f168b46fbca5..786fbb7d8be06 100644
--- a/drivers/xen/xenbus/xenbus_client.c
+++ b/drivers/xen/xenbus/xenbus_client.c
@@ -693,10 +693,8 @@ static int xenbus_map_ring_pv(struct xenbus_device *dev,
 	bool leaked;
 
 	area = alloc_vm_area(XEN_PAGE_SIZE * nr_grefs, info->ptes);
-	if (!area) {
-		kfree(node);
+	if (!area)
 		return -ENOMEM;
-	}
 
 	for (i = 0; i < nr_grefs; i++)
 		info->phys_addrs[i] =
-- 
2.25.1



