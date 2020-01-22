Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 635C5145691
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:36:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730995AbgAVN1t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:27:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:49496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731806AbgAVN1s (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:27:48 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8AEE20678;
        Wed, 22 Jan 2020 13:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699668;
        bh=rMJpW72a9e+MfLrCZdg2hQqhumhsVPzcIB18p64kLCI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F04G8oM/3SRN6vvlVStdbW5p+ji/m6k/O/sQNQHKDxDf2hnatoavWCHqqrm6Jk0s+
         de36taq7k5XhAsRhfj/wczd/OTR36t5Wr+23USp9o+5KQPy+okIkScg5Cw04S5S2gJ
         d7FQsTxB8uaR5ERrPWzbL29TqskB6Wp16x+gNw0c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        James Smart <james.smart@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.4 213/222] scsi: lpfc: Fix a kernel warning triggered by lpfc_get_sgl_per_hdwq()
Date:   Wed, 22 Jan 2020 10:29:59 +0100
Message-Id: <20200122092848.944976380@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

commit 765ab6cdac3b681952da0e22184bf6cf1ae41cf8 upstream.

Fix the following kernel bug report:

BUG: using smp_processor_id() in preemptible [00000000] code: systemd-udevd/954

Fixes: d79c9e9d4b3d ("scsi: lpfc: Support dynamic unbounded SGL lists on G7 hardware.")
Link: https://lore.kernel.org/r/20191107052158.25788-2-bvanassche@acm.org
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: James Smart <james.smart@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/lpfc/lpfc_sli.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -20430,7 +20430,7 @@ lpfc_get_sgl_per_hdwq(struct lpfc_hba *p
 		/* allocate more */
 		spin_unlock_irqrestore(&hdwq->hdwq_lock, iflags);
 		tmp = kmalloc_node(sizeof(*tmp), GFP_ATOMIC,
-				   cpu_to_node(smp_processor_id()));
+				   cpu_to_node(raw_smp_processor_id()));
 		if (!tmp) {
 			lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
 					"8353 error kmalloc memory for HDWQ "
@@ -20573,7 +20573,7 @@ lpfc_get_cmd_rsp_buf_per_hdwq(struct lpf
 		/* allocate more */
 		spin_unlock_irqrestore(&hdwq->hdwq_lock, iflags);
 		tmp = kmalloc_node(sizeof(*tmp), GFP_ATOMIC,
-				   cpu_to_node(smp_processor_id()));
+				   cpu_to_node(raw_smp_processor_id()));
 		if (!tmp) {
 			lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
 					"8355 error kmalloc memory for HDWQ "


