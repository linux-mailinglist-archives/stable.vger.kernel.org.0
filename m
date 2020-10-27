Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0085129B5D6
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:19:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1794380AbgJ0PQn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:16:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:52532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1796126AbgJ0PPo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:15:44 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2BEE20728;
        Tue, 27 Oct 2020 15:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811744;
        bh=hAfwZo3WFQcSNO/kbKcDbhhHxXXm/AOfOCg43UAlxw4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tCQ57QGwWZN1DLTaf0SPB+xvLUzYMc1THHyvqB3InLccQw/EqcRaH2l+U0tXDQ6kg
         4+z5iOUToNxhRS78HsqFonPiln84ne5eazo9FCjJd00UvkslPEhCEXiGeL7Btg4/51
         SJUANBukdXHibkrGuabht94emJrotmlUvwpJkYLo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 601/633] scsi: qedf: Return SUCCESS if stale rport is encountered
Date:   Tue, 27 Oct 2020 14:55:44 +0100
Message-Id: <20201027135551.004730089@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



