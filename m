Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 103C73286D1
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:17:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237908AbhCARPp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:15:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:36106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237558AbhCARIY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:08:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F17156500A;
        Mon,  1 Mar 2021 16:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616892;
        bh=GdtgZNuFird63mYoLEQ+/N6skbrzCla4VJhO6TulXGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LjrFJvDQF59kGc7AaLEJrKezNHmrCI8hZ8yWZBtCTztWtlmZ9TZanIOmCKlK6tBnj
         B3sujKHf9bsYJJ4H3ezGuxO0U5ax4e4VckVrLR61P19u4uIc5h46s71sanboQUI0ec
         77UImGyw39+qEOlnF5B3QHYYMnk1skeamwOCJV+k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shay Drory <shayd@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 132/247] IB/umad: Return EPOLLERR in case of when device disassociated
Date:   Mon,  1 Mar 2021 17:12:32 +0100
Message-Id: <20210301161038.129991424@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
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
index db2ac5218c371..471a824be86c4 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -384,6 +384,11 @@ static ssize_t ib_umad_read(struct file *filp, char __user *buf,
 		mutex_lock(&file->mutex);
 	}
 
+	if (file->agents_dead) {
+		mutex_unlock(&file->mutex);
+		return -EIO;
+	}
+
 	packet = list_entry(file->recv_list.next, struct ib_umad_packet, list);
 	list_del(&packet->list);
 
@@ -642,10 +647,14 @@ static __poll_t ib_umad_poll(struct file *filp, struct poll_table_struct *wait)
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
@@ -1262,6 +1271,7 @@ static void ib_umad_kill_port(struct ib_umad_port *port)
 	list_for_each_entry(file, &port->file_list, port_list) {
 		mutex_lock(&file->mutex);
 		file->agents_dead = 1;
+		wake_up_interruptible(&file->recv_wait);
 		mutex_unlock(&file->mutex);
 
 		for (id = 0; id < IB_UMAD_MAX_AGENTS; ++id)
-- 
2.27.0



