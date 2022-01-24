Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88C8049A483
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:09:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2371459AbiAYAII (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:08:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2363960AbiAXXq1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:46:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43BB3C0BD12A;
        Mon, 24 Jan 2022 13:39:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D7F4C61502;
        Mon, 24 Jan 2022 21:39:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF6E9C340E4;
        Mon, 24 Jan 2022 21:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060388;
        bh=/kC4rX8Klpu5BbDCsn6PjAeVixyISa74Au70dZmqzAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L41wTcZsxSpAfaYVxj04sOpQQUQGZvJRY25Q9bN+4MMGBUZ6JM2A4KtlOrp5SmR3y
         y8aux2JwCZfS1C660RFb1yWgEfQQ0w+iB26xFF9eLY+8jVPullu2rZ+gBCTyMaujcD
         MHimMTJifkH7Vmnn/6ARc2Ls6w8aIdj2kW1Z+g3c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.16 0931/1039] block: fix async_depth sysfs interface for mq-deadline
Date:   Mon, 24 Jan 2022 19:45:20 +0100
Message-Id: <20220124184156.582876833@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 46cdc45acb089c811d9a54fd50af33b96e5fae9d upstream.

A previous commit added this feature, but it inadvertently used the wrong
variable to show/store the setting from/to, victimized by copy/paste. Fix
it up so that the async_depth sysfs interface reads and writes from the
right setting.

Fixes: 07757588e507 ("block/mq-deadline: Reserve 25% of scheduler tags for synchronous requests")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=215485
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/mq-deadline.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -865,7 +865,7 @@ SHOW_JIFFIES(deadline_write_expire_show,
 SHOW_JIFFIES(deadline_prio_aging_expire_show, dd->prio_aging_expire);
 SHOW_INT(deadline_writes_starved_show, dd->writes_starved);
 SHOW_INT(deadline_front_merges_show, dd->front_merges);
-SHOW_INT(deadline_async_depth_show, dd->front_merges);
+SHOW_INT(deadline_async_depth_show, dd->async_depth);
 SHOW_INT(deadline_fifo_batch_show, dd->fifo_batch);
 #undef SHOW_INT
 #undef SHOW_JIFFIES
@@ -895,7 +895,7 @@ STORE_JIFFIES(deadline_write_expire_stor
 STORE_JIFFIES(deadline_prio_aging_expire_store, &dd->prio_aging_expire, 0, INT_MAX);
 STORE_INT(deadline_writes_starved_store, &dd->writes_starved, INT_MIN, INT_MAX);
 STORE_INT(deadline_front_merges_store, &dd->front_merges, 0, 1);
-STORE_INT(deadline_async_depth_store, &dd->front_merges, 1, INT_MAX);
+STORE_INT(deadline_async_depth_store, &dd->async_depth, 1, INT_MAX);
 STORE_INT(deadline_fifo_batch_store, &dd->fifo_batch, 0, INT_MAX);
 #undef STORE_FUNCTION
 #undef STORE_INT


