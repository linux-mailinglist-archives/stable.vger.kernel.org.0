Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10F3F2EF34
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732748AbfE3Dxm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:53:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:55402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731909AbfE3DT3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:19:29 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F145624893;
        Thu, 30 May 2019 03:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186369;
        bh=6HhoEqfB900/gBNVZ2xAYHzCuhOQS/FB6bnJ+gdUPWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PqOQUy5GwOfMpDZfSRdRuyURxK4hFIuSm/drkV9Mw88oINYxerrJqtQmMpcGWcLvn
         d+GAdQGHCzVR2QRs4hrNFJGBWq7hffLUDAxY/aAUs7sRLDQ++YQiIbf2bB1XngXKCy
         SJpHmlFbqIpEYviQkRYLreYw31nXGFEbry9HWvx8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 077/193] vfio-ccw: Do not call flush_workqueue while holding the spinlock
Date:   Wed, 29 May 2019 20:05:31 -0700
Message-Id: <20190530030459.782377268@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030446.953835040@linuxfoundation.org>
References: <20190530030446.953835040@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit cea5dde42a83b5f0a039da672f8686455936b8d8 ]

Currently we call flush_workqueue while holding the subchannel
spinlock. But flush_workqueue function can go to sleep, so
do not call the function while holding the spinlock.

Fixes the following bug:

[  285.203430] BUG: scheduling while atomic: bash/14193/0x00000002
[  285.203434] INFO: lockdep is turned off.
....
[  285.203485] Preemption disabled at:
[  285.203488] [<000003ff80243e5c>] vfio_ccw_sch_quiesce+0xbc/0x120 [vfio_ccw]
[  285.203496] CPU: 7 PID: 14193 Comm: bash Tainted: G        W
....
[  285.203504] Call Trace:
[  285.203510] ([<0000000000113772>] show_stack+0x82/0xd0)
[  285.203514]  [<0000000000b7a102>] dump_stack+0x92/0xd0
[  285.203518]  [<000000000017b8be>] __schedule_bug+0xde/0xf8
[  285.203524]  [<0000000000b95b5a>] __schedule+0x7a/0xc38
[  285.203528]  [<0000000000b9678a>] schedule+0x72/0xb0
[  285.203533]  [<0000000000b9bfbc>] schedule_timeout+0x34/0x528
[  285.203538]  [<0000000000b97608>] wait_for_common+0x118/0x1b0
[  285.203544]  [<0000000000166d6a>] flush_workqueue+0x182/0x548
[  285.203550]  [<000003ff80243e6e>] vfio_ccw_sch_quiesce+0xce/0x120 [vfio_ccw]
[  285.203556]  [<000003ff80245278>] vfio_ccw_mdev_reset+0x38/0x70 [vfio_ccw]
[  285.203562]  [<000003ff802458b0>] vfio_ccw_mdev_remove+0x40/0x78 [vfio_ccw]
[  285.203567]  [<000003ff801a499c>] mdev_device_remove_ops+0x3c/0x80 [mdev]
[  285.203573]  [<000003ff801a4d5c>] mdev_device_remove+0xc4/0x130 [mdev]
[  285.203578]  [<000003ff801a5074>] remove_store+0x6c/0xa8 [mdev]
[  285.203582]  [<000000000046f494>] kernfs_fop_write+0x14c/0x1f8
[  285.203588]  [<00000000003c1530>] __vfs_write+0x38/0x1a8
[  285.203593]  [<00000000003c187c>] vfs_write+0xb4/0x198
[  285.203597]  [<00000000003c1af2>] ksys_write+0x5a/0xb0
[  285.203601]  [<0000000000b9e270>] system_call+0xdc/0x2d8

Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
Reviewed-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
Message-Id: <626bab8bb2958ae132452e1ddaf1b20882ad5a9d.1554756534.git.alifm@linux.ibm.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/cio/vfio_ccw_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index d22759eb66407..59eb5e6d9c79d 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -52,9 +52,9 @@ int vfio_ccw_sch_quiesce(struct subchannel *sch)
 
 			wait_for_completion_timeout(&completion, 3*HZ);
 
-			spin_lock_irq(sch->lock);
 			private->completion = NULL;
 			flush_workqueue(vfio_ccw_work_q);
+			spin_lock_irq(sch->lock);
 			ret = cio_cancel_halt_clear(sch, &iretry);
 		};
 
-- 
2.20.1



