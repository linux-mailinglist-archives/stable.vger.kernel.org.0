Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 188A235CCC2
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 18:33:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244502AbhDLQbI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 12:31:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:57952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244757AbhDLQ2b (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 12:28:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7A6B61386;
        Mon, 12 Apr 2021 16:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244725;
        bh=w/7ZgrcLtUN+GLnCtcO4qAVoGY+iTarrLP44Ws6/1lM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E1trD7lOu+ckHwPw0TYrKHwyJtKNpY+BD0OZugFiwnUK+l6e0f2Wzx29e2OJAy+ns
         t+h59tlGD5bXKMzryUWD2nP/mSQVYiZTHuDe4SpONErgGSb3G2hVbs/oRCZGWc35iA
         dI73SfXtEVP6eq3abSjtWA0LHBNPJxNuM9dj/COz2tBQkyqt/dKjTaYTUvad6wm/Lh
         cVH1RGsgQAjqITmucM9Aas57Vrsi0MyzAExXM184+EriN+mi+pQxZWE4HaJwsfanaq
         4J/ukRM4WmzIDRv3dF4zjM45P+nUiWVhH0DMkCoqJ2ukoV6GDQPruvETeM+iJIKukS
         DhAVi/ms8aKIA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Martin Wilck <mwilck@suse.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 18/39] scsi: scsi_transport_srp: Don't block target in SRP_PORT_LOST state
Date:   Mon, 12 Apr 2021 12:24:40 -0400
Message-Id: <20210412162502.314854-18-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162502.314854-1-sashal@kernel.org>
References: <20210412162502.314854-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

[ Upstream commit 5cd0f6f57639c5afbb36100c69281fee82c95ee7 ]

rport_dev_loss_timedout() sets the rport state to SRP_PORT_LOST and the
SCSI target state to SDEV_TRANSPORT_OFFLINE. If this races with
srp_reconnect_work(), a warning is printed:

Mar 27 18:48:07 ictm1604s01h4 kernel: dev_loss_tmo expired for SRP port-18:1 / host18.
Mar 27 18:48:07 ictm1604s01h4 kernel: ------------[ cut here ]------------
Mar 27 18:48:07 ictm1604s01h4 kernel: scsi_internal_device_block(18:0:0:100) failed: ret = -22
Mar 27 18:48:07 ictm1604s01h4 kernel: Call Trace:
Mar 27 18:48:07 ictm1604s01h4 kernel:  ? scsi_target_unblock+0x50/0x50 [scsi_mod]
Mar 27 18:48:07 ictm1604s01h4 kernel:  starget_for_each_device+0x80/0xb0 [scsi_mod]
Mar 27 18:48:07 ictm1604s01h4 kernel:  target_block+0x24/0x30 [scsi_mod]
Mar 27 18:48:07 ictm1604s01h4 kernel:  device_for_each_child+0x57/0x90
Mar 27 18:48:07 ictm1604s01h4 kernel:  srp_reconnect_rport+0xe4/0x230 [scsi_transport_srp]
Mar 27 18:48:07 ictm1604s01h4 kernel:  srp_reconnect_work+0x40/0xc0 [scsi_transport_srp]

Avoid this by not trying to block targets for rports in SRP_PORT_LOST
state.

Link: https://lore.kernel.org/r/20210401091105.8046-1-mwilck@suse.com
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_transport_srp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index 8cd0a87764df..9fee851c23a5 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -541,7 +541,7 @@ int srp_reconnect_rport(struct srp_rport *rport)
 	res = mutex_lock_interruptible(&rport->mutex);
 	if (res)
 		goto out;
-	if (rport->state != SRP_RPORT_FAIL_FAST)
+	if (rport->state != SRP_RPORT_FAIL_FAST && rport->state != SRP_RPORT_LOST)
 		/*
 		 * sdev state must be SDEV_TRANSPORT_OFFLINE, transition
 		 * to SDEV_BLOCK is illegal. Calling scsi_target_unblock()
-- 
2.30.2

