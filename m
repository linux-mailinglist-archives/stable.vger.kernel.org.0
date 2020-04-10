Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58C0B1A413C
	for <lists+stable@lfdr.de>; Fri, 10 Apr 2020 06:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728039AbgDJDsH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Apr 2020 23:48:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:59306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728026AbgDJDsH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Apr 2020 23:48:07 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CD8D2137B;
        Fri, 10 Apr 2020 03:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586490487;
        bh=YoydgxVY04JUElx6pTX1WVnIwMMo7Gnp01oStplhfd0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=umX94EActgL+MRzkXOPr6b2e9o6sUOS2uvFwdXcpSkHK4aYAcZYFEoTwijVPL3K6N
         oP6O2OODH+leialma88Hc+bVpa60oVpc9S7NXvckVvZpBha7djnQp+v+AnZ96159Tl
         lALL25ormbSKLE/PQ9vTbVXp0vzCmGpPb0Z1SB3A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dafna Hirschfeld <dafna.hirschfeld@collabora.com>,
        Helen Koike <helen.koike@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 05/56] media: vimc: streamer: fix memory leak in vimc subdevs if kthread_run fails
Date:   Thu,  9 Apr 2020 23:47:09 -0400
Message-Id: <20200410034800.8381-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200410034800.8381-1-sashal@kernel.org>
References: <20200410034800.8381-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

