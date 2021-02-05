Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 911B531147A
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 23:07:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232799AbhBEWGv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 17:06:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:44338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232875AbhBEOwM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 09:52:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C3460650AE;
        Fri,  5 Feb 2021 14:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534464;
        bh=S2DSDsfBxEIFeCuQkjbvSspMeWE88P5CXsTx0e9HyBM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aK9ptxdO1bCPGiOhsFVFZI1eTXDcL1qEeu341pJ8E/SsiFUDX7Bp8134/hnxNKEUE
         YgaECJBvBXdUEfQ+70EaAqcyQ6GjE/Z5u8H8jMjfrHn/KrxF7UGIqHv8M6vEuAHfcl
         LXjhoLu/EcnCe9yXhB8A43psS30msbFFdWrWSn/o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Martin Wilck <mwilck@suse.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 10/15] scsi: scsi_transport_srp: Dont block target in failfast state
Date:   Fri,  5 Feb 2021 15:08:55 +0100
Message-Id: <20210205140650.149845604@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140649.733510103@linuxfoundation.org>
References: <20210205140649.733510103@linuxfoundation.org>
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
index 456ce9f19569f..a0e35028ebdac 100644
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



