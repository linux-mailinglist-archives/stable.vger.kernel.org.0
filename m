Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65B6737CE57
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240538AbhELRFB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:05:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:35798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244302AbhELQmw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5243E61D49;
        Wed, 12 May 2021 16:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835954;
        bh=PpeSe4FOBhEnJwSZV16PiI4jkvWliL3d9K61CfCxvGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jBwi2aYqtVlILs3imDEy4XAo6hzQILIAC4kl0MsaJtTpsVpb+BgT8ScvdkXXd5znI
         FJaIPBgbC0KgWz5TuLhZAu0cOdAjF6yPIZqWn3uxnySDrix0Lb/Kt/7njURSDUBybe
         pep8UaFDiFEC1QOoLqx6vsi51hKscygf5gavr7o8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 551/677] net: thunderx: Fix unintentional sign extension issue
Date:   Wed, 12 May 2021 16:49:57 +0200
Message-Id: <20210512144855.689963626@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
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
index f782e6af45e9..50bbe79fb93d 100644
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



