Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2795E426978
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 13:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240325AbhJHLh7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 07:37:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:60680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241608AbhJHLf5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 07:35:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B85C61029;
        Fri,  8 Oct 2021 11:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633692723;
        bh=TlcQa+mkWgFKVPC9ORlPmHis2ze76S+cYuEFyfM1WR8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J3fVxrVXJguZfawXWJFQtxYdNn0srwjg7h8XDmQCLGJeTf64r0oEQFe3dDm4R5lB8
         bhsnLeYKY5H24W5RHfkeum8h4PcYICq0xsC0vuDY8U7TFEAFhx92GIJf2AnXRdbHsU
         nD7nHE95yxOqdhuG4QiR00rJimxkKfEdhRBMSv0Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 16/48] scsi: elx: efct: Do not hold lock while calling fc_vport_terminate()
Date:   Fri,  8 Oct 2021 13:27:52 +0200
Message-Id: <20211008112720.560078449@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211008112720.008415452@linuxfoundation.org>
References: <20211008112720.008415452@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit 450907424d9ebcc28fab42a065c3cddce49ee97d ]

Smatch checker reported the following error:

  drivers/base/power/sysfs.c:833 dpm_sysfs_remove()
  warn: sleeping in atomic context

With a calling sequence of:

  efct_lio_npiv_drop_nport() <- disables preempt
  -> fc_vport_terminate()
     -> device_del()
        -> dpm_sysfs_remove()

Issue is efct_lio_npiv_drop_nport() is making the fc_vport_terminate() call
while holding a lock w/ ipl raised.

It is unnecessary to hold the lock over this call, shift where the lock is
taken.

Link: https://lore.kernel.org/r/20210907165225.10821-1-jsmart2021@gmail.com
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Co-developed-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/elx/efct/efct_lio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/elx/efct/efct_lio.c b/drivers/scsi/elx/efct/efct_lio.c
index e0d798d6baee..f1d6fcfe12f0 100644
--- a/drivers/scsi/elx/efct/efct_lio.c
+++ b/drivers/scsi/elx/efct/efct_lio.c
@@ -880,11 +880,11 @@ efct_lio_npiv_drop_nport(struct se_wwn *wwn)
 	struct efct *efct = lio_vport->efct;
 	unsigned long flags = 0;
 
-	spin_lock_irqsave(&efct->tgt_efct.efct_lio_lock, flags);
-
 	if (lio_vport->fc_vport)
 		fc_vport_terminate(lio_vport->fc_vport);
 
+	spin_lock_irqsave(&efct->tgt_efct.efct_lio_lock, flags);
+
 	list_for_each_entry_safe(vport, next_vport, &efct->tgt_efct.vport_list,
 				 list_entry) {
 		if (vport->lio_vport == lio_vport) {
-- 
2.33.0



