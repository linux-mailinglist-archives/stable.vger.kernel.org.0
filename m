Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37DDD24BE99
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728093AbgHTJdC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:33:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:44430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728063AbgHTJcI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:32:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61A04207DE;
        Thu, 20 Aug 2020 09:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597915927;
        bh=4fzfIvN+NcbSnlAg6+7Q33xB9C/POBwhAntdAp9XSBs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jYHl9dT+tbx59+MQ2N5LxVaIw1RxzbH5s9hrIrxvwn7a6g+wMtfKJLbR/7W76BSYr
         gVG1AYtZzctKGBTk4Zr6Yfdhsmg3kHE1+xKfslKrUqmqWclBZq8aY4MfCL8HNkazs8
         GDkL/TkI80EkIXXQ5q70nRa+bcPaEzfhJIHPhyZ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Smart <james.smart@broadcom.com>,
        "Ewan D. Milne" <emilne@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 183/232] scsi: lpfc: nvmet: Avoid hang / use-after-free again when destroying targetport
Date:   Thu, 20 Aug 2020 11:20:34 +0200
Message-Id: <20200820091621.668630975@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
References: <20200820091612.692383444@linuxfoundation.org>
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
index 88760416a8cbd..fcd9d4c2f1ee0 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -2112,7 +2112,7 @@ lpfc_nvmet_destroy_targetport(struct lpfc_hba *phba)
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



