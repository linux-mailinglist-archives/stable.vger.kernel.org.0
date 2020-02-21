Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41B9416743E
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:23:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388034AbgBUITi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:19:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:58302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388045AbgBUITi (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:19:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD96F24694;
        Fri, 21 Feb 2020 08:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582273177;
        bh=sgwlTZtHceOcXQlBCBMlRKJUHnRjwhhrQxZY8HOsp7I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WUyoQuaPRrrrx+E/0bVXYsPC7P8Nnh1wcFRff0on1UhFOT0mZbNxfFswDcbmIz0GF
         rU/VqyVl3xiSZ/61ULgQkYbma683eYAOAvZM3I1h97P2jJfn/hw9eJ6oJ9dU14Y6qn
         cZY1x/O9HHFFjci6EcOCf+BK+rCvst9xy9Qysav8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sun Ke <sunke32@huawei.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 047/191] nbd: add a flush_workqueue in nbd_start_device
Date:   Fri, 21 Feb 2020 08:40:20 +0100
Message-Id: <20200221072257.378789807@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072250.732482588@linuxfoundation.org>
References: <20200221072250.732482588@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sun Ke <sunke32@huawei.com>

[ Upstream commit 5c0dd228b5fc30a3b732c7ae2657e0161ec7ed80 ]

When kzalloc fail, may cause trying to destroy the
workqueue from inside the workqueue.

If num_connections is m (2 < m), and NO.1 ~ NO.n
(1 < n < m) kzalloc are successful. The NO.(n + 1)
failed. Then, nbd_start_device will return ENOMEM
to nbd_start_device_ioctl, and nbd_start_device_ioctl
will return immediately without running flush_workqueue.
However, we still have n recv threads. If nbd_release
run first, recv threads may have to drop the last
config_refs and try to destroy the workqueue from
inside the workqueue.

To fix it, add a flush_workqueue in nbd_start_device.

Fixes: e9e006f5fcf2 ("nbd: fix max number of supported devs")
Signed-off-by: Sun Ke <sunke32@huawei.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/nbd.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index b9d321bdaa8a7..226103af30f05 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -1216,6 +1216,16 @@ static int nbd_start_device(struct nbd_device *nbd)
 		args = kzalloc(sizeof(*args), GFP_KERNEL);
 		if (!args) {
 			sock_shutdown(nbd);
+			/*
+			 * If num_connections is m (2 < m),
+			 * and NO.1 ~ NO.n(1 < n < m) kzallocs are successful.
+			 * But NO.(n + 1) failed. We still have n recv threads.
+			 * So, add flush_workqueue here to prevent recv threads
+			 * dropping the last config_refs and trying to destroy
+			 * the workqueue from inside the workqueue.
+			 */
+			if (i)
+				flush_workqueue(nbd->recv_workq);
 			return -ENOMEM;
 		}
 		sk_set_memalloc(config->socks[i]->sock->sk);
-- 
2.20.1



