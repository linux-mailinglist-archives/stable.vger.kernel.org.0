Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4FA81FDF1C
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732499AbgFRBaX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:30:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:40296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732501AbgFRBaW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:30:22 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC2C121941;
        Thu, 18 Jun 2020 01:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443821;
        bh=xTsEMEu4Pag2SES80YniEQS5QeBI0y+E8Kx5pz/Dsds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hcFS/iqbbnmnj5740xfAYu4+z9ARnYD0EvT41A/A3uyyHkBW2ByGs8uUtps3baawz
         S9hTki0A1+xUv9Ftsc/P0aiEEfH+iLQ+8FH81FnYy547IuRurtZQyc5RTljmyQ8YtT
         nnv3FnTkogqMoVOImRsMXVYY8KVq5Og0Z+eyP9ik=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Daniel Wagner <dwagner@suse.de>,
        James Smart <james.smart@broadcom.com>,
        Xin Tan <tanxin.ctf@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 13/60] scsi: lpfc: Fix lpfc_nodelist leak when processing unsolicited event
Date:   Wed, 17 Jun 2020 21:29:17 -0400
Message-Id: <20200618013004.610532-13-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618013004.610532-1-sashal@kernel.org>
References: <20200618013004.610532-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiyu Yang <xiyuyang19@fudan.edu.cn>

[ Upstream commit 7217e6e694da3aae6d17db8a7f7460c8d4817ebf ]

In order to create or activate a new node, lpfc_els_unsol_buffer() invokes
lpfc_nlp_init() or lpfc_enable_node() or lpfc_nlp_get(), all of them will
return a reference of the specified lpfc_nodelist object to "ndlp" with
increased refcnt.

When lpfc_els_unsol_buffer() returns, local variable "ndlp" becomes
invalid, so the refcount should be decreased to keep refcount balanced.

The reference counting issue happens in one exception handling path of
lpfc_els_unsol_buffer(). When "ndlp" in DEV_LOSS, the function forgets to
decrease the refcnt increased by lpfc_nlp_init() or lpfc_enable_node() or
lpfc_nlp_get(), causing a refcnt leak.

Fix this issue by calling lpfc_nlp_put() when "ndlp" in DEV_LOSS.

Link: https://lore.kernel.org/r/1590416184-52592-1-git-send-email-xiyuyang19@fudan.edu.cn
Reviewed-by: Daniel Wagner <dwagner@suse.de>
Reviewed-by: James Smart <james.smart@broadcom.com>
Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_els.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 530b7df21322..315dd25a0c44 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -7315,6 +7315,8 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	spin_lock_irq(shost->host_lock);
 	if (ndlp->nlp_flag & NLP_IN_DEV_LOSS) {
 		spin_unlock_irq(shost->host_lock);
+		if (newnode)
+			lpfc_nlp_put(ndlp);
 		goto dropit;
 	}
 	spin_unlock_irq(shost->host_lock);
-- 
2.25.1

