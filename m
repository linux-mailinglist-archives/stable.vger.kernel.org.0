Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 414632E3C96
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:05:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437385AbgL1OEf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:04:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:38432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437371AbgL1OEb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:04:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07B5222583;
        Mon, 28 Dec 2020 14:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164256;
        bh=/CsNkTnhqTfltXlyCMYHPm/LxeE5LFUmI7fNs9s0wek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bdfT1cMQpuGSkjYOiNGR+GHN/7dMV9oPkN3PGQK753zMfzwDOofVysP1JH7bRUuS/
         3AaMz8XI7VgAhJjvjrghRYK16mxqk7fUGqK0goTWdiOeF0TMQgyRXxiET6O9NRO0yn
         BBFFlRBHaviOzhZEXx/0C/0ls6stUjbhEPVmo1HE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cristian Marussi <cristian.marussi@arm.com>,
        Qinglang Miao <miaoqinglang@huawei.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 109/717] firmware: arm_scmi: Fix missing destroy_workqueue()
Date:   Mon, 28 Dec 2020 13:41:47 +0100
Message-Id: <20201228125026.178079162@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qinglang Miao <miaoqinglang@huawei.com>

[ Upstream commit 6bbdb46c4b1bd57839c9c0a110bd81b0be0a4046 ]

destroy_workqueue is required before the return from scmi_notification_init
in case devm_kcalloc fails to allocate registered_protocols. Fix this by
simply moving registered_protocols allocation before alloc_workqueue.

Link: https://lore.kernel.org/r/20201110074221.41235-1-miaoqinglang@huawei.com
Fixes: bd31b249692e ("firmware: arm_scmi: Add notification dispatch and delivery")
Suggested-by: Cristian Marussi <cristian.marussi@arm.com>
Reviewed-by: Cristian Marussi <cristian.marussi@arm.com>
Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/notify.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/firmware/arm_scmi/notify.c b/drivers/firmware/arm_scmi/notify.c
index ce336899d6366..66196b293b6c2 100644
--- a/drivers/firmware/arm_scmi/notify.c
+++ b/drivers/firmware/arm_scmi/notify.c
@@ -1474,17 +1474,17 @@ int scmi_notification_init(struct scmi_handle *handle)
 	ni->gid = gid;
 	ni->handle = handle;
 
+	ni->registered_protocols = devm_kcalloc(handle->dev, SCMI_MAX_PROTO,
+						sizeof(char *), GFP_KERNEL);
+	if (!ni->registered_protocols)
+		goto err;
+
 	ni->notify_wq = alloc_workqueue(dev_name(handle->dev),
 					WQ_UNBOUND | WQ_FREEZABLE | WQ_SYSFS,
 					0);
 	if (!ni->notify_wq)
 		goto err;
 
-	ni->registered_protocols = devm_kcalloc(handle->dev, SCMI_MAX_PROTO,
-						sizeof(char *), GFP_KERNEL);
-	if (!ni->registered_protocols)
-		goto err;
-
 	mutex_init(&ni->pending_mtx);
 	hash_init(ni->pending_events_handlers);
 
-- 
2.27.0



