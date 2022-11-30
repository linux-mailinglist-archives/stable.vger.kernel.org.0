Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83EE163DE09
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:33:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbiK3SdM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:33:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbiK3SdF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:33:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30DAB25C59
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:32:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 45FBEB81C9C
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:32:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 954A2C433C1;
        Wed, 30 Nov 2022 18:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833169;
        bh=b7WBZuhADWnLTsk75huPI9h6dbLNsrX7kEu3QKuNwF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2JrKCwbvg0a46E6orJN4lXmy0/IA3aoiiwGkbwsAaIm8phq3i3V200tDPoN0C7mZe
         k4C0b45gLxSk4V5Twqb59LKT05UWjJ/VNSHNMXxb3Hb9Q+ofYryzoY5WJEI1gKxlGx
         n2WKpC1OFsktsly5hcPPmQasVhi0Yee4u2MPN7mA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wenchao Hao <haowenchao@huawei.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 012/206] ata: libata-scsi: simplify __ata_scsi_queuecmd()
Date:   Wed, 30 Nov 2022 19:21:04 +0100
Message-Id: <20221130180533.308433809@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
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

From: Wenchao Hao <haowenchao@huawei.com>

[ Upstream commit 84eac327af543f03172085d5ef9f98ea25a51191 ]

This patch cleans up the code of __ata_scsi_queuecmd(). Since each
branch of the "if" condition check that scmd->cmd_len is not zero, move
this check out of the "if" to simplify the conditions being checked in
the "else" branch.

While at it, avoid the if-else-if-else structure using if-else if
structure and remove the redundant rc local variable.

This patch does not change the function logic.

Signed-off-by: Wenchao Hao <haowenchao@huawei.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Stable-dep-of: e20e81a24a4d ("ata: libata-core: do not issue non-internal commands once EH is pending")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-scsi.c | 45 ++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 24 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index ef41cb385a0d..61b7e0b0bbf6 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3990,42 +3990,39 @@ int __ata_scsi_queuecmd(struct scsi_cmnd *scmd, struct ata_device *dev)
 {
 	u8 scsi_op = scmd->cmnd[0];
 	ata_xlat_func_t xlat_func;
-	int rc = 0;
+
+	if (unlikely(!scmd->cmd_len))
+		goto bad_cdb_len;
 
 	if (dev->class == ATA_DEV_ATA || dev->class == ATA_DEV_ZAC) {
-		if (unlikely(!scmd->cmd_len || scmd->cmd_len > dev->cdb_len))
+		if (unlikely(scmd->cmd_len > dev->cdb_len))
 			goto bad_cdb_len;
 
 		xlat_func = ata_get_xlat_func(dev, scsi_op);
-	} else {
-		if (unlikely(!scmd->cmd_len))
-			goto bad_cdb_len;
+	} else if (likely((scsi_op != ATA_16) || !atapi_passthru16)) {
+		/* relay SCSI command to ATAPI device */
+		int len = COMMAND_SIZE(scsi_op);
 
-		xlat_func = NULL;
-		if (likely((scsi_op != ATA_16) || !atapi_passthru16)) {
-			/* relay SCSI command to ATAPI device */
-			int len = COMMAND_SIZE(scsi_op);
-			if (unlikely(len > scmd->cmd_len ||
-				     len > dev->cdb_len ||
-				     scmd->cmd_len > ATAPI_CDB_LEN))
-				goto bad_cdb_len;
+		if (unlikely(len > scmd->cmd_len ||
+			     len > dev->cdb_len ||
+			     scmd->cmd_len > ATAPI_CDB_LEN))
+			goto bad_cdb_len;
 
-			xlat_func = atapi_xlat;
-		} else {
-			/* ATA_16 passthru, treat as an ATA command */
-			if (unlikely(scmd->cmd_len > 16))
-				goto bad_cdb_len;
+		xlat_func = atapi_xlat;
+	} else {
+		/* ATA_16 passthru, treat as an ATA command */
+		if (unlikely(scmd->cmd_len > 16))
+			goto bad_cdb_len;
 
-			xlat_func = ata_get_xlat_func(dev, scsi_op);
-		}
+		xlat_func = ata_get_xlat_func(dev, scsi_op);
 	}
 
 	if (xlat_func)
-		rc = ata_scsi_translate(dev, scmd, xlat_func);
-	else
-		ata_scsi_simulate(dev, scmd);
+		return ata_scsi_translate(dev, scmd, xlat_func);
 
-	return rc;
+	ata_scsi_simulate(dev, scmd);
+
+	return 0;
 
  bad_cdb_len:
 	DPRINTK("bad CDB len=%u, scsi_op=0x%02x, max=%u\n",
-- 
2.35.1



