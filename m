Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74FD4541808
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378829AbiFGVH6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:07:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379474AbiFGVF7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:05:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39B5918F2EE;
        Tue,  7 Jun 2022 11:49:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB76F616FF;
        Tue,  7 Jun 2022 18:49:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D35BAC385A2;
        Tue,  7 Jun 2022 18:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627774;
        bh=kdM3fNE5gu/C38KDzzmn5dQwtfjNDKoBsKPgDt1kxYY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YENpRzuEfjIOs2D61Bh6R2C+BoNNm9W7StHLNGuBkqwy/6wu4KigxFADt9ymJRqdK
         eAX0TxT6U/dj73nNXfzrD3IkRtespqvoibyQqhPg8pDXE37tJ/yO0EuMMnQoc7c9Dj
         h/wvd/Wp0ioDs/HZVxr/Ti/6/Qt8EbCt4ZDdiCBo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Justin Tee <justin.tee@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 088/879] scsi: lpfc: Move cfg_log_verbose check before calling lpfc_dmp_dbg()
Date:   Tue,  7 Jun 2022 18:53:26 +0200
Message-Id: <20220607165005.247623393@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit e294647b1aed4247fe52851f3a3b2b19ae906228 ]

In an attempt to log message 0126 with LOG_TRACE_EVENT, the following hard
lockup call trace hangs the system.

Call Trace:
 _raw_spin_lock_irqsave+0x32/0x40
 lpfc_dmp_dbg.part.32+0x28/0x220 [lpfc]
 lpfc_cmpl_els_fdisc+0x145/0x460 [lpfc]
 lpfc_sli_cancel_jobs+0x92/0xd0 [lpfc]
 lpfc_els_flush_cmd+0x43c/0x670 [lpfc]
 lpfc_els_flush_all_cmd+0x37/0x60 [lpfc]
 lpfc_sli4_async_event_proc+0x956/0x1720 [lpfc]
 lpfc_do_work+0x1485/0x1d70 [lpfc]
 kthread+0x112/0x130
 ret_from_fork+0x1f/0x40
Kernel panic - not syncing: Hard LOCKUP

The same CPU tries to claim the phba->port_list_lock twice.

Move the cfg_log_verbose checks as part of the lpfc_printf_vlog() and
lpfc_printf_log() macros before calling lpfc_dmp_dbg().  There is no need
to take the phba->port_list_lock within lpfc_dmp_dbg().

Link: https://lore.kernel.org/r/20220412222008.126521-3-jsmart2021@gmail.com
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_init.c   | 29 +----------------------------
 drivers/scsi/lpfc/lpfc_logmsg.h |  6 +++---
 2 files changed, 4 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 461d333b1b3a..f9cd4b72d949 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -15700,34 +15700,7 @@ void lpfc_dmp_dbg(struct lpfc_hba *phba)
 	unsigned int temp_idx;
 	int i;
 	int j = 0;
-	unsigned long rem_nsec, iflags;
-	bool log_verbose = false;
-	struct lpfc_vport *port_iterator;
-
-	/* Don't dump messages if we explicitly set log_verbose for the
-	 * physical port or any vport.
-	 */
-	if (phba->cfg_log_verbose)
-		return;
-
-	spin_lock_irqsave(&phba->port_list_lock, iflags);
-	list_for_each_entry(port_iterator, &phba->port_list, listentry) {
-		if (port_iterator->load_flag & FC_UNLOADING)
-			continue;
-		if (scsi_host_get(lpfc_shost_from_vport(port_iterator))) {
-			if (port_iterator->cfg_log_verbose)
-				log_verbose = true;
-
-			scsi_host_put(lpfc_shost_from_vport(port_iterator));
-
-			if (log_verbose) {
-				spin_unlock_irqrestore(&phba->port_list_lock,
-						       iflags);
-				return;
-			}
-		}
-	}
-	spin_unlock_irqrestore(&phba->port_list_lock, iflags);
+	unsigned long rem_nsec;
 
 	if (atomic_cmpxchg(&phba->dbg_log_dmping, 0, 1) != 0)
 		return;
diff --git a/drivers/scsi/lpfc/lpfc_logmsg.h b/drivers/scsi/lpfc/lpfc_logmsg.h
index 7d480c798794..a5aafe230c74 100644
--- a/drivers/scsi/lpfc/lpfc_logmsg.h
+++ b/drivers/scsi/lpfc/lpfc_logmsg.h
@@ -73,7 +73,7 @@ do { \
 #define lpfc_printf_vlog(vport, level, mask, fmt, arg...) \
 do { \
 	{ if (((mask) & (vport)->cfg_log_verbose) || (level[1] <= '3')) { \
-		if ((mask) & LOG_TRACE_EVENT) \
+		if ((mask) & LOG_TRACE_EVENT && !(vport)->cfg_log_verbose) \
 			lpfc_dmp_dbg((vport)->phba); \
 		dev_printk(level, &((vport)->phba->pcidev)->dev, "%d:(%d):" \
 			   fmt, (vport)->phba->brd_no, vport->vpi, ##arg);  \
@@ -89,11 +89,11 @@ do { \
 				 (phba)->pport->cfg_log_verbose : \
 				 (phba)->cfg_log_verbose; \
 	if (((mask) & log_verbose) || (level[1] <= '3')) { \
-		if ((mask) & LOG_TRACE_EVENT) \
+		if ((mask) & LOG_TRACE_EVENT && !log_verbose) \
 			lpfc_dmp_dbg(phba); \
 		dev_printk(level, &((phba)->pcidev)->dev, "%d:" \
 			fmt, phba->brd_no, ##arg); \
-	} else  if (!(phba)->cfg_log_verbose)\
+	} else if (!log_verbose)\
 		lpfc_dbg_print(phba, "%d:" fmt, phba->brd_no, ##arg); \
 	} \
 } while (0)
-- 
2.35.1



