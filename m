Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E560B49E9C5
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 19:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244944AbiA0SJr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 13:09:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244954AbiA0SJV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 13:09:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1159C061749;
        Thu, 27 Jan 2022 10:09:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5022361CCC;
        Thu, 27 Jan 2022 18:09:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20C97C340E4;
        Thu, 27 Jan 2022 18:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643306960;
        bh=VuaJ6H6GECXK5poI6DDZmDBQRVosGj++isu1R4XXBLY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wj/925qmaLtKpQ8zBXeijw+usSuRp/Z9vec6uxOOLABw59iSygOrqlmjlThICrcrp
         h8+dvSIXynKVXYXgaPS+OnqDd1qpNcVVs8CqRXApM5WpuwrLHTor+60ymWWJZadZc3
         umHip1YtqvnP/1TQk5YJStGukTeWPw8OuOkcGxAI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+5ca851459ed04c778d1d@syzkaller.appspotmail.com,
        Ziyang Xuan <william.xuanziyang@huawei.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>
Subject: [PATCH 4.14 2/2] can: bcm: fix UAF of bcm op
Date:   Thu, 27 Jan 2022 19:08:57 +0100
Message-Id: <20220127180256.840826051@linuxfoundation.org>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20220127180256.764665162@linuxfoundation.org>
References: <20220127180256.764665162@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ziyang Xuan <william.xuanziyang@huawei.com>

Stopping tasklet and hrtimer rely on the active state of tasklet and
hrtimer sequentially in bcm_remove_op(), the op object will be freed
if they are all unactive. Assume the hrtimer timeout is short, the
hrtimer cb has been excuted after tasklet conditional judgment which
must be false after last round tasklet_kill() and before condition
hrtimer_active(), it is false when execute to hrtimer_active(). Bug
is triggerd, because the stopping action is end and the op object
will be freed, but the tasklet is scheduled. The resources of the op
object will occur UAF bug.

Move hrtimer_cancel() behind tasklet_kill() and switch 'while () {...}'
to 'do {...} while ()' to fix the op UAF problem.

Fixes: a06393ed0316 ("can: bcm: fix hrtimer/tasklet termination in bcm op removal")
Reported-by: syzbot+5ca851459ed04c778d1d@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/bcm.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -762,21 +762,21 @@ static struct bcm_op *bcm_find_op(struct
 static void bcm_remove_op(struct bcm_op *op)
 {
 	if (op->tsklet.func) {
-		while (test_bit(TASKLET_STATE_SCHED, &op->tsklet.state) ||
-		       test_bit(TASKLET_STATE_RUN, &op->tsklet.state) ||
-		       hrtimer_active(&op->timer)) {
-			hrtimer_cancel(&op->timer);
+		do {
 			tasklet_kill(&op->tsklet);
-		}
+			hrtimer_cancel(&op->timer);
+		} while (test_bit(TASKLET_STATE_SCHED, &op->tsklet.state) ||
+			 test_bit(TASKLET_STATE_RUN, &op->tsklet.state) ||
+			 hrtimer_active(&op->timer));
 	}
 
 	if (op->thrtsklet.func) {
-		while (test_bit(TASKLET_STATE_SCHED, &op->thrtsklet.state) ||
-		       test_bit(TASKLET_STATE_RUN, &op->thrtsklet.state) ||
-		       hrtimer_active(&op->thrtimer)) {
-			hrtimer_cancel(&op->thrtimer);
+		do {
 			tasklet_kill(&op->thrtsklet);
-		}
+			hrtimer_cancel(&op->thrtimer);
+		} while (test_bit(TASKLET_STATE_SCHED, &op->thrtsklet.state) ||
+			 test_bit(TASKLET_STATE_RUN, &op->thrtsklet.state) ||
+			 hrtimer_active(&op->thrtimer));
 	}
 
 	if ((op->frames) && (op->frames != &op->sframe))


