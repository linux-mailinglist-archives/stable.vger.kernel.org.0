Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49F032601C3
	for <lists+stable@lfdr.de>; Mon,  7 Sep 2020 19:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730378AbgIGQck (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Sep 2020 12:32:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:46496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729851AbgIGQch (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Sep 2020 12:32:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC343217A0;
        Mon,  7 Sep 2020 16:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599496353;
        bh=fMnkgAblkIzmn4NV5qpGYdRfZFLnYfW+R/fXUqvNWzI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QZ23v3jzYH6cvhN/VT6/Av0T7inaPKka/VAxsYYFxgU2DYtXukRR5/C7s29T96e6q
         0w/vMtHhdXVXWpCPEGizHdgtVl9tYJa+6qIM4fC6CJW/gWv0sB8CF7e26GHVqU2T3L
         Zqb0fj4pzzzazFKv6Z89vwYSB2dibLdHLfAlfXow=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ye Bin <yebin10@huawei.com>, Saurav Kashyap <skashyap@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 10/53] scsi: qedf: Fix null ptr reference in qedf_stag_change_work
Date:   Mon,  7 Sep 2020 12:31:36 -0400
Message-Id: <20200907163220.1280412-10-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200907163220.1280412-1-sashal@kernel.org>
References: <20200907163220.1280412-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ye Bin <yebin10@huawei.com>

[ Upstream commit f308a35f547cd7c1d8a901c12b3ac508e96df665 ]

Link: https://lore.kernel.org/r/20200824033436.45570-1-yebin10@huawei.com
Acked-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Ye Bin <yebin10@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qedf/qedf_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 36b1ca2dadbb5..51cfab9d1afdc 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -3843,7 +3843,7 @@ void qedf_stag_change_work(struct work_struct *work)
 	    container_of(work, struct qedf_ctx, stag_work.work);
 
 	if (!qedf) {
-		QEDF_ERR(&qedf->dbg_ctx, "qedf is NULL");
+		QEDF_ERR(NULL, "qedf is NULL");
 		return;
 	}
 	QEDF_ERR(&qedf->dbg_ctx, "Performing software context reset.\n");
-- 
2.25.1

