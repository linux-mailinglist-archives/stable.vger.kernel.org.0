Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0534B2ABD3D
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:45:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730271AbgKINoV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:44:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:53440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730280AbgKIM7M (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 07:59:12 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5906207BC;
        Mon,  9 Nov 2020 12:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604926751;
        bh=c6ZbjUmV/UUZRLld6xYhdkt8nc2J1lzv9h2Hqv23haA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=izgLyIT82Byxyp7bydze225/F6yBj2OAGllkUW3y44eiraknQHru0pmFzED10YrIr
         0pFnCvw3QYnhRDxn4h4Z9JnhCzTZ9EMA1IKzgE+Ahpmk2f0C86Q05EfSr/SxBI2Rvi
         7on9KTYm/lK0z+uoBLxN/V42faGn4VEME87/RCjo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhihao Cheng <chengzhihao1@huawei.com>,
        syzbot+853639d0cb16c31c7a14@syzkaller.appspotmail.com,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 4.4 48/86] ubi: check kthread_should_stop() after the setting of task state
Date:   Mon,  9 Nov 2020 13:54:55 +0100
Message-Id: <20201109125023.136658656@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125020.852643676@linuxfoundation.org>
References: <20201109125020.852643676@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhihao Cheng <chengzhihao1@huawei.com>

commit d005f8c6588efcfbe88099b6edafc6f58c84a9c1 upstream.

A detach hung is possible when a race occurs between the detach process
and the ubi background thread. The following sequences outline the race:

  ubi thread: if (list_empty(&ubi->works)...

  ubi detach: set_bit(KTHREAD_SHOULD_STOP, &kthread->flags)
              => by kthread_stop()
              wake_up_process()
              => ubi thread is still running, so 0 is returned

  ubi thread: set_current_state(TASK_INTERRUPTIBLE)
              schedule()
              => ubi thread will never be scheduled again

  ubi detach: wait_for_completion()
              => hung task!

To fix that, we need to check kthread_should_stop() after we set the
task state, so the ubi thread will either see the stop bit and exit or
the task state is reset to runnable such that it isn't scheduled out
indefinitely.

Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Cc: <stable@vger.kernel.org>
Fixes: 801c135ce73d5df1ca ("UBI: Unsorted Block Images")
Reported-by: syzbot+853639d0cb16c31c7a14@syzkaller.appspotmail.com
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/ubi/wl.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -1460,6 +1460,19 @@ int ubi_thread(void *u)
 		    !ubi->thread_enabled || ubi_dbg_is_bgt_disabled(ubi)) {
 			set_current_state(TASK_INTERRUPTIBLE);
 			spin_unlock(&ubi->wl_lock);
+
+			/*
+			 * Check kthread_should_stop() after we set the task
+			 * state to guarantee that we either see the stop bit
+			 * and exit or the task state is reset to runnable such
+			 * that it's not scheduled out indefinitely and detects
+			 * the stop bit at kthread_should_stop().
+			 */
+			if (kthread_should_stop()) {
+				set_current_state(TASK_RUNNING);
+				break;
+			}
+
 			schedule();
 			continue;
 		}


