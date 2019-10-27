Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0E66E67A3
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:23:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731587AbfJ0VWx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:22:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:43954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732245AbfJ0VWw (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:22:52 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D06F205C9;
        Sun, 27 Oct 2019 21:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211371;
        bh=d7BXlQMeshVMcQHLgh1CG8CHXyxlJSuwgcNotI58I5c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yjis6Ax6qCzquvNJTrwXm4zHL2t1p8NXeGB7TcdoxtdSUidu85Zl3viI6Fh3S9Lnj
         jO7dJTjmdOEtbEtmm89TfUYu+RRhTvrjm30f3e+lz/GY8UE7qUeAxh2ZTUyk7d8DiS
         daidl9dg5UqR61F+sB0/0ogQCrzyjyOQffIgDZIc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Neil Armstrong <narmstrong@baylibre.com>,
        Steven Price <steven.price@arm.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH 5.3 126/197] drm/panfrost: Handle resetting on timeout better
Date:   Sun, 27 Oct 2019 22:00:44 +0100
Message-Id: <20191027203358.534250985@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Price <steven.price@arm.com>

commit 5b3ec8134f5f9fa1ed0a538441a495521078bbee upstream.

Panfrost uses multiple schedulers (one for each slot, so 2 in reality),
and on a timeout has to stop all the schedulers to safely perform a
reset. However more than one scheduler can trigger a timeout at the same
time. This race condition results in jobs being freed while they are
still in use.

When stopping other slots use cancel_delayed_work_sync() to ensure that
any timeout started for that slot has completed. Also use
mutex_trylock() to obtain reset_lock. This means that only one thread
attempts the reset, the other threads will simply complete without doing
anything (the first thread will wait for this in the call to
cancel_delayed_work_sync()).

While we're here and since the function is already dependent on
sched_job not being NULL, let's remove the unnecessary checks.

Fixes: aa20236784ab ("drm/panfrost: Prevent concurrent resets")
Tested-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Cc: stable@vger.kernel.org
Signed-off-by: Rob Herring <robh@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20191009094456.9704-1-steven.price@arm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/panfrost/panfrost_job.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/panfrost/panfrost_job.c
+++ b/drivers/gpu/drm/panfrost/panfrost_job.c
@@ -384,13 +384,19 @@ static void panfrost_job_timedout(struct
 		job_read(pfdev, JS_TAIL_LO(js)),
 		sched_job);
 
-	mutex_lock(&pfdev->reset_lock);
+	if (!mutex_trylock(&pfdev->reset_lock))
+		return;
 
-	for (i = 0; i < NUM_JOB_SLOTS; i++)
-		drm_sched_stop(&pfdev->js->queue[i].sched, sched_job);
+	for (i = 0; i < NUM_JOB_SLOTS; i++) {
+		struct drm_gpu_scheduler *sched = &pfdev->js->queue[i].sched;
 
-	if (sched_job)
-		drm_sched_increase_karma(sched_job);
+		drm_sched_stop(sched, sched_job);
+		if (js != i)
+			/* Ensure any timeouts on other slots have finished */
+			cancel_delayed_work_sync(&sched->work_tdr);
+	}
+
+	drm_sched_increase_karma(sched_job);
 
 	/* panfrost_core_dump(pfdev); */
 


