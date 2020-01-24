Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADF6E147C1A
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:49:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387512AbgAXJtG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:49:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:49378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729742AbgAXJtF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:49:05 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E15121556;
        Fri, 24 Jan 2020 09:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579859344;
        bh=McWs+vOCyTIqBCh2db79s2xpHQc21FuNXG+wF9N0eB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JiNQ4oxCc7eSfYP73rG0oPxor0wi9QOQO7XkwlcTfKk7QvBuytS9tvpGQVeIDbV2e
         dXWQVMnXZQHaOlhi+erW10LoTaBSgri9xDM1puWHV9e0LuPpNK9mnPXfDr31vQ3vxH
         bZZPmDd5z5QcXeM7mW9lWGqSurjDz5KWV8lRol4I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steve Wise <swise@opengridcomputing.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 097/343] iw_cxgb4: use tos when importing the endpoint
Date:   Fri, 24 Jan 2020 10:28:35 +0100
Message-Id: <20200124092932.816159570@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve Wise <swise@opengridcomputing.com>

[ Upstream commit cb3ba0bde881f0cb7e3945d2a266901e2bd18c92 ]

import_ep() is passed the correct tos, but doesn't use it correctly.

Fixes: ac8e4c69a021 ("cxgb4/iw_cxgb4: TOS support")
Signed-off-by: Steve Wise <swise@opengridcomputing.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 3668cc71b47e2..942403e42dd0f 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -2056,7 +2056,7 @@ static int import_ep(struct c4iw_ep *ep, int iptype, __u8 *peer_ip,
 	} else {
 		pdev = get_real_dev(n->dev);
 		ep->l2t = cxgb4_l2t_get(cdev->rdev.lldi.l2t,
-					n, pdev, 0);
+					n, pdev, rt_tos2priority(tos));
 		if (!ep->l2t)
 			goto out;
 		ep->mtu = dst_mtu(dst);
-- 
2.20.1



