Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F04916675BF
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:24:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236421AbjALOYf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:24:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232971AbjALOXp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:23:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FEEA2E3
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:15:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 430E2B81DCC
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:15:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98172C433EF;
        Thu, 12 Jan 2023 14:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532950;
        bh=+f8JVV7K9g5+309A8gnfQkWuvv/j+EhMrnKIfBoA3uQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cLCAz36R6hg19FRD4Sxr8UMfW+ZxQ80roT/0INkJx0rm0mo6GEW2Fz3+QzxS8PKo+
         hDSb1SI8dCNNUE/Nb9eH8L+dFyiwqUmAm9pE1F8+XtiTqRBQPxYJDgVNncocuSzUaA
         iZiynQxpKFCcpKLyBd3SVFnnVvi36MDJaNJLRz0w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 322/783] scsi: scsi_debug: Fix possible name leak in sdebug_add_host_helper()
Date:   Thu, 12 Jan 2023 14:50:38 +0100
Message-Id: <20230112135539.257763209@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit e6d773f93a49e0eda88a903a2a6542ca83380eb1 ]

Afer commit 1fa5ae857bb1 ("driver core: get rid of struct device's bus_id
string array"), the name of device is allocated dynamically, it needs be
freed when device_register() returns error.

As comment of device_register() says, one should use put_device() to give
up the reference in the error path. Fix this by calling put_device(), then
the name can be freed in kobject_cleanup(), and sdbg_host is freed in
sdebug_release_adapter().

When the device release is not set, it means the device is not initialized.
We can not call put_device() in this case. Use kfree() to free memory.

Fixes: 1fa5ae857bb1 ("driver core: get rid of struct device's bus_id string array")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221112131010.3757845-1-yangyingliang@huawei.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_debug.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index bd63357f439d..7cfc6db81763 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -7103,7 +7103,10 @@ static int sdebug_add_host_helper(int per_host_idx)
 		kfree(sdbg_devinfo->zstate);
 		kfree(sdbg_devinfo);
 	}
-	kfree(sdbg_host);
+	if (sdbg_host->dev.release)
+		put_device(&sdbg_host->dev);
+	else
+		kfree(sdbg_host);
 	pr_warn("%s: failed, errno=%d\n", __func__, -error);
 	return error;
 }
-- 
2.35.1



