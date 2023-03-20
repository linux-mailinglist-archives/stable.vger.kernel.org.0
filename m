Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB7EC6C0864
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 02:18:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231255AbjCTBSX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Mar 2023 21:18:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231511AbjCTBSA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Mar 2023 21:18:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4CB18A4C;
        Sun, 19 Mar 2023 18:08:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F9EF611FB;
        Mon, 20 Mar 2023 00:54:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6EC2C433EF;
        Mon, 20 Mar 2023 00:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679273698;
        bh=1W4foeCLv85aF3fzENpo2hQiyMp8Ghi1jk81hvMbQHI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ksuH4WC+O6SjhA3RD4WzV+9OH13oDsAJUPWu6/XGKp7ZOtb02oFt+bGUa9hruTjED
         n+1P3w6BI5OrCNl2ADb7ivx1VIcyJ1lDTW9jkTwsBkYgZ/2JERv7KCEuO1LOxgIn7B
         wZGm+h1sOyKR0pGzMnj0GVUpj0/9MpTgbq5b2ddV7AtDmE5NxC7G+1ulRB1h+44AG1
         45S9lMRCL9Wupxy0Cup3teyj6DhrB2fqIXT+6SKKnDp4X7+LCJ/nuLkLW4ZTpOzSHv
         sLtiDrVyuQ0fq8N51dBVBDZ6sAem/r2hzWQPtfduRObRyx5c++EjeHHWNTDE+ahb7b
         HpJsV21CptEJQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Kelley <mikelley@microsoft.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, kys@microsoft.com,
        haiyangz@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
        jejb@linux.ibm.com, linux-hyperv@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 21/29] scsi: storvsc: Handle BlockSize change in Hyper-V VHD/VHDX file
Date:   Sun, 19 Mar 2023 20:54:03 -0400
Message-Id: <20230320005413.1428452-21-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230320005413.1428452-1-sashal@kernel.org>
References: <20230320005413.1428452-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Kelley <mikelley@microsoft.com>

[ Upstream commit 11d9874c4204a785f43d899a1ab12f9dc8d9de3e ]

Hyper-V uses a VHD or VHDX file on the host as the underlying storage for a
virtual disk.  The VHD/VHDX file format is a sparse format where real disk
space on the host is assigned in chunks that the VHD/VHDX file format calls
the BlockSize.  This BlockSize is not to be confused with the 512-byte (or
4096-byte) sector size of the underlying storage device.  The default block
size for a new VHD/VHDX file is 32 Mbytes.  When a guest VM touches any
disk space within a 32 Mbyte chunk of the VHD/VHDX file, Hyper-V allocates
32 Mbytes of real disk space for that section of the VHD/VHDX. Similarly,
if a discard operation is done that covers an entire 32 Mbyte chunk,
Hyper-V will free the real disk space for that portion of the VHD/VHDX.
This BlockSize is surfaced in Linux as the "discard_granularity" in
/sys/block/sd<x>/queue, which makes sense.

Hyper-V also has differencing disks that can overlay a VHD/VHDX file to
capture changes to the VHD/VHDX while preserving the original VHD/VHDX.
One example of this differencing functionality is for VM snapshots.  When a
snapshot is created, a differencing disk is created.  If the snapshot is
rolled back, Hyper-V can just delete the differencing disk, and the VM will
see the original disk contents at the time the snapshot was taken.
Differencing disks are used in other scenarios as well.

The BlockSize for a differencing disk defaults to 2 Mbytes, not 32 Mbytes.
The smaller default is used because changes to differencing disks are
typically scattered all over, and Hyper-V doesn't want to allocate 32
Mbytes of real disk space for a stray write here or there.  The smaller
BlockSize provides more efficient use of real disk space.

When a differencing disk is added to a VHD/VHDX, Hyper-V reports
UNIT_ATTENTION with a sense code indicating "Operating parameters have
changed", because the value of discard_granularity should be changed to 2
Mbytes. When the differencing disk is removed, discard_granularity should
be changed back to 32 Mbytes.  However, current code simply reports a
message from scsi_report_sense() and the value of
/sys/block/sd<x>/queue/discard_granularity is not updated. The message
isn't very actionable by a sysadmin.

Fix this by having the storvsc driver check for the sense code indicating
that the underly VHD/VHDX block size has changed, and do a rescan of the
device to pick up the new discard_granularity.  With this change the entire
transition to/from differencing disks is handled automatically and
transparently, with no confusing messages being output.

Link: https://lore.kernel.org/r/1677516514-86060-1-git-send-email-mikelley@microsoft.com
Signed-off-by: Michael Kelley <mikelley@microsoft.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/storvsc_drv.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 55d6fb4526804..a0665bca54b99 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -987,6 +987,22 @@ static void storvsc_handle_error(struct vmscsi_request *vm_srb,
 				goto do_work;
 			}
 
+			/*
+			 * Check for "Operating parameters have changed"
+			 * due to Hyper-V changing the VHD/VHDX BlockSize
+			 * when adding/removing a differencing disk. This
+			 * causes discard_granularity to change, so do a
+			 * rescan to pick up the new granularity. We don't
+			 * want scsi_report_sense() to output a message
+			 * that a sysadmin wouldn't know what to do with.
+			 */
+			if ((asc == 0x3f) && (ascq != 0x03) &&
+					(ascq != 0x0e)) {
+				process_err_fn = storvsc_device_scan;
+				set_host_byte(scmnd, DID_REQUEUE);
+				goto do_work;
+			}
+
 			/*
 			 * Otherwise, let upper layer deal with the
 			 * error when sense message is present
-- 
2.39.2

