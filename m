Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8365411FF
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356752AbiFGTnZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:43:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357608AbiFGTmJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:42:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B00B71B5872;
        Tue,  7 Jun 2022 11:15:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C7D7D608CD;
        Tue,  7 Jun 2022 18:15:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D210DC385A2;
        Tue,  7 Jun 2022 18:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625728;
        bh=6c21A1kbnXmKe8tly4EAnWS1CNBZxBOYlSwgTiYeW1Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l7QvaqvLc5Ll97Eej0ModQi5kxTR2VytK8P18OqaTfmK5nR4tJwfGilOAARhCzi99
         7UJwDR7U/vOlmDoIKIDi0ikD/Jw16vpmYFuHd/9macuZF3XIBNt/VeGLQH0zdZ1K8B
         iREIk5jOdvhE/R0DBnXuJapOAHgmsU08AhOAcEbM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Justin Tee <justin.tee@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 081/772] scsi: lpfc: Fix call trace observed during I/O with CMF enabled
Date:   Tue,  7 Jun 2022 18:54:33 +0200
Message-Id: <20220607164951.428465700@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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
index 6cc94fae01b8..d9a8e3a59d94 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -3936,7 +3936,7 @@ lpfc_update_cmf_cmpl(struct lpfc_hba *phba,
 		else
 			time = div_u64(time + 500, 1000); /* round it */
 
-		cgs = this_cpu_ptr(phba->cmf_stat);
+		cgs = per_cpu_ptr(phba->cmf_stat, raw_smp_processor_id());
 		atomic64_add(size, &cgs->rcv_bytes);
 		atomic64_add(time, &cgs->rx_latency);
 		atomic_inc(&cgs->rx_io_cnt);
@@ -3980,7 +3980,7 @@ lpfc_update_cmf_cmd(struct lpfc_hba *phba, uint32_t size)
 			atomic_set(&phba->rx_max_read_cnt, size);
 	}
 
-	cgs = this_cpu_ptr(phba->cmf_stat);
+	cgs = per_cpu_ptr(phba->cmf_stat, raw_smp_processor_id());
 	atomic64_add(size, &cgs->total_bytes);
 	return 0;
 }
-- 
2.35.1



