Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FFC062160
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732398AbfGHPPt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:15:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:38470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732406AbfGHPPs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:15:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 803382166E;
        Mon,  8 Jul 2019 15:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562598948;
        bh=VD+juevNkgfkUrbrh1YefcJUwNtoDjS+2fPAoB0Yji8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k1WBfmN9S/yXiD3E0MHGgxDudgFMfLmUOvr8ZLDyMM7SXMY+N3Qjd5/PQy3Q2Gi1w
         4aTiV7xd06WS9V8mK5UCRzk5xRRO7yobO79GcudVNJg/2vE4sTy2hbZFqOJJjf/Hu4
         d9GBgOqky7icHe5YZTJTOeGZ/KwcpGALw4yDbBM0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        "Ewan D. Milne" <emilne@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.4 03/73] scsi: vmw_pscsi: Fix use-after-free in pvscsi_queue_lck()
Date:   Mon,  8 Jul 2019 17:12:13 +0200
Message-Id: <20190708150517.429031888@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150513.136580595@linuxfoundation.org>
References: <20190708150513.136580595@linuxfoundation.org>
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
@@ -733,6 +733,7 @@ static int pvscsi_queue_lck(struct scsi_
 	struct pvscsi_adapter *adapter = shost_priv(host);
 	struct pvscsi_ctx *ctx;
 	unsigned long flags;
+	unsigned char op;
 
 	spin_lock_irqsave(&adapter->hw_lock, flags);
 
@@ -745,13 +746,14 @@ static int pvscsi_queue_lck(struct scsi_
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


