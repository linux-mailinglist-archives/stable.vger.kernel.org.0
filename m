Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 731523C55D9
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349100AbhGLIMR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:12:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:55268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354010AbhGLIDX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:03:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5917B611AD;
        Mon, 12 Jul 2021 07:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076761;
        bh=N+Qg+MafAsA7CmFrByQcZzXIAgDBszJvf2L/2bYoSSY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d6okJRo2UuSbveX8QK2KL1T6WA5eaQVVnWeQUoGMx1uXEdNjKR8evQIpYHSOJFpBU
         Mi5cLWlDpOyf84n0dZsOPT6Ymz9wsZDg76dYbFslWG/K2zodx7AnwhOyJzNJOnGxfm
         MQLofGdSbjWfK/nBJSpfrkaysKFu1lv+jqpIKyWk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.13 782/800] scsi: megaraid_sas: Send all non-RW I/Os for TYPE_ENCLOSURE device through firmware
Date:   Mon, 12 Jul 2021 08:13:25 +0200
Message-Id: <20210712061050.054065045@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

commit 79db830162b733f5f3ee80f0673eeeb0245fe38b upstream.

The driver issues all non-ReadWrite I/Os for TYPE_ENCLOSURE devices through
the fast path with invalid dev handle. Fast path in turn directs all the
I/Os to the firmware. As firmware stopped handling those I/Os from SAS3.5
generation of controllers (Ventura generation and onwards) this will lead
to I/O failures.

Switch the driver to issue all the non-ReadWrite I/Os for TYPE_ENCLOSURE
devices directly to firmware for SAS3.5 generation of controllers and
later.

Link: https://lore.kernel.org/r/20210528131307.25683-2-chandrakanth.patil@broadcom.com
Cc: <stable@vger.kernel.org> # v5.11+
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/megaraid/megaraid_sas_fusion.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -3203,6 +3203,8 @@ megasas_build_io_fusion(struct megasas_i
 {
 	int sge_count;
 	u8  cmd_type;
+	u16 pd_index = 0;
+	u8 drive_type = 0;
 	struct MPI2_RAID_SCSI_IO_REQUEST *io_request = cmd->io_request;
 	struct MR_PRIV_DEVICE *mr_device_priv_data;
 	mr_device_priv_data = scp->device->hostdata;
@@ -3237,8 +3239,12 @@ megasas_build_io_fusion(struct megasas_i
 		megasas_build_syspd_fusion(instance, scp, cmd, true);
 		break;
 	case NON_READ_WRITE_SYSPDIO:
-		if (instance->secure_jbod_support ||
-		    mr_device_priv_data->is_tm_capable)
+		pd_index = MEGASAS_PD_INDEX(scp);
+		drive_type = instance->pd_list[pd_index].driveType;
+		if ((instance->secure_jbod_support ||
+		     mr_device_priv_data->is_tm_capable) ||
+		     (instance->adapter_type >= VENTURA_SERIES &&
+		     drive_type == TYPE_ENCLOSURE))
 			megasas_build_syspd_fusion(instance, scp, cmd, false);
 		else
 			megasas_build_syspd_fusion(instance, scp, cmd, true);


