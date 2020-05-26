Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 348C21BC821
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728894AbgD1S3w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:29:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:43834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729417AbgD1S3u (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:29:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C43BC20730;
        Tue, 28 Apr 2020 18:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098590;
        bh=bNVdSBgTrAiEhSZBP78RjqSO2iW2UM/yNJ3jlJzalm4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OqTuc+CDx8WEoRn5G/07BMkNjlmkzlv28N3yuyf6jrP9lMi0srE4ZNlvhNNBTU67q
         KphkOfGOydhEGloHga//xPXikRPbdE+D15TBd9iACowXicSLA5q8jrxzLRB/5JfyQr
         gFLc5WEzk/zd/rXk750gwOU60abVUss9HkDNgvUA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 036/167] scsi: lpfc: Fix lockdep error - register non-static key
Date:   Tue, 28 Apr 2020 20:23:32 +0200
Message-Id: <20200428182229.706573817@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182225.451225420@linuxfoundation.org>
References: <20200428182225.451225420@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index d2bbcf8cae4c3..48fde2b1ebbab 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -11203,11 +11203,9 @@ static void lpfc_cpuhp_add(struct lpfc_hba *phba)
 
 	rcu_read_lock();
 
-	if (!list_empty(&phba->poll_list)) {
-		timer_setup(&phba->cpuhp_poll_timer, lpfc_sli4_poll_hbtimer, 0);
+	if (!list_empty(&phba->poll_list))
 		mod_timer(&phba->cpuhp_poll_timer,
 			  jiffies + msecs_to_jiffies(LPFC_POLL_HB));
-	}
 
 	rcu_read_unlock();
 
@@ -13173,6 +13171,7 @@ lpfc_pci_probe_one_s4(struct pci_dev *pdev, const struct pci_device_id *pid)
 	lpfc_sli4_ras_setup(phba);
 
 	INIT_LIST_HEAD(&phba->poll_list);
+	timer_setup(&phba->cpuhp_poll_timer, lpfc_sli4_poll_hbtimer, 0);
 	cpuhp_state_add_instance_nocalls(lpfc_cpuhp_state, &phba->cpuhp);
 
 	return 0;
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index de97727458fc7..396e24764a1b1 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -14457,12 +14457,10 @@ static inline void lpfc_sli4_add_to_poll_list(struct lpfc_queue *eq)
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



