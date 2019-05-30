Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9901D2EFF3
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731495AbfE3DSQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:18:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:50450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729911AbfE3DSQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:18:16 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53A2F2478F;
        Thu, 30 May 2019 03:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186295;
        bh=Wa7TcyT+ufSchs5dR12KCtbsY23wB+eK/kdXfxO7PYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ic3IR/fvvcHLoDvU3OztIDqTr3HS4ctJ2efk3XokqMKDzfRo9jl6wsogu6m8WS2rT
         8+ZbBh2ud2CVmImL8SEhQLUM54GO1/707KZ9imTaHN7Pg4Fu8+GKuBFouSZpVzvGaN
         glGAELZI7YTnpKMQDVvPBTe6dBHEVD92AcnT8/uc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Helen Koike <helen.koike@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 256/276] media: vimc: stream: fix thread state before sleep
Date:   Wed, 29 May 2019 20:06:54 -0700
Message-Id: <20190530030541.173404684@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030523.133519668@linuxfoundation.org>
References: <20190530030523.133519668@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 2978a505aaa981b279ef359f74ba93d25098e0a0 ]

The state TASK_UNINTERRUPTIBLE should be set just before
schedule_timeout() call, so it knows the sleep mode it should enter.
There is no point in setting TASK_UNINTERRUPTIBLE at the initialization
of the thread as schedule_timeout() will set the state back to
TASK_RUNNING.

This fixes a warning in __might_sleep() call, as it's expecting the
task to be in TASK_RUNNING state just before changing the state to
a sleeping state.

Reported-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Helen Koike <helen.koike@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/vimc/vimc-streamer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/vimc/vimc-streamer.c b/drivers/media/platform/vimc/vimc-streamer.c
index fcc897fb247bc..392754c18046c 100644
--- a/drivers/media/platform/vimc/vimc-streamer.c
+++ b/drivers/media/platform/vimc/vimc-streamer.c
@@ -120,7 +120,6 @@ static int vimc_streamer_thread(void *data)
 	int i;
 
 	set_freezable();
-	set_current_state(TASK_UNINTERRUPTIBLE);
 
 	for (;;) {
 		try_to_freeze();
@@ -137,6 +136,7 @@ static int vimc_streamer_thread(void *data)
 				break;
 		}
 		//wait for 60hz
+		set_current_state(TASK_UNINTERRUPTIBLE);
 		schedule_timeout(HZ / 60);
 	}
 
-- 
2.20.1



