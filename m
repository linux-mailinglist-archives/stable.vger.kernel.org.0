Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E53B26B3E1
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727438AbgIOXMG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:12:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:48766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727250AbgIOOki (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:40:38 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DA9722596;
        Tue, 15 Sep 2020 14:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600180206;
        bh=2MlElDqWktQiFLVPCiT9YZN9jizDgqyFDk47vnbZgpY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zbe912agmhnyJd94xHHo8mHkqDYzT1+73oP4alfNstdsNxL1GjlohO3doWavaMrxE
         WPubpU0wtvRRbEZbj2nNVPfm8GeAVxmNRSxxkErtZmhOzlT0tapEJOoAwgVrceXAQB
         c/C80zg9iTaZvldsC4ixxJdSg/tjqo/x/CuAFIGI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Smart <james.smart@broadcom.com>,
        Israel Rukshin <israelr@mellanox.com>,
        Max Gurtovoy <maxg@mellanox.com>,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>
Subject: [PATCH 5.8 148/177] nvme: Revert: Fix controller creation races with teardown flow
Date:   Tue, 15 Sep 2020 16:13:39 +0200
Message-Id: <20200915140700.749918617@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <james.smart@broadcom.com>

commit b63de8400a6e1001b5732286cf6f5ec27799b7b4 upstream.

The indicated patch introduced a barrier in the sysfs_delete attribute
for the controller that rejects the request if the controller isn't
created. "Created" is defined as at least 1 call to nvme_start_ctrl().

This is problematic in error-injection testing.  If an error occurs on
the initial attempt to create an association and the controller enters
reconnect(s) attempts, the admin cannot delete the controller until
either there is a successful association created or ctrl_loss_tmo
times out.

Where this issue is particularly hurtful is when the "admin" is the
nvme-cli, it is performing a connection to a discovery controller, and
it is initiated via auto-connect scripts.  With the FC transport, if the
first connection attempt fails, the controller enters a normal reconnect
state but returns control to the cli thread that created the controller.
In this scenario, the cli attempts to read the discovery log via ioctl,
which fails, causing the cli to see it as an empty log and then proceeds
to delete the discovery controller. The delete is rejected and the
controller is left live. If the discovery controller reconnect then
succeeds, there is no action to delete it, and it sits live doing nothing.

Cc: <stable@vger.kernel.org> # v5.7+
Fixes: ce1518139e69 ("nvme: Fix controller creation races with teardown flow")
Signed-off-by: James Smart <james.smart@broadcom.com>
CC: Israel Rukshin <israelr@mellanox.com>
CC: Max Gurtovoy <maxg@mellanox.com>
CC: Christoph Hellwig <hch@lst.de>
CC: Keith Busch <kbusch@kernel.org>
CC: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/nvme/host/core.c |    5 -----
 drivers/nvme/host/nvme.h |    1 -
 2 files changed, 6 deletions(-)

--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3324,10 +3324,6 @@ static ssize_t nvme_sysfs_delete(struct
 {
 	struct nvme_ctrl *ctrl = dev_get_drvdata(dev);
 
-	/* Can't delete non-created controllers */
-	if (!ctrl->created)
-		return -EBUSY;
-
 	if (device_remove_file_self(dev, attr))
 		nvme_delete_ctrl_sync(ctrl);
 	return count;
@@ -4129,7 +4125,6 @@ void nvme_start_ctrl(struct nvme_ctrl *c
 		nvme_queue_scan(ctrl);
 		nvme_start_queues(ctrl);
 	}
-	ctrl->created = true;
 }
 EXPORT_SYMBOL_GPL(nvme_start_ctrl);
 
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -271,7 +271,6 @@ struct nvme_ctrl {
 	struct nvme_command ka_cmd;
 	struct work_struct fw_act_work;
 	unsigned long events;
-	bool created;
 
 #ifdef CONFIG_NVME_MULTIPATH
 	/* asymmetric namespace access: */


