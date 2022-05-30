Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39BFA537C56
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 15:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236951AbiE3N2y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 09:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236959AbiE3N2F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 09:28:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A5F68A055;
        Mon, 30 May 2022 06:26:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7085960ED7;
        Mon, 30 May 2022 13:25:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C67D3C385B8;
        Mon, 30 May 2022 13:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917151;
        bh=NQr4DnHVulh4RbREC1iNFCv8RKjtbaKcjTm0ZM5tSvU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nw+2E8UMYNOOogM7+uLYuW1TurdH3v55iPI5rp0tV4AAMpbB2NLTUHM/Tie9B3QNk
         hyg8qjNrfNyDljFAYswwkbx7k1XxKB3005VPeB68zkZ07JlfTHgONyKyBQg0WYtLP1
         KqWNDQQmlICcfRA5PldUpy63aaeRSodYZUBfidXbsqnBiVGeITeR33Lz7oozFEwovx
         iwjrR+FU5U3Lnf006YF/jignqzbNZ6iB7f4rpcyQy3a5WpI9X86Iaa1dtJQoWhHqYN
         MXZzdBxdUQTirZya7NaQtBwj0FnzKsaQLH38f3jNLFCzvV0vzDzPujoMHK7LsfBLVY
         7ybNk3/mx9OXg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, james.smart@broadcom.com,
        dick.kennedy@broadcom.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 039/159] scsi: lpfc: Fix call trace observed during I/O with CMF enabled
Date:   Mon, 30 May 2022 09:22:24 -0400
Message-Id: <20220530132425.1929512-39-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530132425.1929512-1-sashal@kernel.org>
References: <20220530132425.1929512-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit d6d45f67a11136cb88a70a29ab22ea6db8ae6bd5 ]

The following was seen with CMF enabled:

BUG: using smp_processor_id() in preemptible
code: systemd-udevd/31711
kernel: caller is lpfc_update_cmf_cmd+0x214/0x420  [lpfc]
kernel: CPU: 12 PID: 31711 Comm: systemd-udevd
kernel: Call Trace:
kernel: <TASK>
kernel: dump_stack_lvl+0x44/0x57
kernel: check_preemption_disabled+0xbf/0xe0
kernel: lpfc_update_cmf_cmd+0x214/0x420 [lpfc]
kernel: lpfc_nvme_fcp_io_submit+0x23b4/0x4df0 [lpfc]

this_cpu_ptr() calls smp_processor_id() in a preemptible context.

Fix by using per_cpu_ptr() with raw_smp_processor_id() instead.

Link: https://lore.kernel.org/r/20220412222008.126521-16-jsmart2021@gmail.com
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index c4fa7d68fe03..f617a2ef6b0f 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -3835,7 +3835,7 @@ lpfc_update_cmf_cmpl(struct lpfc_hba *phba,
 		else
 			time = div_u64(time + 500, 1000); /* round it */
 
-		cgs = this_cpu_ptr(phba->cmf_stat);
+		cgs = per_cpu_ptr(phba->cmf_stat, raw_smp_processor_id());
 		atomic64_add(size, &cgs->rcv_bytes);
 		atomic64_add(time, &cgs->rx_latency);
 		atomic_inc(&cgs->rx_io_cnt);
@@ -3879,7 +3879,7 @@ lpfc_update_cmf_cmd(struct lpfc_hba *phba, uint32_t size)
 			atomic_set(&phba->rx_max_read_cnt, size);
 	}
 
-	cgs = this_cpu_ptr(phba->cmf_stat);
+	cgs = per_cpu_ptr(phba->cmf_stat, raw_smp_processor_id());
 	atomic64_add(size, &cgs->total_bytes);
 	return 0;
 }
-- 
2.35.1

