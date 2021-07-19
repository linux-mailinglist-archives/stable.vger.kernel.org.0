Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 005E33CDF71
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345177AbhGSPKZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:10:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:39392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344079AbhGSPIC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:08:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A30A611CE;
        Mon, 19 Jul 2021 15:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709688;
        bh=JPtE6/POe2kzDiNAsnf2rJwrMZwZuBqlLA51f9qPsE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LegfUH5gZYqI9JspuHCQyqIWLhQ0N6Ts/+CVJtlqbDo4LgoPc2ZLeJwA1DzLn3VCP
         W1y0lK/wBYgo6sMvUmLE9QMx5QN4h6RThP5jgkMoFU41odkDLp6ZgVW+Q4ajeeAW3Z
         1Ri7zGA3xphxT9BJjru6UUOOeNElf7Vl+3rCrYM8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 025/149] scsi: scsi_dh_alua: Check for negative result value
Date:   Mon, 19 Jul 2021 16:52:13 +0200
Message-Id: <20210719144907.539925320@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144901.370365147@linuxfoundation.org>
References: <20210719144901.370365147@linuxfoundation.org>
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



