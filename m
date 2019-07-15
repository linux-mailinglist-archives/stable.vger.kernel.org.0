Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67F19690DF
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 16:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390592AbfGOOYu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 10:24:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:58924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389194AbfGOOYs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 10:24:48 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FF03206B8;
        Mon, 15 Jul 2019 14:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563200687;
        bh=8s3X9WnmeY9lBH5UMn2VH75GC+6YVNlNSOuroe1wUdM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EULfYBq5XLkfS4qcXrnKNELsKmqMXJWqNzskbkHBJs+1UwXosTPP0kk/97ittikj4
         OTAl6gE+PyZioYNRP/KbiyuddrZJp+5WTu+WexOjY4QA5samOUQpyLBop0DSCo+5FL
         bHPcWzWfEsoDzlxh1/6pQz2+EclgLrbooYGAsGe4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tejun Heo <tj@kernel.org>, Hannes Reinecke <hare@suse.com>,
        Masato Suzuki <masato.suzuki@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-ide@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 112/158] libata: don't request sense data on !ZAC ATA devices
Date:   Mon, 15 Jul 2019 10:17:23 -0400
Message-Id: <20190715141809.8445-112-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715141809.8445-1-sashal@kernel.org>
References: <20190715141809.8445-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

[ Upstream commit ca156e006add67e4beea7896be395160735e09b0 ]

ZAC support added sense data requesting on error for both ZAC and ATA
devices. This seems to cause erratic error handling behaviors on some
SSDs where the device reports sense data availability and then
delivers the wrong content making EH take the wrong actions.  The
failure mode was sporadic on a LITE-ON ssd and couldn't be reliably
reproduced.

There is no value in requesting sense data from non-ZAC ATA devices
while there's a significant risk of introducing EH misbehaviors which
are difficult to reproduce and fix.  Let's do the sense data dancing
only for ZAC devices.

Reviewed-by: Hannes Reinecke <hare@suse.com>
Tested-by: Masato Suzuki <masato.suzuki@wdc.com>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-eh.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 01306c018398..ccc80ff57eb2 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -1490,7 +1490,7 @@ static int ata_eh_read_log_10h(struct ata_device *dev,
 	tf->hob_lbah = buf[10];
 	tf->nsect = buf[12];
 	tf->hob_nsect = buf[13];
-	if (ata_id_has_ncq_autosense(dev->id))
+	if (dev->class == ATA_DEV_ZAC && ata_id_has_ncq_autosense(dev->id))
 		tf->auxiliary = buf[14] << 16 | buf[15] << 8 | buf[16];
 
 	return 0;
@@ -1737,7 +1737,8 @@ void ata_eh_analyze_ncq_error(struct ata_link *link)
 	memcpy(&qc->result_tf, &tf, sizeof(tf));
 	qc->result_tf.flags = ATA_TFLAG_ISADDR | ATA_TFLAG_LBA | ATA_TFLAG_LBA48;
 	qc->err_mask |= AC_ERR_DEV | AC_ERR_NCQ;
-	if ((qc->result_tf.command & ATA_SENSE) || qc->result_tf.auxiliary) {
+	if (dev->class == ATA_DEV_ZAC &&
+	    ((qc->result_tf.command & ATA_SENSE) || qc->result_tf.auxiliary)) {
 		char sense_key, asc, ascq;
 
 		sense_key = (qc->result_tf.auxiliary >> 16) & 0xff;
@@ -1791,10 +1792,11 @@ static unsigned int ata_eh_analyze_tf(struct ata_queued_cmd *qc,
 	}
 
 	switch (qc->dev->class) {
-	case ATA_DEV_ATA:
 	case ATA_DEV_ZAC:
 		if (stat & ATA_SENSE)
 			ata_eh_request_sense(qc, qc->scsicmd);
+		/* fall through */
+	case ATA_DEV_ATA:
 		if (err & ATA_ICRC)
 			qc->err_mask |= AC_ERR_ATA_BUS;
 		if (err & (ATA_UNC | ATA_AMNF))
-- 
2.20.1

