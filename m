Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD9671EEEA
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732238AbfEOL1a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:27:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:38358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732236AbfEOL13 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:27:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C46CA20818;
        Wed, 15 May 2019 11:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919649;
        bh=z1/vCy6CaTxfG8hnPxo0+mWmDejxIMEFV44pwnRF4zY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FzNWl/3u8qAY5Mbtil1UDA4+ZH52pomB7MIiES533XVRisJyPkPqjUWtM7qpkIwUT
         ly2iQPZlRJ3QSK3+HyZbISly1rxzQQ5kolkGjZmIdZlPpUfe+WAp32Kso2NFxldyPq
         sV16HImTS4zUmAwAK6/mNItogMlMyTEGQ3/PVOJM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Denis Bolotin <dbolotin@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 042/137] qed: Fix the doorbell address sanity check
Date:   Wed, 15 May 2019 12:55:23 +0200
Message-Id: <20190515090656.478467316@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090651.633556783@linuxfoundation.org>
References: <20190515090651.633556783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit b61b04ad81d5f975349d66abbecabf96ba211140 ]

Fix the condition which verifies that doorbell address is inside the
doorbell bar by checking that the end of the address is within range
as well.

Signed-off-by: Denis Bolotin <dbolotin@marvell.com>
Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed_dev.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
index ff0bbf8d073d6..228891e459bc0 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
@@ -102,11 +102,15 @@ static void qed_db_recovery_dp_entry(struct qed_hwfn *p_hwfn,
 
 /* Doorbell address sanity (address within doorbell bar range) */
 static bool qed_db_rec_sanity(struct qed_dev *cdev,
-			      void __iomem *db_addr, void *db_data)
+			      void __iomem *db_addr,
+			      enum qed_db_rec_width db_width,
+			      void *db_data)
 {
+	u32 width = (db_width == DB_REC_WIDTH_32B) ? 32 : 64;
+
 	/* Make sure doorbell address is within the doorbell bar */
 	if (db_addr < cdev->doorbells ||
-	    (u8 __iomem *)db_addr >
+	    (u8 __iomem *)db_addr + width >
 	    (u8 __iomem *)cdev->doorbells + cdev->db_size) {
 		WARN(true,
 		     "Illegal doorbell address: %p. Legal range for doorbell addresses is [%p..%p]\n",
@@ -159,7 +163,7 @@ int qed_db_recovery_add(struct qed_dev *cdev,
 	}
 
 	/* Sanitize doorbell address */
-	if (!qed_db_rec_sanity(cdev, db_addr, db_data))
+	if (!qed_db_rec_sanity(cdev, db_addr, db_width, db_data))
 		return -EINVAL;
 
 	/* Obtain hwfn from doorbell address */
@@ -205,10 +209,6 @@ int qed_db_recovery_del(struct qed_dev *cdev,
 		return 0;
 	}
 
-	/* Sanitize doorbell address */
-	if (!qed_db_rec_sanity(cdev, db_addr, db_data))
-		return -EINVAL;
-
 	/* Obtain hwfn from doorbell address */
 	p_hwfn = qed_db_rec_find_hwfn(cdev, db_addr);
 
@@ -317,7 +317,7 @@ static void qed_db_recovery_ring(struct qed_hwfn *p_hwfn,
 
 	/* Sanity */
 	if (!qed_db_rec_sanity(p_hwfn->cdev, db_entry->db_addr,
-			       db_entry->db_data))
+			       db_entry->db_width, db_entry->db_data))
 		return;
 
 	/* Flush the write combined buffer. Since there are multiple doorbelling
-- 
2.20.1



