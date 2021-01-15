Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1C572F79B9
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:40:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733232AbhAOMkS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:40:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:47762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388508AbhAOMkJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:40:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 33395206CB;
        Fri, 15 Jan 2021 12:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714368;
        bh=bBQCFA0IrcLUCpOpZcoJBFoOWWSdsynUXX6FzxZZBi8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ri3z0Exlf6g3aY4wSIDOUZ97kE66uJKy0byAzy9d8AEsVQDQEqXInjJmVxQtw1wMN
         723R9l7NYxLuLJvXk8jg4HTrV967rffgT7K7+b3qRbpF4TNQQK/OUQ/mYnoQfuTS+h
         xttLHVGLqjVKOrfyAYFgWE4a2gMnTAo9ZzTbpDKU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Wang <jinpu.wang@cloud.ionos.com>,
        Gioh Kim <gi-oh.kim@cloud.ionos.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 097/103] block/rnbd-clt: avoid module unload race with close confirmation
Date:   Fri, 15 Jan 2021 13:28:30 +0100
Message-Id: <20210115122010.697917763@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115122006.047132306@linuxfoundation.org>
References: <20210115122006.047132306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Wang <jinpu.wang@cloud.ionos.com>

commit 3a21777c6ee99749bac10727b3c17e5bcfebe5c1 upstream.

We had kernel panic, it is caused by unload module and last
close confirmation.

call trace:
[1196029.743127]  free_sess+0x15/0x50 [rtrs_client]
[1196029.743128]  rtrs_clt_close+0x4c/0x70 [rtrs_client]
[1196029.743129]  ? rnbd_clt_unmap_device+0x1b0/0x1b0 [rnbd_client]
[1196029.743130]  close_rtrs+0x25/0x50 [rnbd_client]
[1196029.743131]  rnbd_client_exit+0x93/0xb99 [rnbd_client]
[1196029.743132]  __x64_sys_delete_module+0x190/0x260

And in the crashdump confirmation kworker is also running.
PID: 6943   TASK: ffff9e2ac8098000  CPU: 4   COMMAND: "kworker/4:2"
 #0 [ffffb206cf337c30] __schedule at ffffffff9f93f891
 #1 [ffffb206cf337cc8] schedule at ffffffff9f93fe98
 #2 [ffffb206cf337cd0] schedule_timeout at ffffffff9f943938
 #3 [ffffb206cf337d50] wait_for_completion at ffffffff9f9410a7
 #4 [ffffb206cf337da0] __flush_work at ffffffff9f08ce0e
 #5 [ffffb206cf337e20] rtrs_clt_close_conns at ffffffffc0d5f668 [rtrs_client]
 #6 [ffffb206cf337e48] rtrs_clt_close at ffffffffc0d5f801 [rtrs_client]
 #7 [ffffb206cf337e68] close_rtrs at ffffffffc0d26255 [rnbd_client]
 #8 [ffffb206cf337e78] free_sess at ffffffffc0d262ad [rnbd_client]
 #9 [ffffb206cf337e88] rnbd_clt_put_dev at ffffffffc0d266a7 [rnbd_client]

The problem is both code path try to close same session, which lead to
panic.

To fix it, just skip the sess if the refcount already drop to 0.

Fixes: f7a7a5c228d4 ("block/rnbd: client: main functionality")
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Reviewed-by: Gioh Kim <gi-oh.kim@cloud.ionos.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/rnbd/rnbd-clt.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/block/rnbd/rnbd-clt.c
+++ b/drivers/block/rnbd/rnbd-clt.c
@@ -1671,7 +1671,8 @@ static void rnbd_destroy_sessions(void)
 	 */
 
 	list_for_each_entry_safe(sess, sn, &sess_list, list) {
-		WARN_ON(!rnbd_clt_get_sess(sess));
+		if (!rnbd_clt_get_sess(sess))
+			continue;
 		close_rtrs(sess);
 		list_for_each_entry_safe(dev, tn, &sess->devs_list, list) {
 			/*


