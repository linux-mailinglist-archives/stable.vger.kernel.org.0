Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6F4106B85
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:45:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729416AbfKVKpG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:45:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:51294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728325AbfKVKpG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:45:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EAE1720656;
        Fri, 22 Nov 2019 10:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419505;
        bh=ht9seQUWdx8eONxgqfbYtB6UPmAj53mK765ewWByYfQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u6gkhruoVYXvYNz5YaDm1vJlxedtd2ea8fhmoVRx4foutvl5C6KHbHQAhCZP/0KpI
         uDQ7lA/4Ggpwd8DmJnevsW4QsddjJUZpezBjBbHtIAmHO+9z6GN0ofDbIcVFbUkODi
         GPmVfuBYh9+Vtm0B+brw73tfXP9LvzNj02TbkQSk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 135/222] scsi: NCR5380: Use DRIVER_SENSE to indicate valid sense data
Date:   Fri, 22 Nov 2019 11:27:55 +0100
Message-Id: <20191122100912.665562759@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100830.874290814@linuxfoundation.org>
References: <20191122100830.874290814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Finn Thain <fthain@telegraphics.com.au>

[ Upstream commit 070356513963be6196142acff56acc8359069fa1 ]

When sense data is valid, call set_driver_byte(cmd, DRIVER_SENSE).  Otherwise
some callers of scsi_execute() will ignore sense data.  Don't set DID_ERROR or
DID_RESET just because sense data is missing.

Tested-by: Michael Schmitz <schmitzmic@gmail.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/NCR5380.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index ba7b3aef3ef0b..35419ba32c467 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -617,11 +617,12 @@ static void complete_cmd(struct Scsi_Host *instance,
 
 	if (hostdata->sensing == cmd) {
 		/* Autosense processing ends here */
-		if ((cmd->result & 0xff) != SAM_STAT_GOOD) {
+		if (status_byte(cmd->result) != GOOD) {
 			scsi_eh_restore_cmnd(cmd, &hostdata->ses);
-			set_host_byte(cmd, DID_ERROR);
-		} else
+		} else {
 			scsi_eh_restore_cmnd(cmd, &hostdata->ses);
+			set_driver_byte(cmd, DRIVER_SENSE);
+		}
 		hostdata->sensing = NULL;
 	}
 
@@ -2356,7 +2357,6 @@ static int NCR5380_abort(struct scsi_cmnd *cmd)
 	if (list_del_cmd(&hostdata->autosense, cmd)) {
 		dsprintk(NDEBUG_ABORT, instance,
 		         "abort: removed %p from sense queue\n", cmd);
-		set_host_byte(cmd, DID_ERROR);
 		complete_cmd(instance, cmd);
 	}
 
@@ -2435,7 +2435,6 @@ static int NCR5380_bus_reset(struct scsi_cmnd *cmd)
 	list_for_each_entry(ncmd, &hostdata->autosense, list) {
 		struct scsi_cmnd *cmd = NCR5380_to_scmd(ncmd);
 
-		set_host_byte(cmd, DID_RESET);
 		cmd->scsi_done(cmd);
 	}
 	INIT_LIST_HEAD(&hostdata->autosense);
-- 
2.20.1



