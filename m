Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD76B1FDC35
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729824AbgFRBRr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:17:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:49032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729818AbgFRBRr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:17:47 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DBAB8206F1;
        Thu, 18 Jun 2020 01:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443066;
        bh=Z/WbnyE4ZXlpudncQs5OzvRsFKu8fkgoznjwuRiGmao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WIvLRAcx+GgjQClulg/2+c247y0zwuk4thSiOuO6HgJv2p9tVI6wMrZNIxdqSoXVx
         ugqi7BMS0kSX5sOYgfxO0Llg7LcFnkSAi8c300SJLlJe8cySiipnqt6C+wdi3eIzQ9
         bH/5ovRW4JcY8T+1M4HqibSxf/CvQgddhDi71F8k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 056/266] scsi: cxgb3i: Fix some leaks in init_act_open()
Date:   Wed, 17 Jun 2020 21:13:01 -0400
Message-Id: <20200618011631.604574-56-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618011631.604574-1-sashal@kernel.org>
References: <20200618011631.604574-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit b6170a49c59c27a10efed26c5a2969403e69aaba ]

There wasn't any clean up done if cxgb3_alloc_atid() failed and also the
original code didn't release "csk->l2t".

Link: https://lore.kernel.org/r/20200521121221.GA247492@mwanda
Fixes: 6f7efaabefeb ("[SCSI] cxgb3i: change cxgb3i to use libcxgbi")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
index 524cdbcd29aa..ec7d01f6e2d5 100644
--- a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
+++ b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
@@ -959,6 +959,7 @@ static int init_act_open(struct cxgbi_sock *csk)
 	struct net_device *ndev = cdev->ports[csk->port_id];
 	struct cxgbi_hba *chba = cdev->hbas[csk->port_id];
 	struct sk_buff *skb = NULL;
+	int ret;
 
 	log_debug(1 << CXGBI_DBG_TOE | 1 << CXGBI_DBG_SOCK,
 		"csk 0x%p,%u,0x%lx.\n", csk, csk->state, csk->flags);
@@ -979,16 +980,16 @@ static int init_act_open(struct cxgbi_sock *csk)
 	csk->atid = cxgb3_alloc_atid(t3dev, &t3_client, csk);
 	if (csk->atid < 0) {
 		pr_err("NO atid available.\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto put_sock;
 	}
 	cxgbi_sock_set_flag(csk, CTPF_HAS_ATID);
 	cxgbi_sock_get(csk);
 
 	skb = alloc_wr(sizeof(struct cpl_act_open_req), 0, GFP_KERNEL);
 	if (!skb) {
-		cxgb3_free_atid(t3dev, csk->atid);
-		cxgbi_sock_put(csk);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto free_atid;
 	}
 	skb->sk = (struct sock *)csk;
 	set_arp_failure_handler(skb, act_open_arp_failure);
@@ -1010,6 +1011,15 @@ static int init_act_open(struct cxgbi_sock *csk)
 	cxgbi_sock_set_state(csk, CTP_ACTIVE_OPEN);
 	send_act_open_req(csk, skb, csk->l2t);
 	return 0;
+
+free_atid:
+	cxgb3_free_atid(t3dev, csk->atid);
+put_sock:
+	cxgbi_sock_put(csk);
+	l2t_release(t3dev, csk->l2t);
+	csk->l2t = NULL;
+
+	return ret;
 }
 
 cxgb3_cpl_handler_func cxgb3i_cpl_handlers[NUM_CPL_CMDS] = {
-- 
2.25.1

