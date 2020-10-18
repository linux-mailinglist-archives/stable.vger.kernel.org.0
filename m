Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 284D5291DEE
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 21:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732799AbgJRTsO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:48:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:34544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727349AbgJRTWB (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:22:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCB31222E9;
        Sun, 18 Oct 2020 19:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603048920;
        bh=hAfwZo3WFQcSNO/kbKcDbhhHxXXm/AOfOCg43UAlxw4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fLAuLpFYIE3NxXVk/0P+aSHYu1gzRedn8Mp+LkFWYLszbCnsfwg/O3jYlyQFIKstD
         oRcfxYyLEAg5Y9EYPo/EtErWCCqsqS0nBdoxjPpigALNKp2EOj64vTB2l2PoP9cte5
         sslVXNo0B8lS0fbTARkc/KMBREKi+c952gCCRIUg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 078/101] scsi: qedf: Return SUCCESS if stale rport is encountered
Date:   Sun, 18 Oct 2020 15:20:03 -0400
Message-Id: <20201018192026.4053674-78-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192026.4053674-1-sashal@kernel.org>
References: <20201018192026.4053674-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Saurav Kashyap <skashyap@marvell.com>

[ Upstream commit 10aff62fab263ad7661780816551420cea956ebb ]

If SUCCESS is not returned, error handling will escalate. Return SUCCESS
similar to other conditions in this function.

Link: https://lore.kernel.org/r/20200907121443.5150-6-jhasan@marvell.com
Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Javed Hasan <jhasan@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qedf/qedf_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 51cfab9d1afdc..ed3054fffa344 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -704,7 +704,7 @@ static int qedf_eh_abort(struct scsi_cmnd *sc_cmd)
 	rdata = fcport->rdata;
 	if (!rdata || !kref_get_unless_zero(&rdata->kref)) {
 		QEDF_ERR(&qedf->dbg_ctx, "stale rport, sc_cmd=%p\n", sc_cmd);
-		rc = 1;
+		rc = SUCCESS;
 		goto out;
 	}
 
-- 
2.25.1

