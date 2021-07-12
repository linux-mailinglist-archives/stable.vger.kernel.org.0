Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E60D3C503A
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242651AbhGLHbp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:31:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:44206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344566AbhGLH3f (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:29:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B7BC61474;
        Mon, 12 Jul 2021 07:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074740;
        bh=qx/HLqBgUvJolMSYnD8nwqfkTJ1Ug/+oFIpKC7CGhUM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y6YnGeqzlexOrF+tfOjDwS3gQwk+Ag11i2w3/nWxgjCuQYVSM0GpcA9rt5vT+Z4Rm
         Dt3PQbNlkAvZOgsJdL4S4/HOwT5BBi7btfXTJDS/HiypLDGvilhajFdK6YAMIJ+CAw
         F0ZO22JBzmoHeNQ6aGgtTDID7A6Eyw6vprNjXhg0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.12 682/700] scsi: megaraid_sas: Send all non-RW I/Os for TYPE_ENCLOSURE device through firmware
Date:   Mon, 12 Jul 2021 08:12:45 +0200
Message-Id: <20210712061048.457170994@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
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
@@ -3167,6 +3167,8 @@ megasas_build_io_fusion(struct megasas_i
 {
 	int sge_count;
 	u8  cmd_type;
+	u16 pd_index = 0;
+	u8 drive_type = 0;
 	struct MPI2_RAID_SCSI_IO_REQUEST *io_request = cmd->io_request;
 	struct MR_PRIV_DEVICE *mr_device_priv_data;
 	mr_device_priv_data = scp->device->hostdata;
@@ -3201,8 +3203,12 @@ megasas_build_io_fusion(struct megasas_i
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


