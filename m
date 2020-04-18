Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB8F81AEE50
	for <lists+stable@lfdr.de>; Sat, 18 Apr 2020 16:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbgDROM1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Apr 2020 10:12:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:38010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726833AbgDROKJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 Apr 2020 10:10:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F11B2220A;
        Sat, 18 Apr 2020 14:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587219009;
        bh=b6vwiRyhH7IFsNLU2DodvnOmmbNwKwzQlS9KqINAFUA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jruncwRwttrROBiAB9mqI5i1m8Mh2BRavA2XWJK2UMhvHrX0XxkjMaN7HAuMm/vya
         Dh8Szqu4cBoxMSe/QovD2x7aEzyqlMWMZQTrtY8rfvVEH7oB4A1+/wAY2SoJjqhE2q
         CTCXoKyhDvykusFhT0ClYk3IO+Ji6SbcMwIVs4qg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 46/75] scsi: lpfc: Fix lockdep error - register non-static key
Date:   Sat, 18 Apr 2020 10:08:41 -0400
Message-Id: <20200418140910.8280-46-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200418140910.8280-1-sashal@kernel.org>
References: <20200418140910.8280-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit f861f596714bed06069f1109b89e51f3855c4ddf ]

The following lockdep error was reported when unloading the lpfc driver:

  INFO: trying to register non-static key.
  the code is fine but needs lockdep annotation.
  turning off the locking correctness validator.
  ...
  Call Trace:
  dump_stack+0x96/0xe0
  register_lock_class+0x8b8/0x8c0
  ? lockdep_hardirqs_on+0x190/0x280
  ? is_dynamic_key+0x150/0x150
  ? wait_for_completion_interruptible+0x2a0/0x2a0
  ? wake_up_q+0xd0/0xd0
  __lock_acquire+0xda/0x21a0
  ? register_lock_class+0x8c0/0x8c0
  ? synchronize_rcu_expedited+0x500/0x500
  ? __call_rcu+0x850/0x850
  lock_acquire+0xf3/0x1f0
  ? del_timer_sync+0x5/0xb0
  del_timer_sync+0x3c/0xb0
  ? del_timer_sync+0x5/0xb0
  lpfc_pci_remove_one.cold.102+0x8b7/0x935 [lpfc]
  ...

Unloading the driver resulted in a call to del_timer_sync for the
cpuhp_poll_timer. However the call to setup the timer had never been made,
so the timer structures used by lockdep checking were not initialized.

Unconditionally call setup_timer for the cpuhp_poll_timer during driver
initialization. Calls to start the timer remain "as needed".

Link: https://lore.kernel.org/r/20200322181304.37655-3-jsmart2021@gmail.com
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_init.c | 5 ++---
 drivers/scsi/lpfc/lpfc_sli.c  | 6 ++----
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index d4a90bec93899..42ce31a8fb3c1 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -11209,11 +11209,9 @@ static void lpfc_cpuhp_add(struct lpfc_hba *phba)
 
 	rcu_read_lock();
 
-	if (!list_empty(&phba->poll_list)) {
-		timer_setup(&phba->cpuhp_poll_timer, lpfc_sli4_poll_hbtimer, 0);
+	if (!list_empty(&phba->poll_list))
 		mod_timer(&phba->cpuhp_poll_timer,
 			  jiffies + msecs_to_jiffies(LPFC_POLL_HB));
-	}
 
 	rcu_read_unlock();
 
@@ -13179,6 +13177,7 @@ lpfc_pci_probe_one_s4(struct pci_dev *pdev, const struct pci_device_id *pid)
 	lpfc_sli4_ras_setup(phba);
 
 	INIT_LIST_HEAD(&phba->poll_list);
+	timer_setup(&phba->cpuhp_poll_timer, lpfc_sli4_poll_hbtimer, 0);
 	cpuhp_state_add_instance_nocalls(lpfc_cpuhp_state, &phba->cpuhp);
 
 	return 0;
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 909554c7c1273..409d54e05302f 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -14448,12 +14448,10 @@ static inline void lpfc_sli4_add_to_poll_list(struct lpfc_queue *eq)
 {
 	struct lpfc_hba *phba = eq->phba;
 
-	if (list_empty(&phba->poll_list)) {
-		timer_setup(&phba->cpuhp_poll_timer, lpfc_sli4_poll_hbtimer, 0);
-		/* kickstart slowpath processing for this eq */
+	/* kickstart slowpath processing if needed */
+	if (list_empty(&phba->poll_list))
 		mod_timer(&phba->cpuhp_poll_timer,
 			  jiffies + msecs_to_jiffies(LPFC_POLL_HB));
-	}
 
 	list_add_rcu(&eq->_poll_list, &phba->poll_list);
 	synchronize_rcu();
-- 
2.20.1

