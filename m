Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98205F55F1
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:03:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733257AbfKHTFt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:05:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:35914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731327AbfKHTFp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:05:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFB6D21D7E;
        Fri,  8 Nov 2019 19:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239944;
        bh=Qfqa6yRrhyTXSFO5ETjDNoD+V/lIzLAXs4pkg67v5dg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sPxvfFtlXVkDwosMAGlXFUB7Eb1Cx61DLYREaodwoUo24CFRZaIjBzuqxSh6TcFxH
         DGzcqhMOQxPv+bQogPRpnbu+qisGMENprn+T2JlhQEmVKH6YsOuGqpsf6zgnGMPxac
         BmkPjOPXdGZ1ww+zWURGZrN7jeau2bfix+tUhiuY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Laurence Oberman <loberman@redhat.com>,
        "Ewan D. Milne" <emilne@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 036/140] scsi: scsi_dh_alua: handle RTPG sense code correctly during state transitions
Date:   Fri,  8 Nov 2019 19:49:24 +0100
Message-Id: <20191108174907.153596857@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174900.189064908@linuxfoundation.org>
References: <20191108174900.189064908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hannes Reinecke <hare@suse.com>

[ Upstream commit b6ce6fb121a655aefe41dccc077141c102145a37 ]

Some arrays are not capable of returning RTPG data during state
transitioning, but rather return an 'LUN not accessible, asymmetric access
state transition' sense code. In these cases we can set the state to
'transitioning' directly and don't need to evaluate the RTPG data (which we
won't have anyway).

Link: https://lore.kernel.org/r/20191007135701.32389-1-hare@suse.de
Reviewed-by: Laurence Oberman <loberman@redhat.com>
Reviewed-by: Ewan D. Milne <emilne@redhat.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Hannes Reinecke <hare@suse.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 4971104b1817b..f32da0ca529e0 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -512,6 +512,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 	unsigned int tpg_desc_tbl_off;
 	unsigned char orig_transition_tmo;
 	unsigned long flags;
+	bool transitioning_sense = false;
 
 	if (!pg->expiry) {
 		unsigned long transition_tmo = ALUA_FAILOVER_TIMEOUT * HZ;
@@ -572,13 +573,19 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 			goto retry;
 		}
 		/*
-		 * Retry on ALUA state transition or if any
-		 * UNIT ATTENTION occurred.
+		 * If the array returns with 'ALUA state transition'
+		 * sense code here it cannot return RTPG data during
+		 * transition. So set the state to 'transitioning' directly.
 		 */
 		if (sense_hdr.sense_key == NOT_READY &&
-		    sense_hdr.asc == 0x04 && sense_hdr.ascq == 0x0a)
-			err = SCSI_DH_RETRY;
-		else if (sense_hdr.sense_key == UNIT_ATTENTION)
+		    sense_hdr.asc == 0x04 && sense_hdr.ascq == 0x0a) {
+			transitioning_sense = true;
+			goto skip_rtpg;
+		}
+		/*
+		 * Retry on any other UNIT ATTENTION occurred.
+		 */
+		if (sense_hdr.sense_key == UNIT_ATTENTION)
 			err = SCSI_DH_RETRY;
 		if (err == SCSI_DH_RETRY &&
 		    pg->expiry != 0 && time_before(jiffies, pg->expiry)) {
@@ -666,7 +673,11 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 		off = 8 + (desc[7] * 4);
 	}
 
+ skip_rtpg:
 	spin_lock_irqsave(&pg->lock, flags);
+	if (transitioning_sense)
+		pg->state = SCSI_ACCESS_STATE_TRANSITIONING;
+
 	sdev_printk(KERN_INFO, sdev,
 		    "%s: port group %02x state %c %s supports %c%c%c%c%c%c%c\n",
 		    ALUA_DH_NAME, pg->group_id, print_alua_state(pg->state),
-- 
2.20.1



