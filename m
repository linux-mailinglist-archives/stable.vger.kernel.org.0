Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3DD311391
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 22:30:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233209AbhBEV32 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 16:29:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:45584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233022AbhBEPAA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 10:00:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 980ED65088;
        Fri,  5 Feb 2021 14:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534414;
        bh=4mAGzt8SMD3xxAtecVsAfDHrwVvoKRI1L4dboU5xSFo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EFNBI1/phDFiCuVXH1fPBKjRgXzlIDh2hhrVElCzzi5LEo4c06y++z8F9U1d3uP8r
         21zYTc+Rs6TGaIDkKeljdZ5wIrtESMT8kqkvPdJNZNX5C0Lsg+DZbPj/VLnS0NwS6M
         7Gm0gG0k/waZ4FNRo8wlGiEXEuli0ePTkgUmE1mU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Martin Wilck <mwilck@suse.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 10/17] scsi: scsi_transport_srp: Dont block target in failfast state
Date:   Fri,  5 Feb 2021 15:08:04 +0100
Message-Id: <20210205140650.226664240@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140649.825180779@linuxfoundation.org>
References: <20210205140649.825180779@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

[ Upstream commit 72eeb7c7151302ef007f1acd018cbf6f30e50321 ]

If the port is in SRP_RPORT_FAIL_FAST state when srp_reconnect_rport() is
entered, a transition to SDEV_BLOCK would be illegal, and a kernel WARNING
would be triggered. Skip scsi_target_block() in this case.

Link: https://lore.kernel.org/r/20210111142541.21534-1-mwilck@suse.com
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_transport_srp.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index 4e46fdb2d7c99..2aaf1b7103981 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -555,7 +555,14 @@ int srp_reconnect_rport(struct srp_rport *rport)
 	res = mutex_lock_interruptible(&rport->mutex);
 	if (res)
 		goto out;
-	scsi_target_block(&shost->shost_gendev);
+	if (rport->state != SRP_RPORT_FAIL_FAST)
+		/*
+		 * sdev state must be SDEV_TRANSPORT_OFFLINE, transition
+		 * to SDEV_BLOCK is illegal. Calling scsi_target_unblock()
+		 * later is ok though, scsi_internal_device_unblock_nowait()
+		 * treats SDEV_TRANSPORT_OFFLINE like SDEV_BLOCK.
+		 */
+		scsi_target_block(&shost->shost_gendev);
 	res = rport->state != SRP_RPORT_LOST ? i->f->reconnect(rport) : -ENODEV;
 	pr_debug("%s (state %d): transport.reconnect() returned %d\n",
 		 dev_name(&shost->shost_gendev), rport->state, res);
-- 
2.27.0



