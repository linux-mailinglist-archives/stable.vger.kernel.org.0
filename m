Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFD29E691C
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:34:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729777AbfJ0VKw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:10:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:57358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729770AbfJ0VKw (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:10:52 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52E4A214AF;
        Sun, 27 Oct 2019 21:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210650;
        bh=hOIWh6sD8eanVs3fL3OUNBF9iJgLBnjhqtR80HCmals=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OYb7nFAvJOHztSbRt97DveTjzWxyDpjD5Z5oh4PD+Jt8TqOjsHkrdlpivDHKqKqGs
         vgSBsQN1u7LqMhbM19OytTs3TPRYHs26xucEwVO/V8qy4yZIdUjWp3UlVT/Iw1J6rq
         RiggwOEmLLdII8TtYCH8C0P6Zbib+FmxRBr8gcz8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.14 088/119] scsi: core: save/restore command resid for error handling
Date:   Sun, 27 Oct 2019 22:01:05 +0100
Message-Id: <20191027203347.970364903@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203259.948006506@linuxfoundation.org>
References: <20191027203259.948006506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Damien Le Moal <damien.lemoal@wdc.com>

commit 8f8fed0cdbbd6cdbf28d9ebe662f45765d2f7d39 upstream.

When a non-passthrough command is terminated with CHECK CONDITION, request
sense is executed by hijacking the command descriptor. Since
scsi_eh_prep_cmnd() and scsi_eh_restore_cmnd() do not save/restore the
original command resid, the value returned on failure of the original
command is lost and replaced with the value set by the execution of the
request sense command. This value may in many instances be unaligned to the
device sector size, causing sd_done() to print a warning message about the
incorrect unaligned resid before the command is retried.

Fix this problem by saving the original command residual in struct
scsi_eh_save using scsi_eh_prep_cmnd() and restoring it in
scsi_eh_restore_cmnd(). In addition, to make sure that the request sense
command is executed with a correctly initialized command structure, also
reset the residual to 0 in scsi_eh_prep_cmnd() after saving the original
command value in struct scsi_eh_save.

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20191001074839.1994-1-damien.lemoal@wdc.com
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/scsi_error.c |    3 +++
 include/scsi/scsi_eh.h    |    1 +
 2 files changed, 4 insertions(+)

--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -935,6 +935,7 @@ void scsi_eh_prep_cmnd(struct scsi_cmnd
 	ses->sdb = scmd->sdb;
 	ses->next_rq = scmd->request->next_rq;
 	ses->result = scmd->result;
+	ses->resid_len = scmd->req.resid_len;
 	ses->underflow = scmd->underflow;
 	ses->prot_op = scmd->prot_op;
 	ses->eh_eflags = scmd->eh_eflags;
@@ -946,6 +947,7 @@ void scsi_eh_prep_cmnd(struct scsi_cmnd
 	memset(&scmd->sdb, 0, sizeof(scmd->sdb));
 	scmd->request->next_rq = NULL;
 	scmd->result = 0;
+	scmd->req.resid_len = 0;
 
 	if (sense_bytes) {
 		scmd->sdb.length = min_t(unsigned, SCSI_SENSE_BUFFERSIZE,
@@ -999,6 +1001,7 @@ void scsi_eh_restore_cmnd(struct scsi_cm
 	scmd->sdb = ses->sdb;
 	scmd->request->next_rq = ses->next_rq;
 	scmd->result = ses->result;
+	scmd->req.resid_len = ses->resid_len;
 	scmd->underflow = ses->underflow;
 	scmd->prot_op = ses->prot_op;
 	scmd->eh_eflags = ses->eh_eflags;
--- a/include/scsi/scsi_eh.h
+++ b/include/scsi/scsi_eh.h
@@ -32,6 +32,7 @@ extern int scsi_ioctl_reset(struct scsi_
 struct scsi_eh_save {
 	/* saved state */
 	int result;
+	unsigned int resid_len;
 	int eh_eflags;
 	enum dma_data_direction data_direction;
 	unsigned underflow;


