Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 864163CDF46
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344073AbhGSPI4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:08:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:39496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344688AbhGSPGh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:06:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3EA6160238;
        Mon, 19 Jul 2021 15:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709636;
        bh=OxTA+F8xU/iIV8rt7vCj/gMYjbzh+sko4L705oVrLds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EeuxCuiQoTql2B0bnIwrW5WVrn4iLdSX3Pyex1TUVWkBsLRKh+fbUvZ7GeWRVo0YI
         0YIy4cXecEPXCpxIF6oPzgnpRJJs/aSatUm5TCp0r1PfhtYrWPoDMymJ+9h441n9tS
         YidDltJCEBrGVWTAUnFmVC+Ww/ijihZkeDfCTpKs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Justin Tee <justin.tee@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 021/149] scsi: lpfc: Fix crash when lpfc_sli4_hba_setup() fails to initialize the SGLs
Date:   Mon, 19 Jul 2021 16:52:09 +0200
Message-Id: <20210719144906.486615520@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144901.370365147@linuxfoundation.org>
References: <20210719144901.370365147@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit 5aa615d195f1e142c662cb2253f057c9baec7531 ]

The driver is encountering a crash in lpfc_free_iocb_list() while
performing initial attachment.

Code review found this to be an errant failure path that was taken, jumping
to a tag that then referenced structures that were uninitialized.

Fix the failure path.

Link: https://lore.kernel.org/r/20210514195559.119853-9-jsmart2021@gmail.com
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_sli.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 795460eda6a5..4a7ceaa34341 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -7602,7 +7602,7 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 				"0393 Error %d during rpi post operation\n",
 				rc);
 		rc = -ENODEV;
-		goto out_destroy_queue;
+		goto out_free_iocblist;
 	}
 	lpfc_sli4_node_prep(phba);
 
@@ -7765,8 +7765,9 @@ out_io_buff_free:
 out_unset_queue:
 	/* Unset all the queues set up in this routine when error out */
 	lpfc_sli4_queue_unset(phba);
-out_destroy_queue:
+out_free_iocblist:
 	lpfc_free_iocb_list(phba);
+out_destroy_queue:
 	lpfc_sli4_queue_destroy(phba);
 out_stop_timers:
 	lpfc_stop_hba_timers(phba);
-- 
2.30.2



