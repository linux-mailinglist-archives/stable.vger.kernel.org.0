Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA4896BB246
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:35:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232554AbjCOMfA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:35:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232771AbjCOMeh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:34:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B4088A3B2
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:33:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC156B81E00
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:33:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 619C8C4339B;
        Wed, 15 Mar 2023 12:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883585;
        bh=1cjC3qXCoJ/D0JFtMsEmlRTW10pSskonO2tB1MRatQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1c+zZvcKCUbl8Kx5cfzmo8EXYu5i8SU7nsqbq0wA/gfB3keZUIZIozJERydMUOPjB
         MH3+9WX9uB7nuqYBhz3lKFqyrUlr9uC9jlPPZnd/vy22qzD1nCAjmQ0ppu5qnV70DG
         XZSbjv+SDJ7kh7yrZxSHsIm4hzEJOW3+XfKm3kY4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alan Stern <stern@rowland.harvard.edu>,
        Yi Zhang <yi.zhang@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 055/143] scsi: core: Remove the /proc/scsi/${proc_name} directory earlier
Date:   Wed, 15 Mar 2023 13:12:21 +0100
Message-Id: <20230315115742.191968841@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit fc663711b94468f4e1427ebe289c9f05669699c9 ]

Remove the /proc/scsi/${proc_name} directory earlier to fix a race
condition between unloading and reloading kernel modules. This fixes a bug
introduced in 2009 by commit 77c019768f06 ("[SCSI] fix /proc memory leak in
the SCSI core").

Fix the following kernel warning:

proc_dir_entry 'scsi/scsi_debug' already registered
WARNING: CPU: 19 PID: 27986 at fs/proc/generic.c:376 proc_register+0x27d/0x2e0
Call Trace:
 proc_mkdir+0xb5/0xe0
 scsi_proc_hostdir_add+0xb5/0x170
 scsi_host_alloc+0x683/0x6c0
 sdebug_driver_probe+0x6b/0x2d0 [scsi_debug]
 really_probe+0x159/0x540
 __driver_probe_device+0xdc/0x230
 driver_probe_device+0x4f/0x120
 __device_attach_driver+0xef/0x180
 bus_for_each_drv+0xe5/0x130
 __device_attach+0x127/0x290
 device_initial_probe+0x17/0x20
 bus_probe_device+0x110/0x130
 device_add+0x673/0xc80
 device_register+0x1e/0x30
 sdebug_add_host_helper+0x1a7/0x3b0 [scsi_debug]
 scsi_debug_init+0x64f/0x1000 [scsi_debug]
 do_one_initcall+0xd7/0x470
 do_init_module+0xe7/0x330
 load_module+0x122a/0x12c0
 __do_sys_finit_module+0x124/0x1a0
 __x64_sys_finit_module+0x46/0x50
 do_syscall_64+0x38/0x80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0

Link: https://lore.kernel.org/r/20230210205200.36973-3-bvanassche@acm.org
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Yi Zhang <yi.zhang@redhat.com>
Cc: stable@vger.kernel.org
Fixes: 77c019768f06 ("[SCSI] fix /proc memory leak in the SCSI core")
Reported-by: Yi Zhang <yi.zhang@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hosts.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 9857dba09c951..85e66574ec414 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -181,6 +181,7 @@ void scsi_remove_host(struct Scsi_Host *shost)
 	scsi_forget_host(shost);
 	mutex_unlock(&shost->scan_mutex);
 	scsi_proc_host_rm(shost);
+	scsi_proc_hostdir_rm(shost->hostt);
 
 	/*
 	 * New SCSI devices cannot be attached anymore because of the SCSI host
@@ -340,6 +341,7 @@ static void scsi_host_dev_release(struct device *dev)
 	struct Scsi_Host *shost = dev_to_shost(dev);
 	struct device *parent = dev->parent;
 
+	/* In case scsi_remove_host() has not been called. */
 	scsi_proc_hostdir_rm(shost->hostt);
 
 	/* Wait for functions invoked through call_rcu(&scmd->rcu, ...) */
-- 
2.39.2



