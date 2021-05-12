Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7542237C26D
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232131AbhELPKk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:10:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:40116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233171AbhELPHp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:07:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4181460FD9;
        Wed, 12 May 2021 15:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831693;
        bh=eQMiB53PicIdJXpFMNc3vMzAc7A6RZclgmj9yjZ1wKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lCsEi8PP08ztoUD9glNlby+vFNLgq7okCJaK/GbLGPPSEGqL0YIWUVbv7lf5ZGoCq
         r1zki5wyNCWULicsrJlhE4nK7B5z1eEDNw0KIbxDtyGS0uD+T3rBuysXiac+NZIXIb
         EliSSs7NuMvXgy09/ukk2vGXMdWyImjpt09Vf2Wk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 195/244] net: thunderx: Fix unintentional sign extension issue
Date:   Wed, 12 May 2021 16:49:26 +0200
Message-Id: <20210512144749.236997648@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
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
index 4ab57d33a87e..6bd6fb5a3613 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_queues.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_queues.c
@@ -776,7 +776,7 @@ static void nicvf_rcv_queue_config(struct nicvf *nic, struct queue_set *qs,
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



