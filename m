Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C28EB3CE09C
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345882AbhGSPRi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:17:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:49652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346214AbhGSPOV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:14:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05E796124C;
        Mon, 19 Jul 2021 15:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710042;
        bh=JPtE6/POe2kzDiNAsnf2rJwrMZwZuBqlLA51f9qPsE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O3KGbw+1Ur3SydG3vqz7GTNvYeUZZWZMGFcwWL2SIoapxLOpS5jbiu5Qbfhq/lvPh
         xt6OJfJAd9mm/7bZhDtJfUouwciYKu6bc4VaW9i8/MCPc8m/o/XGD6YQYBKvVzvmdK
         jiwYD9341s6x7n8QwbdvKzbyANKFlB9ifpwYJU3Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 052/243] scsi: scsi_dh_alua: Check for negative result value
Date:   Mon, 19 Jul 2021 16:51:21 +0200
Message-Id: <20210719144942.600835590@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.904087935@linuxfoundation.org>
References: <20210719144940.904087935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

[ Upstream commit 7e26e3ea028740f934477ec01ba586ab033c35aa ]

scsi_execute() will now return a negative error if there was an error prior
to command submission; evaluate that instead if checking for DRIVER_ERROR.

[mkp: build fix]

Link: https://lore.kernel.org/r/20210427083046.31620-6-hare@suse.de
Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index df5a3bbeba5e..4743317a269a 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -548,12 +548,12 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 			kfree(buff);
 			return SCSI_DH_OK;
 		}
-		if (!scsi_sense_valid(&sense_hdr)) {
+		if (retval < 0 || !scsi_sense_valid(&sense_hdr)) {
 			sdev_printk(KERN_INFO, sdev,
 				    "%s: rtpg failed, result %d\n",
 				    ALUA_DH_NAME, retval);
 			kfree(buff);
-			if (driver_byte(retval) == DRIVER_ERROR)
+			if (retval < 0)
 				return SCSI_DH_DEV_TEMP_BUSY;
 			return SCSI_DH_IO;
 		}
@@ -775,11 +775,11 @@ static unsigned alua_stpg(struct scsi_device *sdev, struct alua_port_group *pg)
 	retval = submit_stpg(sdev, pg->group_id, &sense_hdr);
 
 	if (retval) {
-		if (!scsi_sense_valid(&sense_hdr)) {
+		if (retval < 0 || !scsi_sense_valid(&sense_hdr)) {
 			sdev_printk(KERN_INFO, sdev,
 				    "%s: stpg failed, result %d",
 				    ALUA_DH_NAME, retval);
-			if (driver_byte(retval) == DRIVER_ERROR)
+			if (retval < 0)
 				return SCSI_DH_DEV_TEMP_BUSY;
 		} else {
 			sdev_printk(KERN_INFO, sdev, "%s: stpg failed\n",
-- 
2.30.2



