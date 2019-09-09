Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86DB5AD5F1
	for <lists+stable@lfdr.de>; Mon,  9 Sep 2019 11:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725818AbfIIJoL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Sep 2019 05:44:11 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:39187 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729002AbfIIJoL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Sep 2019 05:44:11 -0400
Received: by mail-pf1-f196.google.com with SMTP id s12so8807094pfe.6;
        Mon, 09 Sep 2019 02:44:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=RVGpRwzhtsGvMd7+S5VBrhtTe9dSDMJHokV5tk4DbvM=;
        b=YSTDDaCcMGVNeH6irMMk5SF8Leo6aG52QLv9H1uBnqWVIurgNOnljQ7JX8DMWNUjEt
         UJm82yxhZxi/McDEYnMTh+pft65xlnlPb1WQcOg+QJzgbUqNLQUeS+H1d0JIyifvVf43
         ix61vuvZYiliGp/w2HLhhLGcrh3fvgMRw8aTkB8N75l6hM/6r0vOwUKDytabA4iTXCrn
         tewqkOldJEKPbBnic124hEuy1zl1YccAD96Y2ixyO1ZtO3xz092blGwEdsb1M/fMR5lI
         ZqaZF+/okDml6NkezwZnw+mZlAue9QDEejESYIvq7VRHPcNOSxW6iaYVxTj4S651rc6k
         1ZZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=RVGpRwzhtsGvMd7+S5VBrhtTe9dSDMJHokV5tk4DbvM=;
        b=rmqzjnaAZ5pDspAg6++jtWeASL87mk3Q/WFODvpBlgWHz/O1EhoPrJpluPVQHjaBrY
         1OJPCsLyn74PBZOCGHRj+sijflSz/N5ioDKhIHTs8Ubf5f0kzus7aUtNU+KGqX7rWVun
         +TbvkeRIy41RpGr3EnDZSta/Hyc7ru+W/fnJ9g9h83IoqxPf6rrcteZQs6O3SsmMAO51
         rPvHKNGliqYVi7fz+JAMVIEjEWhxwAsJlngNfgn/ebELQo1LF89FpbB+p3bG9d3j/PId
         OWB0VHgKxRFZ0VK5Ag8jnqTtSUaCpyQSjKjYsn6IpLxV5CWiaaf3+XdUYRnp3nZhVWPt
         37cw==
X-Gm-Message-State: APjAAAW3FJw2noXyrP55Ydl0pGvrGbAe2EVdMAiw/N3y8Mew/GEufBMJ
        vTlMlvMCrI5o2sP+YacXC9CGEufhSqs=
X-Google-Smtp-Source: APXvYqwcgGDxll7rpTbEgCCe8cQt1TUqQ1V+uucBID6NwO87YKtmrL+LmJH5AVOsI8ca3ybss5J6Zg==
X-Received: by 2002:a65:68cd:: with SMTP id k13mr20771939pgt.411.1568022250404;
        Mon, 09 Sep 2019 02:44:10 -0700 (PDT)
Received: from bnva-HP-Pavilion-g6-Notebook-PC.domain.name ([117.248.67.24])
        by smtp.gmail.com with ESMTPSA id x8sm13975955pfm.35.2019.09.09.02.44.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Sep 2019 02:44:09 -0700 (PDT)
From:   Vandana BN <bnvandana@gmail.com>
To:     linux-media@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Cc:     hverkuil@xs4all.nl, Vandana BN <bnvandana@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH v2] vivid: Set vid_cap_streaming and vid_out_streaming to true
Date:   Mon,  9 Sep 2019 15:13:31 +0530
Message-Id: <20190909094331.7809-1-bnvandana@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <841cf7a9-2e5f-17c8-1595-56c911b7f35d@xs4all.nl>
References: <841cf7a9-2e5f-17c8-1595-56c911b7f35d@xs4all.nl>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When vbi stream is started, followed by video streaming,
the vid_cap_streaming and vid_out_streaming were not being set to true,
which would cause the video stream to stop when vbi stream is stopped.
This patch allows to set vid_cap_streaming and vid_out_streaming to true.
According to Hans Verkuil it appears that these 'if (dev->kthread_vid_cap)'
checks are a left-over from the original vivid development and should never
have been there.

Signed-off-by: Vandana BN <bnvandana@gmail.com>
Cc: <stable@vger.kernel.org>      # for v3.18 and up
---
 drivers/media/platform/vivid/vivid-vid-cap.c | 3 ---
 drivers/media/platform/vivid/vivid-vid-out.c | 3 ---
 2 files changed, 6 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index 8cbaa0c998ed..2d030732feac 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -223,9 +223,6 @@ static int vid_cap_start_streaming(struct vb2_queue *vq, unsigned count)
 	if (vb2_is_streaming(&dev->vb_vid_out_q))
 		dev->can_loop_video = vivid_vid_can_loop(dev);
 
-	if (dev->kthread_vid_cap)
-		return 0;
-
 	dev->vid_cap_seq_count = 0;
 	dprintk(dev, 1, "%s\n", __func__);
 	for (i = 0; i < VIDEO_MAX_FRAME; i++)
diff --git a/drivers/media/platform/vivid/vivid-vid-out.c b/drivers/media/platform/vivid/vivid-vid-out.c
index 148b663a6075..a0364ac497f9 100644
--- a/drivers/media/platform/vivid/vivid-vid-out.c
+++ b/drivers/media/platform/vivid/vivid-vid-out.c
@@ -161,9 +161,6 @@ static int vid_out_start_streaming(struct vb2_queue *vq, unsigned count)
 	if (vb2_is_streaming(&dev->vb_vid_cap_q))
 		dev->can_loop_video = vivid_vid_can_loop(dev);
 
-	if (dev->kthread_vid_out)
-		return 0;
-
 	dev->vid_out_seq_count = 0;
 	dprintk(dev, 1, "%s\n", __func__);
 	if (dev->start_streaming_error) {
-- 
2.17.1

