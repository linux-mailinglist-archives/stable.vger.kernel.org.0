Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73FA412EDC0
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:32:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730031AbgABWbc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:31:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:36704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730294AbgABWba (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:31:30 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CC82222C3;
        Thu,  2 Jan 2020 22:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578004289;
        bh=TqHm7quSf2RJ5UGZG10NxgwjJMkqLHbTaKd1rINAea4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z/dJnpLoUaQeePsniUc7wxWUn7lXK88WX2GfRo8EaQqyxYe4Qvj5+DNohFtqYLvFG
         HE1ZjJY00XmOLM8Zw0hKAZUZ31oXcEltEKsDiCfS2ygXHQTB7xkDBttkLxNvhyhmPO
         hmOaED+Noe7vn4qtzvroDYCTeNNGeHs9FOD1nBGA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 116/171] scsi: lpfc: Fix SLI3 hba in loop mode not discovering devices
Date:   Thu,  2 Jan 2020 23:07:27 +0100
Message-Id: <20200102220603.196961929@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220546.960200039@linuxfoundation.org>
References: <20200102220546.960200039@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit feff8b3d84d3d9570f893b4d83e5eab6693d6a52 ]

When operating in private loop mode, PLOGI exchanges are racing and the
driver tries to abort it's PLOGI. But the PLOGI abort ends up terminating
the login with the other end causing the other end to abort its PLOGI as
well. Discovery never fully completes.

Fix by disabling the PLOGI abort when private loop and letting the state
machine play out.

Link: https://lore.kernel.org/r/20191018211832.7917-5-jsmart2021@gmail.com
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_nportdisc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 21ec7b5b6c85..fefef2884d59 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -454,8 +454,10 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	 * single discovery thread, this will cause a huge delay in
 	 * discovery. Also this will cause multiple state machines
 	 * running in parallel for this node.
+	 * This only applies to a fabric environment.
 	 */
-	if (ndlp->nlp_state == NLP_STE_PLOGI_ISSUE) {
+	if ((ndlp->nlp_state == NLP_STE_PLOGI_ISSUE) &&
+	    (vport->fc_flag & FC_FABRIC)) {
 		/* software abort outstanding PLOGI */
 		lpfc_els_abort(phba, ndlp);
 	}
-- 
2.20.1



