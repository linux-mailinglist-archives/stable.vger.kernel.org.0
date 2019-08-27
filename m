Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 468239DFB5
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 09:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730097AbfH0H4p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 03:56:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:48816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729171AbfH0H4p (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 03:56:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15928206BF;
        Tue, 27 Aug 2019 07:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892604;
        bh=4k5ZawLjOk0KvC7nDaRZudQNNKznOxkAFASAwaEHZtI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pnHq5mne4vnu/tKEH2SIWpAmm8nhV8DT5kuJW/QSf0ornMaz26v47DY1/Gzd6VNqT
         bWO0IsO+MVbs6qZ44G7cWk3BdWkGQWHS6n5aUyoS2sTQDqwmz+O5c7hJLyHulyYyEJ
         PVZH3dm9fmKMz3UGs7h96Wr3cLMiN0YQNWE8M/nU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krishna Ram Prakash R <krp@gtux.in>,
        Kees Cook <keescook@chromium.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 48/98] libata: have ata_scsi_rw_xlat() fail invalid passthrough requests
Date:   Tue, 27 Aug 2019 09:50:27 +0200
Message-Id: <20190827072720.874336466@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072718.142728620@linuxfoundation.org>
References: <20190827072718.142728620@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 2d7271501720038381d45fb3dcbe4831228fc8cc ]

For passthrough requests, libata-scsi takes what the user passes in
as gospel. This can be problematic if the user fills in the CDB
incorrectly. One example of that is in request sizes. For read/write
commands, the CDB contains fields describing the transfer length of
the request. These should match with the SG_IO header fields, but
libata-scsi currently does no validation of that.

Check that the number of blocks in the CDB for passthrough requests
matches what was mapped into the request. If the CDB asks for more
data then the validated SG_IO header fields, error it.

Reported-by: Krishna Ram Prakash R <krp@gtux.in>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-scsi.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 1984fc78c750b..3a64fa4aaf7e3 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1803,6 +1803,21 @@ nothing_to_do:
 	return 1;
 }
 
+static bool ata_check_nblocks(struct scsi_cmnd *scmd, u32 n_blocks)
+{
+	struct request *rq = scmd->request;
+	u32 req_blocks;
+
+	if (!blk_rq_is_passthrough(rq))
+		return true;
+
+	req_blocks = blk_rq_bytes(rq) / scmd->device->sector_size;
+	if (n_blocks > req_blocks)
+		return false;
+
+	return true;
+}
+
 /**
  *	ata_scsi_rw_xlat - Translate SCSI r/w command into an ATA one
  *	@qc: Storage for translated ATA taskfile
@@ -1847,6 +1862,8 @@ static unsigned int ata_scsi_rw_xlat(struct ata_queued_cmd *qc)
 		scsi_10_lba_len(cdb, &block, &n_block);
 		if (cdb[1] & (1 << 3))
 			tf_flags |= ATA_TFLAG_FUA;
+		if (!ata_check_nblocks(scmd, n_block))
+			goto invalid_fld;
 		break;
 	case READ_6:
 	case WRITE_6:
@@ -1861,6 +1878,8 @@ static unsigned int ata_scsi_rw_xlat(struct ata_queued_cmd *qc)
 		 */
 		if (!n_block)
 			n_block = 256;
+		if (!ata_check_nblocks(scmd, n_block))
+			goto invalid_fld;
 		break;
 	case READ_16:
 	case WRITE_16:
@@ -1871,6 +1890,8 @@ static unsigned int ata_scsi_rw_xlat(struct ata_queued_cmd *qc)
 		scsi_16_lba_len(cdb, &block, &n_block);
 		if (cdb[1] & (1 << 3))
 			tf_flags |= ATA_TFLAG_FUA;
+		if (!ata_check_nblocks(scmd, n_block))
+			goto invalid_fld;
 		break;
 	default:
 		DPRINTK("no-byte command\n");
-- 
2.20.1



