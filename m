Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9BC69E075
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:05:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731247AbfH0ID5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:03:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:33192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730723AbfH0ID4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:03:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CDD5206BF;
        Tue, 27 Aug 2019 08:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566893035;
        bh=x13b0bhLspyWjAcJ1/Iahk8nLasSgH+cdoPMoU/33/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SG+hKVaTm4qFMEpDyCInf7yPdyJDV0wYaxkiMb7nx5EGF2gwQnt1kmJ2pPyX6FNXI
         c5zroOVnjZjir+RZZCUMzYhvwGudWO+3cZwAzJ6M4l1eYqX0b0Ocl/BzfeEbxIay4j
         JpawUiS1t2l3PzMGsy/hyr4XtRKapMItTf0j54Qc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krishna Ram Prakash R <krp@gtux.in>,
        Kees Cook <keescook@chromium.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 097/162] libata: have ata_scsi_rw_xlat() fail invalid passthrough requests
Date:   Tue, 27 Aug 2019 09:50:25 +0200
Message-Id: <20190827072741.598307291@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072738.093683223@linuxfoundation.org>
References: <20190827072738.093683223@linuxfoundation.org>
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
index 391ac0503dc07..76d0f9de767bc 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1786,6 +1786,21 @@ nothing_to_do:
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
@@ -1830,6 +1845,8 @@ static unsigned int ata_scsi_rw_xlat(struct ata_queued_cmd *qc)
 		scsi_10_lba_len(cdb, &block, &n_block);
 		if (cdb[1] & (1 << 3))
 			tf_flags |= ATA_TFLAG_FUA;
+		if (!ata_check_nblocks(scmd, n_block))
+			goto invalid_fld;
 		break;
 	case READ_6:
 	case WRITE_6:
@@ -1844,6 +1861,8 @@ static unsigned int ata_scsi_rw_xlat(struct ata_queued_cmd *qc)
 		 */
 		if (!n_block)
 			n_block = 256;
+		if (!ata_check_nblocks(scmd, n_block))
+			goto invalid_fld;
 		break;
 	case READ_16:
 	case WRITE_16:
@@ -1854,6 +1873,8 @@ static unsigned int ata_scsi_rw_xlat(struct ata_queued_cmd *qc)
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



