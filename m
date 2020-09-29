Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38FD127C92F
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730573AbgI2MIT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:08:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:58100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730230AbgI2Lhg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:36 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CED8223B51;
        Tue, 29 Sep 2020 11:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379339;
        bh=T3ieBczVoOGtJ8Z+Ukuh2lyvCRGchjx8Grvfc97QzAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A1C/weExn8WkVIeK9I9c8Y1JXP1XfxgYzwdKBN4RDWqUxR4IAj/WKf68SbP8rURIa
         3qtcTU+nAyCgyP5aVnXzUrCC9jhtcuFCQ+E+AZFdiBskV5zVRDiYF+G6si+vBPe9Mi
         PlEGgdqWCVGuW5F3OmBpGvpBb+sY4zyIy6FezyoU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 117/388] scsi: lpfc: Fix release of hwq to clear the eq relationship
Date:   Tue, 29 Sep 2020 12:57:28 +0200
Message-Id: <20200929110016.139391130@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit 821bc882accaaaf1bbecf5c0ecef659443e3e8cb ]

When performing reset testing, the eq's list for related hwqs was getting
corrupted.  In cases where there is not a 1:1 eq to hwq, the eq is
shared. The eq maintains a list of hwqs utilizing it in case of cpu
offlining and polling. During the reset, the hwqs are being torn down so
they can be recreated. The recreation was getting confused by seeing a
non-null eq assignment on the eq and the eq list became corrupt.

Correct by clearing the hdwq eq assignment when the hwq is cleaned up.

Link: https://lore.kernel.org/r/20200128002312.16346-6-jsmart2021@gmail.com
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 95abffd9ad100..d4c83eca0ad2c 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -9124,6 +9124,7 @@ lpfc_sli4_release_hdwq(struct lpfc_hba *phba)
 		/* Free the CQ/WQ corresponding to the Hardware Queue */
 		lpfc_sli4_queue_free(hdwq[idx].io_cq);
 		lpfc_sli4_queue_free(hdwq[idx].io_wq);
+		hdwq[idx].hba_eq = NULL;
 		hdwq[idx].io_cq = NULL;
 		hdwq[idx].io_wq = NULL;
 		if (phba->cfg_xpsgl && !phba->nvmet_support)
-- 
2.25.1



