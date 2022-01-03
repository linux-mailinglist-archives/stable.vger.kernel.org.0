Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C17594832A0
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:29:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234163AbiACO30 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:29:26 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58436 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233020AbiACO2K (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:28:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2ACF61073;
        Mon,  3 Jan 2022 14:28:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E757C36AED;
        Mon,  3 Jan 2022 14:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220089;
        bh=q1y2rSOGp+yLXZH6g3odHuz0Pl79A/Cg7YjxsfUUMMk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nt/YjmCSqo9afWCzana4RYMx9wDe51x7RaLNK09VzkMU3oNTlKwMoJxZ/9ReG+uTl
         M8aP2IuoGLen+C/iw1eDx6vLHupgeQMNB8pB/56m5i4r/clby75CQ8DXXgLttB2T/M
         tThGaWODi/8So3KDDqNQtDmNbwDfOw2T1+MIACKI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matt Wang <wwentao@vmware.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Vishal Bhakta <vbhakta@vmware.com>,
        VMware PV-Drivers <pv-drivers@vmware.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, Alexey Makhalov <amakhalov@vmware.com>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>
Subject: [PATCH 5.4 33/37] scsi: vmw_pvscsi: Set residual data length conditionally
Date:   Mon,  3 Jan 2022 15:24:11 +0100
Message-Id: <20220103142052.896574663@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142051.883166998@linuxfoundation.org>
References: <20220103142051.883166998@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Makhalov <amakhalov@vmware.com>

commit 142c779d05d1fef75134c3cb63f52ccbc96d9e1f upstream.

The PVSCSI implementation in the VMware hypervisor under specific
configuration ("SCSI Bus Sharing" set to "Physical") returns zero dataLen
in the completion descriptor for READ CAPACITY(16). As a result, the kernel
can not detect proper disk geometry. This can be recognized by the kernel
message:

  [ 0.776588] sd 1:0:0:0: [sdb] Sector size 0 reported, assuming 512.

The PVSCSI implementation in QEMU does not set dataLen at all, keeping it
zeroed. This leads to a boot hang as was reported by Shmulik Ladkani.

It is likely that the controller returns the garbage at the end of the
buffer. Residual length should be set by the driver in that case. The SCSI
layer will erase corresponding data. See commit bdb2b8cab439 ("[SCSI] erase
invalid data returned by device") for details.

Commit e662502b3a78 ("scsi: vmw_pvscsi: Set correct residual data length")
introduced the issue by setting residual length unconditionally, causing
the SCSI layer to erase the useful payload beyond dataLen when this value
is returned as 0.

As a result, considering existing issues in implementations of PVSCSI
controllers, we do not want to call scsi_set_resid() when dataLen ==
0. Calling scsi_set_resid() has no effect if dataLen equals buffer length.

Link: https://lore.kernel.org/lkml/20210824120028.30d9c071@blondie/
Link: https://lore.kernel.org/r/20211220190514.55935-1-amakhalov@vmware.com
Fixes: e662502b3a78 ("scsi: vmw_pvscsi: Set correct residual data length")
Cc: Matt Wang <wwentao@vmware.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Vishal Bhakta <vbhakta@vmware.com>
Cc: VMware PV-Drivers <pv-drivers@vmware.com>
Cc: James E.J. Bottomley <jejb@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
Cc: stable@vger.kernel.org
Reported-and-suggested-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Signed-off-by: Alexey Makhalov <amakhalov@vmware.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/vmw_pvscsi.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -578,9 +578,12 @@ static void pvscsi_complete_request(stru
 			 * Commands like INQUIRY may transfer less data than
 			 * requested by the initiator via bufflen. Set residual
 			 * count to make upper layer aware of the actual amount
-			 * of data returned.
+			 * of data returned. There are cases when controller
+			 * returns zero dataLen with non zero data - do not set
+			 * residual count in that case.
 			 */
-			scsi_set_resid(cmd, scsi_bufflen(cmd) - e->dataLen);
+			if (e->dataLen && (e->dataLen < scsi_bufflen(cmd)))
+				scsi_set_resid(cmd, scsi_bufflen(cmd) - e->dataLen);
 			cmd->result = (DID_OK << 16);
 			break;
 


