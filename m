Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58CF73288BE
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:46:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238847AbhCARno (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:43:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:60232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233591AbhCARjZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:39:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F5BF64FC8;
        Mon,  1 Mar 2021 16:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617770;
        bh=N43/saR9DUtgG12qFdTPVb3gwqPYXZ4O2EiGh4urzag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dq3yU8ywrGeYD9i//pLl389hQJ0saUISovSIEBJDRsh4oWsYKREq0Js0om7TnS4hK
         bcZMIVU38S7ctqACCtlOUAUOqQbNEwZyB9y8KiG+8MwAGFalZt96bLeJims5vpKAzT
         Cu3LI6vfzllHnIfcR7jYLt9Cn2F5LWP6WkdDnT6g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shay Drory <shayd@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 163/340] IB/umad: Return EPOLLERR in case of when device disassociated
Date:   Mon,  1 Mar 2021 17:11:47 +0100
Message-Id: <20210301161056.332944278@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit def4cd43f522253645b72c97181399c241b54536 ]

Currently, polling a umad device will always works, even if the device was
disassociated. A disassociated device should immediately return EPOLLERR
from poll(). Otherwise userspace is endlessly hung on poll() with no idea
that the device has been removed from the system.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Link: https://lore.kernel.org/r/20210125121339.837518-3-leon@kernel.org
Signed-off-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/user_mad.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index dec5175803fe2..ad3a092b8b5c3 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -397,6 +397,11 @@ static ssize_t ib_umad_read(struct file *filp, char __user *buf,
 		mutex_lock(&file->mutex);
 	}
 
+	if (file->agents_dead) {
+		mutex_unlock(&file->mutex);
+		return -EIO;
+	}
+
 	packet = list_entry(file->recv_list.next, struct ib_umad_packet, list);
 	list_del(&packet->list);
 
@@ -658,10 +663,14 @@ static __poll_t ib_umad_poll(struct file *filp, struct poll_table_struct *wait)
 	/* we will always be able to post a MAD send */
 	__poll_t mask = EPOLLOUT | EPOLLWRNORM;
 
+	mutex_lock(&file->mutex);
 	poll_wait(filp, &file->recv_wait, wait);
 
 	if (!list_empty(&file->recv_list))
 		mask |= EPOLLIN | EPOLLRDNORM;
+	if (file->agents_dead)
+		mask = EPOLLERR;
+	mutex_unlock(&file->mutex);
 
 	return mask;
 }
@@ -1341,6 +1350,7 @@ static void ib_umad_kill_port(struct ib_umad_port *port)
 	list_for_each_entry(file, &port->file_list, port_list) {
 		mutex_lock(&file->mutex);
 		file->agents_dead = 1;
+		wake_up_interruptible(&file->recv_wait);
 		mutex_unlock(&file->mutex);
 
 		for (id = 0; id < IB_UMAD_MAX_AGENTS; ++id)
-- 
2.27.0



