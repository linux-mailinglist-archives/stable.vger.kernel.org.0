Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5570499290
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:21:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345297AbiAXUVo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:21:44 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58334 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351341AbiAXUTa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:19:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B27F6B8121A;
        Mon, 24 Jan 2022 20:19:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCB22C340E7;
        Mon, 24 Jan 2022 20:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055567;
        bh=Mrdz9n3gVoGgIoKZjGBcYgIVFGZBMbpyNF6lQBjuW00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NkJedhuiReAyvsBxorTzVQ+zAw7wK5i5W3140vxm+mhPOFCNJf3Jz0ps/iQiA2kbU
         XKE8GNi/IiMa9kj0dfxikl3n707UwxvWlLUIp62FPBUnJXpmj5ioAdmJmUsHateAl1
         qntxTSjTvcz3kSEuw7SI6XVYRvoCop823xbEoxc8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tasos Sahanidis <tasos@tasossah.com>,
        Denis Efremov <efremov@linux.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 194/846] floppy: Fix hang in watchdog when disk is ejected
Date:   Mon, 24 Jan 2022 19:35:11 +0100
Message-Id: <20220124184107.646149772@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tasos Sahanidis <tasos@tasossah.com>

[ Upstream commit fb48febce7e30baed94dd791e19521abd2c3fd83 ]

When the watchdog detects a disk change, it calls cancel_activity(),
which in turn tries to cancel the fd_timer delayed work.

In the above scenario, fd_timer_fn is set to fd_watchdog(), meaning
it is trying to cancel its own work.
This results in a hang as cancel_delayed_work_sync() is waiting for the
watchdog (itself) to return, which never happens.

This can be reproduced relatively consistently by attempting to read a
broken floppy, and ejecting it while IO is being attempted and retried.

To resolve this, this patch calls cancel_delayed_work() instead, which
cancels the work without waiting for the watchdog to return and finish.

Before this regression was introduced, the code in this section used
del_timer(), and not del_timer_sync() to delete the watchdog timer.

Link: https://lore.kernel.org/r/399e486c-6540-db27-76aa-7a271b061f76@tasossah.com
Fixes: 070ad7e793dc ("floppy: convert to delayed work and single-thread wq")
Signed-off-by: Tasos Sahanidis <tasos@tasossah.com>
Signed-off-by: Denis Efremov <efremov@linux.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/floppy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index fb2aafabfebc1..f50bbaba5762c 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -1014,7 +1014,7 @@ static DECLARE_DELAYED_WORK(fd_timer, fd_timer_workfn);
 static void cancel_activity(void)
 {
 	do_floppy = NULL;
-	cancel_delayed_work_sync(&fd_timer);
+	cancel_delayed_work(&fd_timer);
 	cancel_work_sync(&floppy_work);
 }
 
-- 
2.34.1



