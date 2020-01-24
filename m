Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE524148474
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:44:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730061AbgAXLJO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:09:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:44746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729188AbgAXLJN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:09:13 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9B8820708;
        Fri, 24 Jan 2020 11:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864152;
        bh=LcaHQk7HlJHcJORtK8v+0Ss5+sdO4zXKEWyscC+SkXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GjeSKMaiuMTtPmCQK9fp72XcOrJcsI9m118pwPCbKMLYE/Gt5E6tW7nNGzef30AWF
         WRAPPv0sqXwqhB43Tl1P1jTqsggkahOBKbx1r9aFYYe3+vBrgoRkfEPS2YixxIeDRg
         Qz33O8lMSIwhqvv37/vRmGL66ihMO+keujgnHx/s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 186/639] xsk: add missing smp_rmb() in xsk_mmap
Date:   Fri, 24 Jan 2020 10:25:56 +0100
Message-Id: <20200124093110.430156249@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

[ Upstream commit e6762c8bcf982821935a2b1cb33cf8335d0eefae ]

All the setup code in AF_XDP is protected by a mutex with the
exception of the mmap code that cannot use it. To make sure that a
process banging on the mmap call at the same time as another process
is setting up the socket, smp_wmb() calls were added in the umem
registration code and the queue creation code, so that the published
structures that xsk_mmap needs would be consistent. However, the
corresponding smp_rmb() calls were not added to the xsk_mmap
code. This patch adds these calls.

Fixes: 37b076933a8e3 ("xsk: add missing write- and data-dependency barrier")
Fixes: c0c77d8fb787c ("xsk: add user memory registration support sockopt")
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xdp/xsk.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index ff15207036dc5..547fc4554b22c 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -661,6 +661,8 @@ static int xsk_mmap(struct file *file, struct socket *sock,
 		if (!umem)
 			return -EINVAL;
 
+		/* Matches the smp_wmb() in XDP_UMEM_REG */
+		smp_rmb();
 		if (offset == XDP_UMEM_PGOFF_FILL_RING)
 			q = READ_ONCE(umem->fq);
 		else if (offset == XDP_UMEM_PGOFF_COMPLETION_RING)
@@ -670,6 +672,8 @@ static int xsk_mmap(struct file *file, struct socket *sock,
 	if (!q)
 		return -EINVAL;
 
+	/* Matches the smp_wmb() in xsk_init_queue */
+	smp_rmb();
 	qpg = virt_to_head_page(q->ring);
 	if (size > (PAGE_SIZE << compound_order(qpg)))
 		return -EINVAL;
-- 
2.20.1



