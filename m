Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DDBA604759
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 15:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232023AbiJSNhT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 09:37:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230507AbiJSNgl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 09:36:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B987715A30F;
        Wed, 19 Oct 2022 06:25:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA7A8B8246F;
        Wed, 19 Oct 2022 09:05:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EB96C433D6;
        Wed, 19 Oct 2022 09:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170301;
        bh=3cZfXNGay6xumMtnyc1YClpFLbzGcS3qOU+GZM9G51o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZXZ1OPmrFm38tcVxKpOuiVRjU6nFgTuhFS4Rv1XPlp/64X2sKurOlMfhk3jOaKHZx
         RxatXq7hRVhK1ulPCDrLPnTqctVRlfAXxidf3l+3RGa/gamU+pcRf+OQ1G7Z8wWlLi
         rHXgAK5xOKjoaDRcvchFZkQrT4qWP9YQP5QV7DQI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Wang <jinpu.wang@ionos.com>,
        John Garry <john.garry@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 566/862] scsi: pm8001: Fix running_req for internal abort commands
Date:   Wed, 19 Oct 2022 10:30:53 +0200
Message-Id: <20221019083315.004056912@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Garry <john.garry@huawei.com>

[ Upstream commit d8c22c4697c11ed28062afe3c2b377025be11a23 ]

Disabling the remote phy for a SATA disk causes a hang:

root@(none)$ more /sys/class/sas_phy/phy-0:0:8/target_port_protocols
sata
root@(none)$ echo 0 > sys/class/sas_phy/phy-0:0:8/enable
root@(none)$ [   67.855950] sas: ex 500e004aaaaaaa1f phy08 change count has changed
[   67.920585] sd 0:0:2:0: [sdc] Synchronizing SCSI cache
[   67.925780] sd 0:0:2:0: [sdc] Synchronize Cache(10) failed: Result: hostbyte=0x04 driverbyte=DRIVER_OK
[   67.935094] sd 0:0:2:0: [sdc] Stopping disk
[   67.939305] sd 0:0:2:0: [sdc] Start/Stop Unit failed: Result: hostbyte=0x04 driverbyte=DRIVER_OK
...
[  123.998998] INFO: task kworker/u192:1:642 blocked for more than 30 seconds.
[  124.005960]   Not tainted 6.0.0-rc1-205202-gf26f8f761e83 #218
[  124.012049] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  124.019872] task:kworker/u192:1  state:D stack:0 pid:  642 ppid: 2 flags:0x00000008
[  124.028223] Workqueue: 0000:04:00.0_event_q sas_port_event_worker
[  124.034319] Call trace:
[  124.036758]  __switch_to+0x128/0x278
[  124.040333]  __schedule+0x434/0xa58
[  124.043820]  schedule+0x94/0x138
[  124.047045]  schedule_timeout+0x2fc/0x368
[  124.051052]  wait_for_completion+0xdc/0x200
[  124.055234]  __flush_workqueue+0x1a8/0x708
[  124.059328]  sas_porte_broadcast_rcvd+0xa8/0xc0
[  124.063858]  sas_port_event_worker+0x60/0x98
[  124.068126]  process_one_work+0x3f8/0x660
[  124.072134]  worker_thread+0x70/0x700
[  124.075793]  kthread+0x1a4/0x1b8
[  124.079014]  ret_from_fork+0x10/0x20

The issue is that the per-device running_req read in
pm8001_dev_gone_notify() never goes to zero and we never make progress.
This is caused by missing accounting for running_req for when an internal
abort command completes.

In commit 2cbbf489778e ("scsi: pm8001: Use libsas internal abort support")
we started to send internal abort commands as a proper sas_task. In this
when we deliver a sas_task to HW the per-device running_req is incremented
in pm8001_queue_command(). However it is never decremented for internal
abort commnds, so decrement in pm8001_mpi_task_abort_resp().

Link: https://lore.kernel.org/r/1663854664-76165-1-git-send-email-john.garry@huawei.com
Fixes: 2cbbf489778e ("scsi: pm8001: Use libsas internal abort support")
Acked-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 91d78d0a38fe..628b08ba6770 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -3612,6 +3612,10 @@ int pm8001_mpi_task_abort_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		pm8001_dbg(pm8001_ha, FAIL, " TASK NULL. RETURNING !!!\n");
 		return -1;
 	}
+
+	if (t->task_proto == SAS_PROTOCOL_INTERNAL_ABORT)
+		atomic_dec(&pm8001_dev->running_req);
+
 	ts = &t->task_status;
 	if (status != 0)
 		pm8001_dbg(pm8001_ha, FAIL, "task abort failed status 0x%x ,tag = 0x%x, scp= 0x%x\n",
-- 
2.35.1



