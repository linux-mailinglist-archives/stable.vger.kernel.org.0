Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 322A9107015
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbfKVLUI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:20:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:53004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728746AbfKVKqF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:46:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11AC820656;
        Fri, 22 Nov 2019 10:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419564;
        bh=T8Fo9Pn98qtvxKBkA+60vnG5I9y3wq+vC9UpR37GxZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vAAdsfStXRMhCN4ajzfDnOsR72X1FHQrE7/cRiYEAoJ1gmeoqx8dycws8e6xZo9PP
         tjHkbk0FU6Y12sJIRc3J1zQ28MlE9H4qOHiY4d5YdES5GCxAiVVgE8M/pYt+Vz8aBY
         m3kev7lT/kq7jXU+/r/bIQzpBkDjMe/wf6iWmKjA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krishna Ram Prakash R <krp@gtux.in>,
        Kees Cook <keescook@chromium.org>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4.9 154/222] libata: have ata_scsi_rw_xlat() fail invalid passthrough requests
Date:   Fri, 22 Nov 2019 11:28:14 +0100
Message-Id: <20191122100913.838547114@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100830.874290814@linuxfoundation.org>
References: <20191122100830.874290814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 2d7271501720038381d45fb3dcbe4831228fc8cc upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/libata-scsi.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1734,6 +1734,21 @@ nothing_to_do:
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
@@ -1776,6 +1791,8 @@ static unsigned int ata_scsi_rw_xlat(str
 		scsi_10_lba_len(cdb, &block, &n_block);
 		if (cdb[1] & (1 << 3))
 			tf_flags |= ATA_TFLAG_FUA;
+		if (!ata_check_nblocks(scmd, n_block))
+			goto invalid_fld;
 		break;
 	case READ_6:
 	case WRITE_6:
@@ -1790,6 +1807,8 @@ static unsigned int ata_scsi_rw_xlat(str
 		 */
 		if (!n_block)
 			n_block = 256;
+		if (!ata_check_nblocks(scmd, n_block))
+			goto invalid_fld;
 		break;
 	case READ_16:
 	case WRITE_16:
@@ -1800,6 +1819,8 @@ static unsigned int ata_scsi_rw_xlat(str
 		scsi_16_lba_len(cdb, &block, &n_block);
 		if (cdb[1] & (1 << 3))
 			tf_flags |= ATA_TFLAG_FUA;
+		if (!ata_check_nblocks(scmd, n_block))
+			goto invalid_fld;
 		break;
 	default:
 		DPRINTK("no-byte command\n");


