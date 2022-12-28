Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28100657BE1
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:27:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233781AbiL1P0w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:26:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233745AbiL1P0R (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:26:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 457A8BA9
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:26:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D72CD6152F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:26:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED352C433EF;
        Wed, 28 Dec 2022 15:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241175;
        bh=yYMALOVS9m0/dT5R4SvMAaRuaKcQbuyAOhleF1HWvAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=msIfY9laqTwaT9mk6om72CtK1cxlNdhyVVd8rvBRT+uL/1QOaKkXbfMdJrAr5ROZW
         UcIetUAZBSP59CwyPLH+RgVboYEQ+gBMUgDt7wojM7PBKbSLcrHm37NlIA2DkToj0g
         eYUOGeuY56X2l9kk4Doibeiku1ozX0DiYYeQkufU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Niklas Cassel <niklas.cassel@wdc.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0215/1146] ata: libata: fix NCQ autosense logic
Date:   Wed, 28 Dec 2022 15:29:14 +0100
Message-Id: <20221228144335.986049071@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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
index b6806d41a8c5..fd4dccc25389 100644
--- a/drivers/ata/libata-sata.c
+++ b/drivers/ata/libata-sata.c
@@ -1392,7 +1392,8 @@ static int ata_eh_read_log_10h(struct ata_device *dev,
 	tf->hob_lbah = buf[10];
 	tf->nsect = buf[12];
 	tf->hob_nsect = buf[13];
-	if (dev->class == ATA_DEV_ZAC && ata_id_has_ncq_autosense(dev->id))
+	if (dev->class == ATA_DEV_ZAC && ata_id_has_ncq_autosense(dev->id) &&
+	    (tf->status & ATA_SENSE))
 		tf->auxiliary = buf[14] << 16 | buf[15] << 8 | buf[16];
 
 	return 0;
@@ -1456,8 +1457,12 @@ void ata_eh_analyze_ncq_error(struct ata_link *link)
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



