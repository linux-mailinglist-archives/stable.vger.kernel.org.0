Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22CEE61495F
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 12:36:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbiKALgs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 07:36:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231327AbiKALgL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 07:36:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A78C1D0E1;
        Tue,  1 Nov 2022 04:31:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F10A7B81CCF;
        Tue,  1 Nov 2022 11:31:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A88D7C433D7;
        Tue,  1 Nov 2022 11:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667302273;
        bh=NpTtqdMNxT1KjmVtp4h6K8oH+flM8cd/rKUZBHfnVow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S12QqJ70l5PVWmP3uWY6UdDPRDI/aTiZoIm/sfjTvx3vHV9uz+jMyCI6Lsr1PQt1L
         9WkuH6q7ke4Br7Bk42ZSKD7EyOsVMR4rSG8gNI4Jorc9rbC/Jfxv47B/WKIC0NSmKE
         uovOrEN0nDGLaw7mHqtLtxyRh0Z4eSgo34dxhSMhCrVycMks/Ti9EDgk6FQyUGwgD4
         bepy/i7fiS1HFRE5nq/jC+6fINCl6kHcccYFtVRjPnEMM8aMplBWeNO3RsrhzEexIO
         0CXHC+UQ3bWjFzYfwx+AZSkod/xWRwnq6uT7THm6d735fqlsb/pfQDcBF+0HkyPWAG
         eIc5mE2yxV48Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Uday Shankar <ushankar@purestorage.com>,
        Mike Christie <michael.christie@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 6/8] scsi: core: Restrict legal sdev_state transitions via sysfs
Date:   Tue,  1 Nov 2022 07:30:55 -0400
Message-Id: <20221101113059.800777-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221101113059.800777-1-sashal@kernel.org>
References: <20221101113059.800777-1-sashal@kernel.org>
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
index 6faf1d6451b0..530b14685fd7 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -795,6 +795,14 @@ store_state_field(struct device *dev, struct device_attribute *attr,
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

