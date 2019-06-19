Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 664CC4B297
	for <lists+stable@lfdr.de>; Wed, 19 Jun 2019 09:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730418AbfFSHFq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jun 2019 03:05:46 -0400
Received: from mx2.suse.de ([195.135.220.15]:33722 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726251AbfFSHFq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Jun 2019 03:05:46 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CA423AB7D;
        Wed, 19 Jun 2019 07:05:44 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 6BC8B1E4329; Wed, 19 Jun 2019 09:05:43 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     Jim Gill <jgill@vmware.com>
Cc:     VMware PV-Drivers <pv-drivers@vmware.com>,
        linux-scsi@vger.kernel.org, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH] scsi: vmw_pscsi: Fix use-after-free in pvscsi_queue_lck()
Date:   Wed, 19 Jun 2019 09:05:41 +0200
Message-Id: <20190619070541.30070-1-jack@suse.cz>
X-Mailer: git-send-email 2.16.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Once we unlock adapter->hw_lock in pvscsi_queue_lck() nothing prevents just
queued scsi_cmnd from completing and freeing the request. Thus cmd->cmnd[0]
dereference can dereference already freed request leading to kernel crashes or
other issues (which one of our customers observed). Store cmd->cmnd[0] in a
local variable before unlocking adapter->hw_lock to fix the issue.

CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 drivers/scsi/vmw_pvscsi.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index ecee4b3ff073..377b07b2feeb 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -763,6 +763,7 @@ static int pvscsi_queue_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd
 	struct pvscsi_adapter *adapter = shost_priv(host);
 	struct pvscsi_ctx *ctx;
 	unsigned long flags;
+	unsigned char op;
 
 	spin_lock_irqsave(&adapter->hw_lock, flags);
 
@@ -775,13 +776,14 @@ static int pvscsi_queue_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd
 	}
 
 	cmd->scsi_done = done;
+	op = cmd->cmnd[0];
 
 	dev_dbg(&cmd->device->sdev_gendev,
-		"queued cmd %p, ctx %p, op=%x\n", cmd, ctx, cmd->cmnd[0]);
+		"queued cmd %p, ctx %p, op=%x\n", cmd, ctx, op);
 
 	spin_unlock_irqrestore(&adapter->hw_lock, flags);
 
-	pvscsi_kick_io(adapter, cmd->cmnd[0]);
+	pvscsi_kick_io(adapter, op);
 
 	return 0;
 }
-- 
2.16.4

