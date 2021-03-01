Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C038B328DC6
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:19:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241313AbhCATRC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:17:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:39806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241118AbhCATMl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:12:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 23B5464F9D;
        Mon,  1 Mar 2021 17:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619623;
        bh=YBeNgjHwdwehRAPWF0hr1fKR/0eYhMnIqTNljsrgS0Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VjWTrochrDGsxqf/bmJKJvZHK9Tmm2judJgfHY2bNLkldxy5kbOUfuQLlr0F78oe5
         rrS4NwA/k1osm6wpl6yr3YAXFrQutlcL8QnFifHJO/1YbyTC5si/TEX/Qhh5DCrirx
         jrRabsGTSH7Wj2OjSuUfme7JyaRYCUXPjX+T/NTA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andrey Grodzovsky <andrey.grodzovsky@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 5.10 520/663] drm/sched: Cancel and flush all outstanding jobs before finish.
Date:   Mon,  1 Mar 2021 17:12:48 +0100
Message-Id: <20210301161207.571795365@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
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
@@ -890,6 +890,9 @@ void drm_sched_fini(struct drm_gpu_sched
 	if (sched->thread)
 		kthread_stop(sched->thread);
 
+	/* Confirm no work left behind accessing device structures */
+	cancel_delayed_work_sync(&sched->work_tdr);
+
 	sched->ready = false;
 }
 EXPORT_SYMBOL(drm_sched_fini);


