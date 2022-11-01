Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE4E2614916
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 12:32:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230481AbiKALch (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 07:32:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230405AbiKALbU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 07:31:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 787F91AF18;
        Tue,  1 Nov 2022 04:29:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F642615C9;
        Tue,  1 Nov 2022 11:29:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 073E5C433C1;
        Tue,  1 Nov 2022 11:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667302196;
        bh=USvHquiFgiGFjM0GueEZoVxriggjzHuSZ+R9lifCgAs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JEB1T0vqmUHgQr25VCGigz9sZypwcFhAVX37cb68ezyvH9RV1PRJDz3/UddlYFtXA
         yLGH04Fphei+pMV/SevgDFvppRxprgnKP3n98BhWX4I3b0cwkUDCzamV8JAL4X4mk+
         VlDRELQqfv0gOKmOQ/xqMH+pdwzd+FFxAK9amkz8+lFZicyJiSjwIsJxfYvgi4BwTT
         8fHDENw/YiPoWTQF7ukh5Sfq3vhRD7DiLMj5SolHRMM1u4nsW4Brc7xQaumxR000jw
         ow32810GG22ub50Is17aXRG9b8Re7pEq3nuLI8HJv8VeXyJPb+Mwd+GVUU6pdYdGH5
         QsJUeRmZg+FdA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Uday Shankar <ushankar@purestorage.com>,
        Mike Christie <michael.christie@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 15/19] scsi: core: Restrict legal sdev_state transitions via sysfs
Date:   Tue,  1 Nov 2022 07:29:15 -0400
Message-Id: <20221101112919.799868-15-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221101112919.799868-1-sashal@kernel.org>
References: <20221101112919.799868-1-sashal@kernel.org>
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
index 920aae661c5b..774864b54b97 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -816,6 +816,14 @@ store_state_field(struct device *dev, struct device_attribute *attr,
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

