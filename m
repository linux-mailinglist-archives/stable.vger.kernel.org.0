Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11F035CB7F
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbfGBIGp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:06:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:53580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727312AbfGBIGo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:06:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1AA021841;
        Tue,  2 Jul 2019 08:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562054803;
        bh=JZqU6SbEu1G9od63bFj+X/LVOZySTd08frXzcfvf4FI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OLyOaz1cD6EwDAXKwK4WTnNRu59O2W6sMVnRsBfAyNb1xdsBHuEKR7kepUrO0VsH0
         xwO4uby8YthkB+qhI3CK2dEci8tzxjk2Qkn0hgf2m7thcbtb1yijrRz8K4f7JjoBCZ
         +vllvZ9YZ9LhR4x4vmfP+4ypyO9nmcgSf5EK/yZU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        "Ewan D. Milne" <emilne@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.19 40/72] scsi: vmw_pscsi: Fix use-after-free in pvscsi_queue_lck()
Date:   Tue,  2 Jul 2019 10:01:41 +0200
Message-Id: <20190702080126.741089345@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190702080124.564652899@linuxfoundation.org>
References: <20190702080124.564652899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit 240b4cc8fd5db138b675297d4226ec46594d9b3b upstream.

Once we unlock adapter->hw_lock in pvscsi_queue_lck() nothing prevents just
queued scsi_cmnd from completing and freeing the request. Thus cmd->cmnd[0]
dereference can dereference already freed request leading to kernel crashes
or other issues (which one of our customers observed). Store cmd->cmnd[0]
in a local variable before unlocking adapter->hw_lock to fix the issue.

CC: <stable@vger.kernel.org>
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ewan D. Milne <emilne@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/vmw_pvscsi.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -763,6 +763,7 @@ static int pvscsi_queue_lck(struct scsi_
 	struct pvscsi_adapter *adapter = shost_priv(host);
 	struct pvscsi_ctx *ctx;
 	unsigned long flags;
+	unsigned char op;
 
 	spin_lock_irqsave(&adapter->hw_lock, flags);
 
@@ -775,13 +776,14 @@ static int pvscsi_queue_lck(struct scsi_
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


