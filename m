Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0354A1579C1
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:17:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728980AbgBJMh7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:37:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:60682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728970AbgBJMh6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:37:58 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B05F24687;
        Mon, 10 Feb 2020 12:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338277;
        bh=9B6miRQh+3DtZ//AIx/cuId/0CWPKh5Z0QEr7g2b1q8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mTNTwQyfMp808AZFfrqkqz12kKcHziNipqrLaAxLvQ7EAyPYsyRaAIOMaz1scpyRN
         mEQ3z+AbjxwCdckCPwhr5SjkDz1WWU4wuoZxzgtaKQkXqZHZ9qvowvsNU0+TzYre9p
         xvrjTDFv50lUd/9HnxucRV03YLd87hWJiZSaa+UY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arun Easi <aeasi@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "Ewan D. Milne" <emilne@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.4 164/309] scsi: qla2xxx: Fix unbound NVME response length
Date:   Mon, 10 Feb 2020 04:32:00 -0800
Message-Id: <20200210122422.008833141@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

commit 00fe717ee1ea3c2979db4f94b1533c57aed8dea9 upstream.

On certain cases when response length is less than 32, NVME response data
is supplied inline in IOCB. This is indicated by some combination of state
flags. There was an instance when a high, and incorrect, response length
was indicated causing driver to overrun buffers. Fix this by checking and
limiting the response payload length.

Fixes: 7401bc18d1ee3 ("scsi: qla2xxx: Add FC-NVMe command handling")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200124045014.23554-1-hmadhani@marvell.com
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
Reviewed-by: Ewan D. Milne <emilne@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/qla2xxx/qla_dbg.c |    6 ------
 drivers/scsi/qla2xxx/qla_dbg.h |    6 ++++++
 drivers/scsi/qla2xxx/qla_isr.c |   12 ++++++++++++
 3 files changed, 18 insertions(+), 6 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -2519,12 +2519,6 @@ qla83xx_fw_dump_failed:
 /*                         Driver Debug Functions.                          */
 /****************************************************************************/
 
-static inline int
-ql_mask_match(uint level)
-{
-	return (level & ql2xextended_error_logging) == level;
-}
-
 /*
  * This function is for formatting and logging debug information.
  * It is to be used when vha is available. It formats the message
--- a/drivers/scsi/qla2xxx/qla_dbg.h
+++ b/drivers/scsi/qla2xxx/qla_dbg.h
@@ -374,3 +374,9 @@ extern int qla24xx_dump_ram(struct qla_h
 extern void qla24xx_pause_risc(struct device_reg_24xx __iomem *,
 	struct qla_hw_data *);
 extern int qla24xx_soft_reset(struct qla_hw_data *);
+
+static inline int
+ql_mask_match(uint level)
+{
+	return (level & ql2xextended_error_logging) == level;
+}
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1897,6 +1897,18 @@ static void qla24xx_nvme_iocb_entry(scsi
 		inbuf = (uint32_t *)&sts->nvme_ersp_data;
 		outbuf = (uint32_t *)fd->rspaddr;
 		iocb->u.nvme.rsp_pyld_len = le16_to_cpu(sts->nvme_rsp_pyld_len);
+		if (unlikely(iocb->u.nvme.rsp_pyld_len >
+		    sizeof(struct nvme_fc_ersp_iu))) {
+			if (ql_mask_match(ql_dbg_io)) {
+				WARN_ONCE(1, "Unexpected response payload length %u.\n",
+				    iocb->u.nvme.rsp_pyld_len);
+				ql_log(ql_log_warn, fcport->vha, 0x5100,
+				    "Unexpected response payload length %u.\n",
+				    iocb->u.nvme.rsp_pyld_len);
+			}
+			iocb->u.nvme.rsp_pyld_len =
+			    sizeof(struct nvme_fc_ersp_iu);
+		}
 		iter = iocb->u.nvme.rsp_pyld_len >> 2;
 		for (; iter; iter--)
 			*outbuf++ = swab32(*inbuf++);


