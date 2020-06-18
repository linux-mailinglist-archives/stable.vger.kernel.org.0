Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1229E1FE37C
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730571AbgFRBVp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:21:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:54340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730582AbgFRBVp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:21:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F27620776;
        Thu, 18 Jun 2020 01:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443305;
        bh=7KcgcQk4pr8iMv+PjaAinyL34JIG5rT49OW2Jn+51nM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nxftcRUxFTgCS3amN9YHw4RLH3Z+ifP9WCNGyurHYoPjgkSauGFvCxalKW19AmA0g
         mwRJhGV7Gysl29XxMl0oFOTPSCWtJSI0mJWS2gFwfkkXTNaIIQs8ejOcyM9zjp+4Qk
         YdLVWI9DXeRby7m0VWnZq1gIY3xWzehwemtfVWE8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Logan Gunthorpe <logang@deltatee.com>,
        Allen Hubbe <allenbh@gmail.com>,
        Alexander Fomichev <fomichev.ru@gmail.com>,
        Jon Mason <jdmason@kudzu.us>, Sasha Levin <sashal@kernel.org>,
        linux-ntb@googlegroups.com
Subject: [PATCH AUTOSEL 5.4 243/266] NTB: perf: Fix race condition when run with ntb_test
Date:   Wed, 17 Jun 2020 21:16:08 -0400
Message-Id: <20200618011631.604574-243-sashal@kernel.org>
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

From: Logan Gunthorpe <logang@deltatee.com>

[ Upstream commit 34d8673a01b053b6231a995a4eec9341163d63be ]

When running ntb_test, the script tries to run the ntb_perf test
immediately after probing the modules. Since adding multi-port support,
this fails seeing the new initialization procedure in ntb_perf
can not complete instantly.

To fix this we add a completion which is waited on when a test is
started. In this way, run can be written any time after the module is
loaded and it will wait for the initialization to complete instead of
sending an error.

Fixes: 5648e56d03fa ("NTB: ntb_perf: Add full multi-port NTB API support")
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Acked-by: Allen Hubbe <allenbh@gmail.com>
Tested-by: Alexander Fomichev <fomichev.ru@gmail.com>
Signed-off-by: Jon Mason <jdmason@kudzu.us>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ntb/test/ntb_perf.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/ntb/test/ntb_perf.c b/drivers/ntb/test/ntb_perf.c
index 281170887ad0..5ce4766a6c9e 100644
--- a/drivers/ntb/test/ntb_perf.c
+++ b/drivers/ntb/test/ntb_perf.c
@@ -158,6 +158,8 @@ struct perf_peer {
 	/* NTB connection setup service */
 	struct work_struct	service;
 	unsigned long		sts;
+
+	struct completion init_comp;
 };
 #define to_peer_service(__work) \
 	container_of(__work, struct perf_peer, service)
@@ -546,6 +548,7 @@ static int perf_setup_outbuf(struct perf_peer *peer)
 
 	/* Initialization is finally done */
 	set_bit(PERF_STS_DONE, &peer->sts);
+	complete_all(&peer->init_comp);
 
 	return 0;
 }
@@ -637,6 +640,7 @@ static void perf_service_work(struct work_struct *work)
 		perf_setup_outbuf(peer);
 
 	if (test_and_clear_bit(PERF_CMD_CLEAR, &peer->sts)) {
+		init_completion(&peer->init_comp);
 		clear_bit(PERF_STS_DONE, &peer->sts);
 		if (test_bit(0, &peer->perf->busy_flag) &&
 		    peer == peer->perf->test_peer) {
@@ -1052,8 +1056,9 @@ static int perf_submit_test(struct perf_peer *peer)
 	struct perf_thread *pthr;
 	int tidx, ret;
 
-	if (!test_bit(PERF_STS_DONE, &peer->sts))
-		return -ENOLINK;
+	ret = wait_for_completion_interruptible(&peer->init_comp);
+	if (ret < 0)
+		return ret;
 
 	if (test_and_set_bit_lock(0, &perf->busy_flag))
 		return -EBUSY;
@@ -1419,6 +1424,7 @@ static int perf_init_peers(struct perf_ctx *perf)
 			peer->gidx = pidx;
 		}
 		INIT_WORK(&peer->service, perf_service_work);
+		init_completion(&peer->init_comp);
 	}
 	if (perf->gidx == -1)
 		perf->gidx = pidx;
-- 
2.25.1

