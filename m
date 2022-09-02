Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6935AAF5E
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236912AbiIBMhA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236910AbiIBMg1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:36:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 461C71D0F1;
        Fri,  2 Sep 2022 05:29:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E13CCB82A9B;
        Fri,  2 Sep 2022 12:28:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D7C6C433C1;
        Fri,  2 Sep 2022 12:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121735;
        bh=DEATEnYUWeZlx0T33Q2V5HdpONmNFsiiqbbVGmxrerY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xVXF494lxZchIr9TzZG53C40m1C/ZMIF97lpivdKqM+05x3z+bwVpqYfH/LD3/fbW
         4VM8F+WrITKnFrNLdAkHAqoiovYwWVgi8plgGKUNSRXpszk8EQ3ebwrh2nySt9h9zT
         A15jKcud1h+HCyJ1GKa9WslaHEMYK8XvyJup7QXU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Kelley <mikelley@microsoft.com>,
        Saurabh Sengar <ssengar@linux.microsoft.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.4 48/77] scsi: storvsc: Remove WQ_MEM_RECLAIM from storvsc_error_wq
Date:   Fri,  2 Sep 2022 14:18:57 +0200
Message-Id: <20220902121405.241549357@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121403.569927325@linuxfoundation.org>
References: <20220902121403.569927325@linuxfoundation.org>
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
@@ -1846,7 +1846,7 @@ static int storvsc_probe(struct hv_devic
 	 */
 	host_dev->handle_error_wq =
 			alloc_ordered_workqueue("storvsc_error_wq_%d",
-						WQ_MEM_RECLAIM,
+						0,
 						host->host_no);
 	if (!host_dev->handle_error_wq)
 		goto err_out2;


