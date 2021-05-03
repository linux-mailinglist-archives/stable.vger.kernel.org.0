Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68569371AB3
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232420AbhECQkr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:40:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:38998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232208AbhECQjY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:39:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 372BF613CF;
        Mon,  3 May 2021 16:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059844;
        bh=IZ6PSopKYpetcWHL9wu9MPKeWX7XXP1ANutKr1URpZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nrpr8uhne81rtyt5KmfKFnXTeqUNumRAN1tkpd+g5y0KAz32TvUhY8EU66p2IAFS7
         l7AbCf6bSpz/cHk5UkJeqkdF4tvkUBn81Z8FQa+77jrQtw4XB7xf28cpjUDRc23Vno
         1Jk48Z98lQ2uQgAZtKSfkwUEpBVevppd9fG7tQ1nOsO1sZPOuS65oSKA6jtWC5hQ05
         c0cxubtg2fGlIlIXLhd3SLcydqNff4X3aXclBwXOPBX6tgFEIbX5kFkpk/4kRUzW4J
         EyfXiw8jYQXpHvbkI8VTXxPlU0+XkI3SXoxaCzBz9cR4QbHECEtDj+cNqtCHK7mL9c
         LOKoRXlWmejLA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 015/115] scsi: lpfc: Fix status returned in lpfc_els_retry() error exit path
Date:   Mon,  3 May 2021 12:35:19 -0400
Message-Id: <20210503163700.2852194-15-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163700.2852194-1-sashal@kernel.org>
References: <20210503163700.2852194-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit 148bc64d38fe314475a074c4f757ec9d84537d1c ]

An unlikely error exit path from lpfc_els_retry() returns incorrect status
to a caller, erroneously indicating that a retry has been successfully
issued or scheduled.

Change error exit path to indicate no retry.

Link: https://lore.kernel.org/r/20210301171821.3427-12-jsmart2021@gmail.com
Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_els.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 96c087b8b474..20f3b21ef05c 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -3840,7 +3840,7 @@ lpfc_els_retry(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		did = irsp->un.elsreq64.remoteID;
 		ndlp = lpfc_findnode_did(vport, did);
 		if (!ndlp && (cmd != ELS_CMD_PLOGI))
-			return 1;
+			return 0;
 	}
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
-- 
2.30.2

