Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2FC446271D
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236657AbhK2XBF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 18:01:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236165AbhK2W7s (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:59:48 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE082C07E5F2;
        Mon, 29 Nov 2021 10:38:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 06FF7CE1685;
        Mon, 29 Nov 2021 18:38:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A86CDC53FAD;
        Mon, 29 Nov 2021 18:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211131;
        bh=tfDEhGLJWKcRsLlx21ULYr9k3HGuuiEko759YVbV8fM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IN7jVMBfyFZSkiEKZiQ8oxJfSivxgQ1T2RhZQF2NXKf3MCXFouVOAYUpN6jFavnrX
         xxrVwWREAE+ekAOTKFLQFkPmm7z1D6eNUGaK+yQXOqxx/WCJfqnnAlYYsduUTfI0RB
         nkN9iRIrzG8/0f177zIWghV8yVHEe8mze+BQswu0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lee Duncan <lduncan@suse.com>,
        Mike Christie <michael.christie@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 115/179] scsi: core: sysfs: Fix setting device state to SDEV_RUNNING
Date:   Mon, 29 Nov 2021 19:18:29 +0100
Message-Id: <20211129181722.743219826@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit eb97545d6264b341b06ba7603f52ff6c0b2af6ea ]

This fixes an issue added in commit 4edd8cd4e86d ("scsi: core: sysfs: Fix
hang when device state is set via sysfs") where if userspace is requesting
to set the device state to SDEV_RUNNING when the state is already
SDEV_RUNNING, we return -EINVAL instead of count. The commmit above set ret
to count for this case, when it should have set it to 0.

Link: https://lore.kernel.org/r/20211120164917.4924-1-michael.christie@oracle.com
Fixes: 4edd8cd4e86d ("scsi: core: sysfs: Fix hang when device state is set via sysfs")
Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 9527e734a999a..920aae661c5b2 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -817,7 +817,7 @@ store_state_field(struct device *dev, struct device_attribute *attr,
 
 	mutex_lock(&sdev->state_mutex);
 	if (sdev->sdev_state == SDEV_RUNNING && state == SDEV_RUNNING) {
-		ret = count;
+		ret = 0;
 	} else {
 		ret = scsi_device_set_state(sdev, state);
 		if (ret == 0 && state == SDEV_RUNNING)
-- 
2.33.0



