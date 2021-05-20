Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8B0438A97F
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238214AbhETLDE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:03:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:59128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238750AbhETLBC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 07:01:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C0EC61D0A;
        Thu, 20 May 2021 10:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621505011;
        bh=rZz1ZdBZL2WzTgvLe7/w0Oc3q815CYmWv5pnPMZ73co=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0kUaliJ/TYB/G2PSU9f3G3kpqsQQVBozb9K5IVmM/xv18JFsXINY2FExepQTbBXzX
         4wMRFc8/GpPeiAnXRwop5wEHlQCHX0LD440HG3EzPh8q7SvAlJi2ulL+ZD+l7oBiTD
         0nehfWvq9/mzvRnkJ2nmSThTwvGBSvtp2Xsa/Zag=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 149/240] net: thunderx: Fix unintentional sign extension issue
Date:   Thu, 20 May 2021 11:22:21 +0200
Message-Id: <20210520092113.653804196@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092108.587553970@linuxfoundation.org>
References: <20210520092108.587553970@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit e701a25840360706fe4cf5de0015913ca19c274b ]

The shifting of the u8 integers rq->caching by 26 bits to
the left will be promoted to a 32 bit signed int and then
sign-extended to a u64. In the event that rq->caching is
greater than 0x1f then all then all the upper 32 bits of
the u64 end up as also being set because of the int
sign-extension. Fix this by casting the u8 values to a
u64 before the 26 bit left shift.

Addresses-Coverity: ("Unintended sign extension")
Fixes: 4863dea3fab0 ("net: Adding support for Cavium ThunderX network controller")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cavium/thunder/nicvf_queues.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_queues.c b/drivers/net/ethernet/cavium/thunder/nicvf_queues.c
index 747ef0882976..8f3d544bec0c 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_queues.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_queues.c
@@ -537,7 +537,7 @@ static void nicvf_rcv_queue_config(struct nicvf *nic, struct queue_set *qs,
 	mbx.rq.msg = NIC_MBOX_MSG_RQ_CFG;
 	mbx.rq.qs_num = qs->vnic_id;
 	mbx.rq.rq_num = qidx;
-	mbx.rq.cfg = (rq->caching << 26) | (rq->cq_qs << 19) |
+	mbx.rq.cfg = ((u64)rq->caching << 26) | (rq->cq_qs << 19) |
 			  (rq->cq_idx << 16) | (rq->cont_rbdr_qs << 9) |
 			  (rq->cont_qs_rbdr_idx << 8) |
 			  (rq->start_rbdr_qs << 1) | (rq->start_qs_rbdr_idx);
-- 
2.30.2



