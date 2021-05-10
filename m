Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 060443785F5
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234285AbhEJLCs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:02:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:46292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234774AbhEJK5C (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:57:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 038AC6145C;
        Mon, 10 May 2021 10:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643748;
        bh=IZ6PSopKYpetcWHL9wu9MPKeWX7XXP1ANutKr1URpZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ILrnXL6zwgNW6/hKji+tJWkZAUSRNJkljdQmWM4duGGksdSAKOx+511RxZ5UekNaa
         RU/80d73wDaA8kavIGAz7ZRJa5Hfrw9CRf828kZ89Xn0H7wCcOx+TKhMZEeNYN8wCm
         TGNC34x1DCXx2IO6vLij5VpDLzlsz7OLJ4ehGPeI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 143/342] scsi: lpfc: Fix status returned in lpfc_els_retry() error exit path
Date:   Mon, 10 May 2021 12:18:53 +0200
Message-Id: <20210510102014.803225644@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
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



