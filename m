Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE27B5AAF17
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236817AbiIBMdS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:33:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236702AbiIBMcF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:32:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E75E8E1934;
        Fri,  2 Sep 2022 05:27:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A10EB82AA2;
        Fri,  2 Sep 2022 12:25:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 868D0C433D7;
        Fri,  2 Sep 2022 12:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121524;
        bh=datHgiSjND2VmkLLoF7eduR5OnhuevfGSmxmRwUU9Jg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sCUSvf4kzN5e+Tj84nq2/X2zb5mdjSEoHAlZcrh2D/vTkLiZakf3mzwzvxECs2AHp
         nJv2ODDrhDT5DBV9yOo3bNETSOa3vxq3SbAiKTIHvCQVJsKGeojTplKnd77jikU/Wa
         KM27q+3hw2DEYuJS3OnhWNLvmRt6Urz0URCS++dE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Kelley <mikelley@microsoft.com>,
        Saurabh Sengar <ssengar@linux.microsoft.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.19 36/56] scsi: storvsc: Remove WQ_MEM_RECLAIM from storvsc_error_wq
Date:   Fri,  2 Sep 2022 14:18:56 +0200
Message-Id: <20220902121401.554898954@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121400.219861128@linuxfoundation.org>
References: <20220902121400.219861128@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Saurabh Sengar <ssengar@linux.microsoft.com>

commit d957e7ffb2c72410bcc1a514153a46719255a5da upstream.

storvsc_error_wq workqueue should not be marked as WQ_MEM_RECLAIM as it
doesn't need to make forward progress under memory pressure.  Marking this
workqueue as WQ_MEM_RECLAIM may cause deadlock while flushing a
non-WQ_MEM_RECLAIM workqueue.  In the current state it causes the following
warning:

[   14.506347] ------------[ cut here ]------------
[   14.506354] workqueue: WQ_MEM_RECLAIM storvsc_error_wq_0:storvsc_remove_lun is flushing !WQ_MEM_RECLAIM events_freezable_power_:disk_events_workfn
[   14.506360] WARNING: CPU: 0 PID: 8 at <-snip->kernel/workqueue.c:2623 check_flush_dependency+0xb5/0x130
[   14.506390] CPU: 0 PID: 8 Comm: kworker/u4:0 Not tainted 5.4.0-1086-azure #91~18.04.1-Ubuntu
[   14.506391] Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS Hyper-V UEFI Release v4.1 05/09/2022
[   14.506393] Workqueue: storvsc_error_wq_0 storvsc_remove_lun
[   14.506395] RIP: 0010:check_flush_dependency+0xb5/0x130
		<-snip->
[   14.506408] Call Trace:
[   14.506412]  __flush_work+0xf1/0x1c0
[   14.506414]  __cancel_work_timer+0x12f/0x1b0
[   14.506417]  ? kernfs_put+0xf0/0x190
[   14.506418]  cancel_delayed_work_sync+0x13/0x20
[   14.506420]  disk_block_events+0x78/0x80
[   14.506421]  del_gendisk+0x3d/0x2f0
[   14.506423]  sr_remove+0x28/0x70
[   14.506427]  device_release_driver_internal+0xef/0x1c0
[   14.506428]  device_release_driver+0x12/0x20
[   14.506429]  bus_remove_device+0xe1/0x150
[   14.506431]  device_del+0x167/0x380
[   14.506432]  __scsi_remove_device+0x11d/0x150
[   14.506433]  scsi_remove_device+0x26/0x40
[   14.506434]  storvsc_remove_lun+0x40/0x60
[   14.506436]  process_one_work+0x209/0x400
[   14.506437]  worker_thread+0x34/0x400
[   14.506439]  kthread+0x121/0x140
[   14.506440]  ? process_one_work+0x400/0x400
[   14.506441]  ? kthread_park+0x90/0x90
[   14.506443]  ret_from_fork+0x35/0x40
[   14.506445] ---[ end trace 2d9633159fdc6ee7 ]---

Link: https://lore.kernel.org/r/1659628534-17539-1-git-send-email-ssengar@linux.microsoft.com
Fixes: 436ad9413353 ("scsi: storvsc: Allow only one remove lun work item to be issued per lun")
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Signed-off-by: Saurabh Sengar <ssengar@linux.microsoft.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/storvsc_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1858,7 +1858,7 @@ static int storvsc_probe(struct hv_devic
 	 */
 	host_dev->handle_error_wq =
 			alloc_ordered_workqueue("storvsc_error_wq_%d",
-						WQ_MEM_RECLAIM,
+						0,
 						host->host_no);
 	if (!host_dev->handle_error_wq)
 		goto err_out2;


