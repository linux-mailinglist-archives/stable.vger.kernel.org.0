Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5D27378838
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:42:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239067AbhEJLVA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:21:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:46208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234567AbhEJLJb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:09:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21A9D61139;
        Mon, 10 May 2021 11:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644707;
        bh=16VyapXb1HW+Q296oL36abpmwD6a8vwloM8LfqYD2r8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UQ1mTzWbKYwEhprc12bX3C6+uQZJl/SuP6CR6F9bdpzgM+Ugnj4m0U8DNjGTn9Rti
         vW9/6zJidkc8fF9CxRgmvrfNd4M5wWh8VeYBgDf+702jYhw1vm2A7leAkeoJFUoIRg
         cM/lJxuEc+5RVbAOCkTCiS/xzmsGj4gPP4c+c3tk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 156/384] scsi: lpfc: Fix status returned in lpfc_els_retry() error exit path
Date:   Mon, 10 May 2021 12:19:05 +0200
Message-Id: <20210510102020.023971932@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index f0a758138ae8..beb2fcd2d8e7 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -3829,7 +3829,7 @@ lpfc_els_retry(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		did = irsp->un.elsreq64.remoteID;
 		ndlp = lpfc_findnode_did(vport, did);
 		if (!ndlp && (cmd != ELS_CMD_PLOGI))
-			return 1;
+			return 0;
 	}
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
-- 
2.30.2



