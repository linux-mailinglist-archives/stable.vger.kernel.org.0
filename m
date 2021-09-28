Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB3DC41A78E
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 07:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239012AbhI1F6F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 01:58:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:48308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239106AbhI1F5h (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Sep 2021 01:57:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 51AF4611CE;
        Tue, 28 Sep 2021 05:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632808558;
        bh=TlcQa+mkWgFKVPC9ORlPmHis2ze76S+cYuEFyfM1WR8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UfEwyonSKA3tl+Y5UqDEd7InRhkUIWSvvlQuf7H+87r8qXDwC6Q25W/j8txtLxWcV
         ZXFqLnaWVjkinfQU3PHJsRSC68gAu1KB7gdwH1XCiD9MTi3jG//TPDe3oH5ky3bUFY
         aKOdimByUmRzz38gaPKttsGN1HtR0T/zG6cG1S0ujmU/gTYlLtbZUjPlCKCoYH5v93
         Fb8Zi+C2r4GD0kuzUTMOwA1qzp5vpdiwrTTj4DF5zf282045QrmxwDyHWMrrwAsIpQ
         OKZpqQWe3wyBjfoyxvxzGoH1hcHPt2DmG2tGGwKYs7GZfDYSQCQsxyT+3XTV9qAR/e
         TzGuhLzOr8FaQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, james.smart@broadcom.com,
        jejb@linux.ibm.com, hare@suse.de, dwagner@suse.de,
        nathan@kernel.org, colin.king@canonical.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 17/40] scsi: elx: efct: Do not hold lock while calling fc_vport_terminate()
Date:   Tue, 28 Sep 2021 01:55:01 -0400
Message-Id: <20210928055524.172051-17-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210928055524.172051-1-sashal@kernel.org>
References: <20210928055524.172051-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

