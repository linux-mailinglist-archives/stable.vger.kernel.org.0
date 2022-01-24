Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 733E549910F
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:09:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352091AbiAXUIz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:08:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354637AbiAXUDQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:03:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2528C0680B1;
        Mon, 24 Jan 2022 11:29:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 822DF6121F;
        Mon, 24 Jan 2022 19:29:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F8ACC340E5;
        Mon, 24 Jan 2022 19:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052564;
        bh=O+wV61hDuUBLN9MQUp3fRVGM3ohEbAo7+Lu3sKVPxfY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y3L9HqBZ8xjspTEoaQdxe0FqizTnQHloQ64un2ZleSOEkKtUxA2aSD7ySs4h/3Y+8
         dmN3R7EMYlMZdr3OK4AvtHWVzwy+HBWAPr9sXgqmwrR4RKgNN97UDXkmUOiws2/WVv
         ahZvr1AQB2EX0Ol539lmxs8ueNfttomEf13bJmhg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tasos Sahanidis <tasos@tasossah.com>,
        Denis Efremov <efremov@linux.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 068/320] floppy: Fix hang in watchdog when disk is ejected
Date:   Mon, 24 Jan 2022 19:40:52 +0100
Message-Id: <20220124183956.040262234@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
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
index ac97a1e2e5ddc..212a1e1ce0d9e 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -1003,7 +1003,7 @@ static DECLARE_DELAYED_WORK(fd_timer, fd_timer_workfn);
 static void cancel_activity(void)
 {
 	do_floppy = NULL;
-	cancel_delayed_work_sync(&fd_timer);
+	cancel_delayed_work(&fd_timer);
 	cancel_work_sync(&floppy_work);
 }
 
-- 
2.34.1



