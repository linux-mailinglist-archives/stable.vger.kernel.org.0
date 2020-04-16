Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6DB21AC840
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438828AbgDPPFq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:05:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:38666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408879AbgDPNwW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:52:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1B5820786;
        Thu, 16 Apr 2020 13:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045141;
        bh=YoydgxVY04JUElx6pTX1WVnIwMMo7Gnp01oStplhfd0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K4nsrnokAg3eHpck/mFD7+Q4lUAxmHUlemT6bf2JcIYuHhb/oKZSt7wyk6ZsfSc05
         f92n5SvcG4FR8+IDLSI9Q/L9QjOmNnIo4/recl4QF6oM8BL7LQOn8ZbzOxccTEd4fV
         68CxezYUGoYHfLGAViOCNSOe73lIf4zIrLKmOhnw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dafna Hirschfeld <dafna.hirschfeld@collabora.com>,
        Helen Koike <helen.koike@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 006/254] media: vimc: streamer: fix memory leak in vimc subdevs if kthread_run fails
Date:   Thu, 16 Apr 2020 15:21:35 +0200
Message-Id: <20200416131326.511984176@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
References: <20200416131325.804095985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dafna Hirschfeld <dafna.hirschfeld@collabora.com>

[ Upstream commit ceeb2e6166dddf3c9757abbbf84032027e2fa2d2 ]

In case kthread_run fails, the vimc subdevices
should be notified that streaming stopped so they can
release the memory for the streaming. Also, kthread should be
set to NULL.

Signed-off-by: Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
Acked-by: Helen Koike <helen.koike@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/vimc/vimc-streamer.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/vimc/vimc-streamer.c b/drivers/media/platform/vimc/vimc-streamer.c
index cd6b55433c9ee..43e494df61d88 100644
--- a/drivers/media/platform/vimc/vimc-streamer.c
+++ b/drivers/media/platform/vimc/vimc-streamer.c
@@ -207,8 +207,13 @@ int vimc_streamer_s_stream(struct vimc_stream *stream,
 		stream->kthread = kthread_run(vimc_streamer_thread, stream,
 					      "vimc-streamer thread");
 
-		if (IS_ERR(stream->kthread))
-			return PTR_ERR(stream->kthread);
+		if (IS_ERR(stream->kthread)) {
+			ret = PTR_ERR(stream->kthread);
+			dev_err(ved->dev, "kthread_run failed with %d\n", ret);
+			vimc_streamer_pipeline_terminate(stream);
+			stream->kthread = NULL;
+			return ret;
+		}
 
 	} else {
 		if (!stream->kthread)
-- 
2.20.1



