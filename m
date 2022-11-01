Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8F996148CA
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 12:29:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbiKAL3t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 07:29:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230311AbiKAL3R (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 07:29:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B3BC6247;
        Tue,  1 Nov 2022 04:28:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CBDED6152E;
        Tue,  1 Nov 2022 11:28:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47EC0C433C1;
        Tue,  1 Nov 2022 11:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667302114;
        bh=/d4XatDkBeJiW0pJ2RZNoRT5620x04FZ8zQKk8rwHLw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QwGnQIGjaEWhVBYrsvHeTI21Bq3tcUVmGvrBsKB2tPmDAu+KbRzQ7DeBWBHXEv9d5
         u8gEBcciJR7Nm+Uli4YEbHaJvmLouGz69B6ZeWjs0Hvnc9KzywUbk8f2aMTTzk4iOT
         7UGBvmEBaCwAM6o368zE4cT78JOb1jnkxkWyrVgDfyqfQjmHvjrUsgzVucMW3+GtCU
         yo17VuzX87Bv7qeV10fUe/f5mK7QZenNcFeAuEEMix1CrSP/jVr7I2+89qMn818X0q
         RfzvjpemyQnCZDN/zI0LUXVQ/8vz5UiIT4CJNKPsdi4xGy9Sz/OPedLInv2kXFpfJM
         2i03YVqRpX8mg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Uday Shankar <ushankar@purestorage.com>,
        Mike Christie <michael.christie@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 24/34] scsi: core: Restrict legal sdev_state transitions via sysfs
Date:   Tue,  1 Nov 2022 07:27:16 -0400
Message-Id: <20221101112726.799368-24-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221101112726.799368-1-sashal@kernel.org>
References: <20221101112726.799368-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uday Shankar <ushankar@purestorage.com>

[ Upstream commit 2331ce6126be8864b39490e705286b66e2344aac ]

Userspace can currently write to sysfs to transition sdev_state to RUNNING
or OFFLINE from any source state. This causes issues because proper
transitioning out of some states involves steps besides just changing
sdev_state, so allowing userspace to change sdev_state regardless of the
source state can result in inconsistencies; e.g. with ISCSI we can end up
with sdev_state == SDEV_RUNNING while the device queue is quiesced. Any
task attempting I/O on the device will then hang, and in more recent
kernels, iscsid will hang as well.

More detail about this bug is provided in my first attempt:

https://groups.google.com/g/open-iscsi/c/PNKca4HgPDs/m/CXaDkntOAQAJ

Link: https://lore.kernel.org/r/20220924000241.2967323-1-ushankar@purestorage.com
Signed-off-by: Uday Shankar <ushankar@purestorage.com>
Suggested-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_sysfs.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 5d61f58399dc..dc41d7c6b9b1 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -828,6 +828,14 @@ store_state_field(struct device *dev, struct device_attribute *attr,
 	}
 
 	mutex_lock(&sdev->state_mutex);
+	switch (sdev->sdev_state) {
+	case SDEV_RUNNING:
+	case SDEV_OFFLINE:
+		break;
+	default:
+		mutex_unlock(&sdev->state_mutex);
+		return -EINVAL;
+	}
 	if (sdev->sdev_state == SDEV_RUNNING && state == SDEV_RUNNING) {
 		ret = 0;
 	} else {
-- 
2.35.1

