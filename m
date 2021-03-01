Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7FF328978
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:01:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238033AbhCAR5V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:57:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:46488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238946AbhCARvj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:51:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ACC6964FDA;
        Mon,  1 Mar 2021 17:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618045;
        bh=mNvZB5Na4/6JvTEjit3tW/BBoqsMvw8szxrMziu7KXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RnV2PcouNnP2U93JkFWnC3yuldZrSGzjSwMi7eo78nzNi6pCg0TCOxcwg2wQfSI5s
         iTDkijL287TdpY50CPPddCgXwimdXlYLVklBLPP9dLAKoxGrk+D7WbstcjdkH4g65b
         DXXjpcp7G0pCcc5utgMpRV6SwMXiiVw99D61hToU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andrey Grodzovsky <andrey.grodzovsky@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 5.4 260/340] drm/sched: Cancel and flush all outstanding jobs before finish.
Date:   Mon,  1 Mar 2021 17:13:24 +0100
Message-Id: <20210301161101.099905354@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Grodzovsky <andrey.grodzovsky@amd.com>

commit e582951baabba3e278c97169d0acc1e09b24a72e upstream.

To avoid any possible use after free.

Signed-off-by: Andrey Grodzovsky <andrey.grodzovsky@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Link: https://patchwork.freedesktop.org/patch/414814/
CC: stable@vger.kernel.org
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/scheduler/sched_main.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/scheduler/sched_main.c
+++ b/drivers/gpu/drm/scheduler/sched_main.c
@@ -851,6 +851,9 @@ void drm_sched_fini(struct drm_gpu_sched
 	if (sched->thread)
 		kthread_stop(sched->thread);
 
+	/* Confirm no work left behind accessing device structures */
+	cancel_delayed_work_sync(&sched->work_tdr);
+
 	sched->ready = false;
 }
 EXPORT_SYMBOL(drm_sched_fini);


