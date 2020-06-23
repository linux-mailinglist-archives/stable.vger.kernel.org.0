Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06A3C205FDA
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391838AbgFWUgz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:36:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:60138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391835AbgFWUgy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:36:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4BA82080C;
        Tue, 23 Jun 2020 20:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944614;
        bh=NVD3gOOYKy/FQpq731q8IpOhveShIgkLDPQqbCvguE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LV3Jo+B+yoaGQvlaXSox2Ucg124wGBSCp/EU4EQIsz9S9gWa/eVzF1r/+eI4MruLV
         YOWv19rC0joZJ4irAMB2UTWOTdJLBzhuyOYNoaoQplyI64pLeAs/W1ZKTYLc/NKdwP
         YodHCfAs12LD0qgg1VptOJO2xu5Kndfa+JR105ZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Wagner <dwagner@suse.de>,
        James Smart <james.smart@broadcom.com>,
        Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 030/206] scsi: lpfc: Fix lpfc_nodelist leak when processing unsolicited event
Date:   Tue, 23 Jun 2020 21:55:58 +0200
Message-Id: <20200623195318.460552908@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195316.864547658@linuxfoundation.org>
References: <20200623195316.864547658@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 7398350b08b41..9032793c405eb 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -7949,6 +7949,8 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
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



