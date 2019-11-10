Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25AE4F670A
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 04:17:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbfKJCkS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:40:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:33176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726560AbfKJCkR (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:40:17 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92F09215EA;
        Sun, 10 Nov 2019 02:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353616;
        bh=n6QzZCLFvjcRY9Gen25EumCUyRvB0LU/DHo9DES47YM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pi0n4BajtpIb7SSxlRmgcWS51MIdrvHcq/VQJg04cY1HH1mJQSd5i6pnVm2bCGoh+
         WO7MiuG71X4rr2zeodXj+fUJmonWLiSEMkwoFwpz+6zGMEEbEpLuo6wLTjUHpZI683
         H4NNc2eGdmHMKseoxyDSi2KXTmCqGz+pdm0IJlyM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Julian Wiedmann <jwi@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 002/191] s390/qeth: invoke softirqs after napi_schedule()
Date:   Sat,  9 Nov 2019 21:37:04 -0500
Message-Id: <20191110024013.29782-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>

[ Upstream commit 4d19db777a2f32c9b76f6fd517ed8960576cb43e ]

Calling napi_schedule() from process context does not ensure that the
NET_RX softirq is run in a timely fashion. So trigger it manually.

This is no big issue with current code. A call to ndo_open() is usually
followed by a ndo_set_rx_mode() call, and for qeth this contains a
spin_unlock_bh(). Except for OSN, where qeth_l2_set_rx_mode() bails out
early.
Nevertheless it's best to not depend on this behaviour, and just fix
the issue at its source like all other drivers do. For instance see
commit 83a0c6e58901 ("i40e: Invoke softirqs after napi_reschedule").

Fixes: a1c3ed4c9ca0 ("qeth: NAPI support for l2 and l3 discipline")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/net/qeth_l2_main.c | 3 +++
 drivers/s390/net/qeth_l3_main.c | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index c1c35eccd5b65..95669d47c389e 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -789,7 +789,10 @@ static int __qeth_l2_open(struct net_device *dev)
 
 	if (qdio_stop_irq(card->data.ccwdev, 0) >= 0) {
 		napi_enable(&card->napi);
+		local_bh_disable();
 		napi_schedule(&card->napi);
+		/* kick-start the NAPI softirq: */
+		local_bh_enable();
 	} else
 		rc = -EIO;
 	return rc;
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 9c5e801b3f6cb..52e0ae4dc7241 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -2414,7 +2414,10 @@ static int __qeth_l3_open(struct net_device *dev)
 
 	if (qdio_stop_irq(card->data.ccwdev, 0) >= 0) {
 		napi_enable(&card->napi);
+		local_bh_disable();
 		napi_schedule(&card->napi);
+		/* kick-start the NAPI softirq: */
+		local_bh_enable();
 	} else
 		rc = -EIO;
 	return rc;
-- 
2.20.1

