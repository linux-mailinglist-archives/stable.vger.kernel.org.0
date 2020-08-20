Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A789224BCDC
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729146AbgHTJnO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:43:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:39044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729195AbgHTJmr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:42:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D0BB22D02;
        Thu, 20 Aug 2020 09:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916566;
        bh=mLYNCZxyp2OqWqRYpDxGEIUdDitmV51HAxOn4ZojxjI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X3MBsAIuo2DlxDjTnooU9mkqutYoIZu+oZ9a5RZqkSCnyP0Kr6Pv0xLfTA04OJoCG
         miccOsG3pM8zqezwY3vuDY02LaJiGPyH2ngoKSMF1zJtrYmw4j5hKv3ZPvbyu62WEV
         Io2brHxygCVIuT3GdCrUVSzn8R/hfc6Lh1sjjqIY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Smart <james.smart@broadcom.com>,
        "Ewan D. Milne" <emilne@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 156/204] scsi: lpfc: nvmet: Avoid hang / use-after-free again when destroying targetport
Date:   Thu, 20 Aug 2020 11:20:53 +0200
Message-Id: <20200820091614.024997990@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091606.194320503@linuxfoundation.org>
References: <20200820091606.194320503@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ewan D. Milne <emilne@redhat.com>

[ Upstream commit af6de8c60fe9433afa73cea6fcccdccd98ad3e5e ]

We cannot wait on a completion object in the lpfc_nvme_targetport structure
in the _destroy_targetport() code path because the NVMe/fc transport will
free that structure immediately after the .targetport_delete() callback.
This results in a use-after-free, and a crash if slub_debug=FZPU is
enabled.

An earlier fix put put the completion on the stack, but commit 2a0fb340fcc8
("scsi: lpfc: Correct localport timeout duration error") subsequently
changed the code to reference the completion through a pointer in the
object rather than the local stack variable.  Fix this by using the stack
variable directly.

Link: https://lore.kernel.org/r/20200729231011.13240-1-emilne@redhat.com
Fixes: 2a0fb340fcc8 ("scsi: lpfc: Correct localport timeout duration error")
Reviewed-by: James Smart <james.smart@broadcom.com>
Signed-off-by: Ewan D. Milne <emilne@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_nvmet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index 565419bf8d74a..40b2df6e304ad 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -1914,7 +1914,7 @@ lpfc_nvmet_destroy_targetport(struct lpfc_hba *phba)
 		}
 		tgtp->tport_unreg_cmp = &tport_unreg_cmp;
 		nvmet_fc_unregister_targetport(phba->targetport);
-		if (!wait_for_completion_timeout(tgtp->tport_unreg_cmp,
+		if (!wait_for_completion_timeout(&tport_unreg_cmp,
 					msecs_to_jiffies(LPFC_NVMET_WAIT_TMO)))
 			lpfc_printf_log(phba, KERN_ERR, LOG_NVME,
 					"6179 Unreg targetport x%px timeout "
-- 
2.25.1



