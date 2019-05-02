Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3D511D88
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728978AbfEBPb1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:31:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:50472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728971AbfEBPbX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:31:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39E9221743;
        Thu,  2 May 2019 15:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556811082;
        bh=UXox07gya+8BzlZCkyJi7qpgFJZ2wTsn0im4QTjqms4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PZoqo6hbXevZFfym692MdNxYsP1UZshLu//FsUR2wiavm/zpW1Ixd7JRJNmwCyAlQ
         HGURRjxsKwowfEYfWHYT+9+9xEI6ixIkhoP2E7lW1iM2OcqqKIDNcurQIlKPridbFE
         RsKouamOjDD3JKTb/1HZn7m8MOAZoRcGBs8lsy8U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 5.0 066/101] scsi: mpt3sas: Fix kernel panic during expander reset
Date:   Thu,  2 May 2019 17:21:08 +0200
Message-Id: <20190502143344.268202617@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143339.434882399@linuxfoundation.org>
References: <20190502143339.434882399@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit c2fe742ff6e77c5b4fe4ad273191ddf28fdea25e ]

During expander reset handling, the driver invokes kernel function
scsi_host_find_tag() to obtain outstanding requests associated with the
scsi host managed by the driver. Driver loops from tag value zero to hba
queue depth to obtain the outstanding scmds. But when blk-mq is enabled,
the block layer may return stale entry for one or more requests. This may
lead to kernel panic if the returned value is inaccessible or the memory
pointed by the returned value is reused.

Reference of upstream discussion:

	https://patchwork.kernel.org/patch/10734933/

Instead of calling scsi_host_find_tag() API for each and every smid (smid
is tag +1) from one to shost->can_queue, now driver will call this API (to
obtain the outstanding scmd) only for those smid's which are outstanding at
the driver level.

Driver will determine whether this smid is outstanding at driver level by
looking into it's corresponding MPI request frame, if its MPI request frame
is empty, then it means that this smid is free and does not need to call
scsi_host_find_tag() for it.  By doing this, driver will invoke
scsi_host_find_tag() for only those tags which are outstanding at the
driver level.

Driver will check whether particular MPI request frame is empty or not by
looking into the "DevHandle" field. If this field is zero then it means
that this MPI request is empty. For active MPI request DevHandle must be
non-zero.

Also driver will memset the MPI request frame once the corresponding scmd
is processed (i.e. just before calling
scmd->done function).

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c  |  6 ++++++
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 12 ++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 0a6cb8f0680c..c39f88100f31 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -3281,12 +3281,18 @@ mpt3sas_base_free_smid(struct MPT3SAS_ADAPTER *ioc, u16 smid)
 
 	if (smid < ioc->hi_priority_smid) {
 		struct scsiio_tracker *st;
+		void *request;
 
 		st = _get_st_from_smid(ioc, smid);
 		if (!st) {
 			_base_recovery_check(ioc);
 			return;
 		}
+
+		/* Clear MPI request frame */
+		request = mpt3sas_base_get_msg_frame(ioc, smid);
+		memset(request, 0, ioc->request_sz);
+
 		mpt3sas_base_clear_st(ioc, st);
 		_base_recovery_check(ioc);
 		return;
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 6be39dc27103..6173c211a5e5 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -1462,11 +1462,23 @@ mpt3sas_scsih_scsi_lookup_get(struct MPT3SAS_ADAPTER *ioc, u16 smid)
 {
 	struct scsi_cmnd *scmd = NULL;
 	struct scsiio_tracker *st;
+	Mpi25SCSIIORequest_t *mpi_request;
 
 	if (smid > 0  &&
 	    smid <= ioc->scsiio_depth - INTERNAL_SCSIIO_CMDS_COUNT) {
 		u32 unique_tag = smid - 1;
 
+		mpi_request = mpt3sas_base_get_msg_frame(ioc, smid);
+
+		/*
+		 * If SCSI IO request is outstanding at driver level then
+		 * DevHandle filed must be non-zero. If DevHandle is zero
+		 * then it means that this smid is free at driver level,
+		 * so return NULL.
+		 */
+		if (!mpi_request->DevHandle)
+			return scmd;
+
 		scmd = scsi_host_find_tag(ioc->shost, unique_tag);
 		if (scmd) {
 			st = scsi_cmd_priv(scmd);
-- 
2.19.1



