Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D82C1A5AAC
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728172AbgDKXFx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:05:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:40620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728162AbgDKXFx (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:05:53 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ABFC920CC7;
        Sat, 11 Apr 2020 23:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646353;
        bh=uNaYKRqofACkx4pbgLvm7Di+W4B87DTqrRdNFyHkkVE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d2mxoqOgGUHgfEoKAsHzGOfvImatIY3DJKlfRI9mqSTDZLnZTl8ZMc+PvMZwZYLcs
         zi1l1MhENh+ThgOPLLq7kUL3PEgsC6WXgDsdb90oXaORUZvx3t+27Ra6RgD08XXaqA
         AlGkrqQGl0Cey5StUDLFqYHdh1ejJEx+wzrNrSiQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Ewan D. Milne" <emilne@redhat.com>,
        Bart van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 100/149] scsi: core: avoid repetitive logging of device offline messages
Date:   Sat, 11 Apr 2020 19:02:57 -0400
Message-Id: <20200411230347.22371-100-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230347.22371-1-sashal@kernel.org>
References: <20200411230347.22371-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Ewan D. Milne" <emilne@redhat.com>

[ Upstream commit b0962c53bde9a485c8ebc401fa1dbe821a76bc3e ]

Large queues of I/O to offline devices that are eventually submitted when
devices are unblocked result in a many repeated "rejecting I/O to offline
device" messages.  These messages can fill up the dmesg buffer in crash
dumps so no useful prior messages remain.  In addition, if a serial console
is used, the flood of messages can cause a hard lockup in the console code.

Introduce a flag indicating the message has already been logged for the
device, and reset the flag when scsi_device_set_state() changes the device
state.

Link: https://lore.kernel.org/r/20200311143930.20674-1-emilne@redhat.com
Reviewed-by: Bart van Assche <bvanassche@acm.org>
Signed-off-by: Ewan D. Milne <emilne@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_lib.c    | 8 ++++++--
 include/scsi/scsi_device.h | 3 +++
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 610ee41fa54cb..a45e7289dbbe7 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1240,8 +1240,11 @@ scsi_prep_state_check(struct scsi_device *sdev, struct request *req)
 		 * commands.  The device must be brought online
 		 * before trying any recovery commands.
 		 */
-		sdev_printk(KERN_ERR, sdev,
-			    "rejecting I/O to offline device\n");
+		if (!sdev->offline_already) {
+			sdev->offline_already = true;
+			sdev_printk(KERN_ERR, sdev,
+				    "rejecting I/O to offline device\n");
+		}
 		return BLK_STS_IOERR;
 	case SDEV_DEL:
 		/*
@@ -2340,6 +2343,7 @@ scsi_device_set_state(struct scsi_device *sdev, enum scsi_device_state state)
 		break;
 
 	}
+	sdev->offline_already = false;
 	sdev->sdev_state = state;
 	return 0;
 
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index f8312a3e5b429..cd9656ff3c43c 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -204,6 +204,9 @@ struct scsi_device {
 	unsigned unmap_limit_for_ws:1;	/* Use the UNMAP limit for WRITE SAME */
 	unsigned rpm_autosuspend:1;	/* Enable runtime autosuspend at device
 					 * creation time */
+
+	bool offline_already;		/* Device offline message logged */
+
 	atomic_t disk_events_disable_depth; /* disable depth for disk events */
 
 	DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /* supported events */
-- 
2.20.1

