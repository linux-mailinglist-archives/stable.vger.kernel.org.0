Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4A607F429
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 12:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391864AbfHBJm1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:42:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:44808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391861AbfHBJm0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:42:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE60220880;
        Fri,  2 Aug 2019 09:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564738946;
        bh=UBKMMdY8wtmAJ8UB0y/8LOKxsqp+bYD7SFaXTn2tI4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=URAD6rnKlb+uUlF9bastM+WkDGIT+4h78ahdaJBqNXBFvv7AMaBua7TByG6wq9gcP
         xBV7ROftJ3qVen5rbvOgFMkQAt+JKrIGotSoEXs7Jm+c5ASu4saUeyOMpXNASPxQrk
         957up9x4LIZOMUfwz6BhuJoEhrXULZKJbVBvsop8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        Masato Suzuki <masato.suzuki@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 057/223] libata: dont request sense data on !ZAC ATA devices
Date:   Fri,  2 Aug 2019 11:34:42 +0200
Message-Id: <20190802092242.567678227@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092238.692035242@linuxfoundation.org>
References: <20190802092238.692035242@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 90c38778bc1f..16f8fda89981 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -1600,7 +1600,7 @@ static int ata_eh_read_log_10h(struct ata_device *dev,
 	tf->hob_lbah = buf[10];
 	tf->nsect = buf[12];
 	tf->hob_nsect = buf[13];
-	if (ata_id_has_ncq_autosense(dev->id))
+	if (dev->class == ATA_DEV_ZAC && ata_id_has_ncq_autosense(dev->id))
 		tf->auxiliary = buf[14] << 16 | buf[15] << 8 | buf[16];
 
 	return 0;
@@ -1849,7 +1849,8 @@ void ata_eh_analyze_ncq_error(struct ata_link *link)
 	memcpy(&qc->result_tf, &tf, sizeof(tf));
 	qc->result_tf.flags = ATA_TFLAG_ISADDR | ATA_TFLAG_LBA | ATA_TFLAG_LBA48;
 	qc->err_mask |= AC_ERR_DEV | AC_ERR_NCQ;
-	if ((qc->result_tf.command & ATA_SENSE) || qc->result_tf.auxiliary) {
+	if (dev->class == ATA_DEV_ZAC &&
+	    ((qc->result_tf.command & ATA_SENSE) || qc->result_tf.auxiliary)) {
 		char sense_key, asc, ascq;
 
 		sense_key = (qc->result_tf.auxiliary >> 16) & 0xff;
@@ -1903,10 +1904,11 @@ static unsigned int ata_eh_analyze_tf(struct ata_queued_cmd *qc,
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



