Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4D931C4433
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 20:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731219AbgEDSFI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 14:05:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:34790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731773AbgEDSFH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 14:05:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C92D2075A;
        Mon,  4 May 2020 18:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615506;
        bh=W7UAXwWN98Y7sZvTBZNeOKlsGspGEzBV6VrCaOG4pXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EqhFFbmpE5tx5Ij+mENJbTJoodQAoIMGl3eG54Q/Zk0OETw+4v7gGaTtUMWzK/S3u
         o1GTbKEurkm0Y3uMS9pyNTBeV8nbHxXBWvyc8fOspSnsxmasFEkhZe1csfW70T5F1d
         F5LQFj2D+djel2ND4M7XkbCR1eQeA77Nqi3VV2eo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Andrey Grodzovsky <andrey.grodzovsky@amd.com>,
        Kent Russell <kent.russell@amd.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.6 01/73] drm/scheduler: fix drm_sched_get_cleanup_job
Date:   Mon,  4 May 2020 19:57:04 +0200
Message-Id: <20200504165501.981305028@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504165501.781878940@linuxfoundation.org>
References: <20200504165501.781878940@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian König <christian.koenig@amd.com>

commit 8623b5255ae7ccaf276aac3920787bf575fa6b37 upstream.

We are racing to initialize sched->thread here, just always check the
current thread.

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Andrey Grodzovsky <andrey.grodzovsky@amd.com>
Reviewed-by: Kent Russell <kent.russell@amd.com>
Link: https://patchwork.freedesktop.org/patch/361303/
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/scheduler/sched_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/scheduler/sched_main.c
+++ b/drivers/gpu/drm/scheduler/sched_main.c
@@ -687,7 +687,7 @@ drm_sched_get_cleanup_job(struct drm_gpu
 	 */
 	if ((sched->timeout != MAX_SCHEDULE_TIMEOUT &&
 	    !cancel_delayed_work(&sched->work_tdr)) ||
-	    __kthread_should_park(sched->thread))
+	    kthread_should_park())
 		return NULL;
 
 	spin_lock_irqsave(&sched->job_list_lock, flags);


