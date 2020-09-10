Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6358F282A53
	for <lists+stable@lfdr.de>; Sun,  4 Oct 2020 13:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725949AbgJDLA7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Oct 2020 07:00:59 -0400
Received: from www.linuxtv.org ([130.149.80.248]:58512 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725825AbgJDLA7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Oct 2020 07:00:59 -0400
X-Greylist: delayed 2477 seconds by postgrey-1.27 at vger.kernel.org; Sun, 04 Oct 2020 07:00:58 EDT
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1kP10r-001oDD-AV; Sun, 04 Oct 2020 10:13:05 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Thu, 10 Sep 2020 12:05:10 +0000
Subject: [git:media_tree/master] media: cec-adap.c: don't use flush_scheduled_work()
To:     linuxtv-commits@linuxtv.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>, stable@vger.kernel.org
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1kP10r-001oDD-AV@www.linuxtv.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: cec-adap.c: don't use flush_scheduled_work()
Author:  Hans Verkuil <hverkuil-cisco@xs4all.nl>
Date:    Tue Sep 8 12:02:53 2020 +0200

For some inexplicable reason I decided to call flush_scheduled_work()
instead of cancel_delayed_work_sync(). The problem with that is that
flush_scheduled_work() waits for *all* queued scheduled work to be
completed instead of just the work itself.

This can cause a deadlock if a CEC driver also schedules work that
takes the same lock. See the comments for flush_scheduled_work() in
linux/workqueue.h.

This is exactly what has been observed a few times.

This patch simply replaces flush_scheduled_work() by
cancel_delayed_work_sync().

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc: <stable@vger.kernel.org>      # for v5.8 and up
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/media/cec/core/cec-adap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

diff --git a/drivers/media/cec/core/cec-adap.c b/drivers/media/cec/core/cec-adap.c
index 4efe8014445e..926d65db6d3e 100644
--- a/drivers/media/cec/core/cec-adap.c
+++ b/drivers/media/cec/core/cec-adap.c
@@ -1199,7 +1199,7 @@ void cec_received_msg_ts(struct cec_adapter *adap,
 			/* Cancel the pending timeout work */
 			if (!cancel_delayed_work(&data->work)) {
 				mutex_unlock(&adap->lock);
-				flush_scheduled_work();
+				cancel_delayed_work_sync(&data->work);
 				mutex_lock(&adap->lock);
 			}
 			/*
