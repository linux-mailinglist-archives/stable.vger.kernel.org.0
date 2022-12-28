Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEBD86578A5
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:53:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233186AbiL1OxJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:53:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232989AbiL1Owh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:52:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D2EC1006D
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:52:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B26BCB8171C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:52:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D28FC433EF;
        Wed, 28 Dec 2022 14:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239153;
        bh=4RnHyQ7viJQ/hDh+fOipsTFvnYoh5Lry5TB6k2A76fg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h8xAxzFHfZmhwPCn8DEuqifWq/99JtuAp+eQ/Tx8PuWt++noDJeVboJokx+szn10E
         rbxTLyUeNClZIrBXf4zJJ87mWb2IuFnJNc2SwYN8tuzx9Lz4ahn4byYvSTOViHQAYY
         ORC6qryoxdtHoDdbdPHix2PrI+ZnHGmPnhg6tx8o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Niklas Cassel <niklas.cassel@wdc.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 149/731] ata: libata: fix NCQ autosense logic
Date:   Wed, 28 Dec 2022 15:34:16 +0100
Message-Id: <20221228144300.873691972@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

[ Upstream commit 7390896b3484d44cbdb8bc4859964314ac66d3c9 ]

Currently, the logic if we should call ata_scsi_set_sense()
(and set flag ATA_QCFLAG_SENSE_VALID to indicate that we have
successfully added sense data to the struct ata_queued_cmd)
looks like this:

if (dev->class == ATA_DEV_ZAC &&
    ((qc->result_tf.status & ATA_SENSE) || qc->result_tf.auxiliary))

The problem with this is that a drive can support the NCQ command
error log without supporting NCQ autosense.

On such a drive, if the failing command has sense data, the status
field in the NCQ command error log will have the ATA_SENSE bit set.

It is just that this sense data is not included in the NCQ command
error log when NCQ autosense is not supported. Instead the sense
data has to be fetched using the REQUEST SENSE DATA EXT command.

Therefore, we should only add the sense data if the drive supports
NCQ autosense AND the ATA_SENSE bit is set in the status field.

Fix this, and at the same time, remove the duplicated ATA_DEV_ZAC
check. The struct ata_taskfile supplied to ata_eh_read_log_10h()
is memset:ed before calling the function, so simply checking if
qc->result_tf.auxiliary is set is sufficient to tell us that the
log actually contained sense data.

Fixes: d238ffd59d3c ("libata: do not attempt to retrieve sense code twice")
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-sata.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
index 1e59e5b6b047..b5aa525d8760 100644
--- a/drivers/ata/libata-sata.c
+++ b/drivers/ata/libata-sata.c
@@ -1413,7 +1413,8 @@ static int ata_eh_read_log_10h(struct ata_device *dev,
 	tf->hob_lbah = buf[10];
 	tf->nsect = buf[12];
 	tf->hob_nsect = buf[13];
-	if (dev->class == ATA_DEV_ZAC && ata_id_has_ncq_autosense(dev->id))
+	if (dev->class == ATA_DEV_ZAC && ata_id_has_ncq_autosense(dev->id) &&
+	    (tf->status & ATA_SENSE))
 		tf->auxiliary = buf[14] << 16 | buf[15] << 8 | buf[16];
 
 	return 0;
@@ -1477,8 +1478,12 @@ void ata_eh_analyze_ncq_error(struct ata_link *link)
 	memcpy(&qc->result_tf, &tf, sizeof(tf));
 	qc->result_tf.flags = ATA_TFLAG_ISADDR | ATA_TFLAG_LBA | ATA_TFLAG_LBA48;
 	qc->err_mask |= AC_ERR_DEV | AC_ERR_NCQ;
-	if (dev->class == ATA_DEV_ZAC &&
-	    ((qc->result_tf.status & ATA_SENSE) || qc->result_tf.auxiliary)) {
+
+	/*
+	 * If the device supports NCQ autosense, ata_eh_read_log_10h() will have
+	 * stored the sense data in qc->result_tf.auxiliary.
+	 */
+	if (qc->result_tf.auxiliary) {
 		char sense_key, asc, ascq;
 
 		sense_key = (qc->result_tf.auxiliary >> 16) & 0xff;
-- 
2.35.1



