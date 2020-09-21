Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4733D272DF9
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729702AbgIUQot (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:44:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:50334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729179AbgIUQos (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:44:48 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3FB82076B;
        Mon, 21 Sep 2020 16:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706687;
        bh=frpCff4hC2Qu/ydTpqxpklOQSlr6ycnYLx3ohZwClOk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y+PHKQIwdVFJie9vOhtpKoJRwZPYtFbE/8hU0nfxANNm46qi/y0z1NxYza553IQ2j
         40bmlsdd7NZmmSsA6cYiJHjnKVdxQsC4dJX/e3aCmhjLJJb9NFuP0G9Eg13D4mGKil
         38Oxk+9t61BAHpkuzoMCiq3XWD5Ve7meJbdBj2q8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 052/118] Drivers: hv: vmbus: hibernation: do not hang forever in vmbus_bus_resume()
Date:   Mon, 21 Sep 2020 18:27:44 +0200
Message-Id: <20200921162038.744929562@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162036.324813383@linuxfoundation.org>
References: <20200921162036.324813383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dexuan Cui <decui@microsoft.com>

[ Upstream commit 19873eec7e13fda140a0ebc75d6664e57c00bfb1 ]

After we Stop and later Start a VM that uses Accelerated Networking (NIC
SR-IOV), currently the VF vmbus device's Instance GUID can change, so after
vmbus_bus_resume() -> vmbus_request_offers(), vmbus_onoffer() can not find
the original vmbus channel of the VF, and hence we can't complete()
vmbus_connection.ready_for_resume_event in check_ready_for_resume_event(),
and the VM hangs in vmbus_bus_resume() forever.

Fix the issue by adding a timeout, so the resuming can still succeed, and
the saved state is not lost, and according to my test, the user can disable
Accelerated Networking and then will be able to SSH into the VM for
further recovery. Also prevent the VM in question from suspending again.

The host will be fixed so in future the Instance GUID will stay the same
across hibernation.

Fixes: d8bd2d442bb2 ("Drivers: hv: vmbus: Resume after fixing up old primary channels")
Signed-off-by: Dexuan Cui <decui@microsoft.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Link: https://lore.kernel.org/r/20200905025555.45614-1-decui@microsoft.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/vmbus_drv.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index d69f4efa37198..dacdd8d2eb1b3 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -2383,7 +2383,10 @@ static int vmbus_bus_suspend(struct device *dev)
 	if (atomic_read(&vmbus_connection.nr_chan_close_on_suspend) > 0)
 		wait_for_completion(&vmbus_connection.ready_for_suspend_event);
 
-	WARN_ON(atomic_read(&vmbus_connection.nr_chan_fixup_on_resume) != 0);
+	if (atomic_read(&vmbus_connection.nr_chan_fixup_on_resume) != 0) {
+		pr_err("Can not suspend due to a previous failed resuming\n");
+		return -EBUSY;
+	}
 
 	mutex_lock(&vmbus_connection.channel_mutex);
 
@@ -2459,7 +2462,9 @@ static int vmbus_bus_resume(struct device *dev)
 
 	vmbus_request_offers();
 
-	wait_for_completion(&vmbus_connection.ready_for_resume_event);
+	if (wait_for_completion_timeout(
+		&vmbus_connection.ready_for_resume_event, 10 * HZ) == 0)
+		pr_err("Some vmbus device is missing after suspending?\n");
 
 	/* Reset the event for the next suspend. */
 	reinit_completion(&vmbus_connection.ready_for_suspend_event);
-- 
2.25.1



