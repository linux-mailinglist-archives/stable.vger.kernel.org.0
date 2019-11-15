Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37331FE7EC
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 23:34:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727509AbfKOWec (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 17:34:32 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:38428 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727421AbfKOWeP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Nov 2019 17:34:15 -0500
Received: by mail-pl1-f196.google.com with SMTP id q18so1926518pls.5
        for <stable@vger.kernel.org>; Fri, 15 Nov 2019 14:34:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=r1ouRyNa+k6U3bqzEPdoAfpCVsnWSnRUjkxZ+vQnSI0=;
        b=AkA2Dg+SrHTn4/EJ8QynEGN7oPoQ/Aw5fRHMyXpEW6Y6keS6gO6VdGp+FDJ81HaCck
         LfkmYzBp8QrNwaymjk9ee0qPdxlC88qX2CcJuOT+KoHhzb0ptMpflS2O2yk9g1xcwj+i
         OsUJI152IuEDboSfUp+G5xjZAwG1t7A0XU/A7qB4I1ptcuIK1x3v8NMEcAQoZZq4bi4E
         Be+sv3Xu57IO52n36rJiyMgg2w2e6EQhjAwLZeheDCHSoe140YiXAwaGdpXT8hHFrlti
         FWcDYu761P26xKgxM27ycYqxbciEuu1T6zlil6sWl1pcyhuIHyDlPl4vUH/r7fLTJUmm
         52MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=r1ouRyNa+k6U3bqzEPdoAfpCVsnWSnRUjkxZ+vQnSI0=;
        b=C3fxECH1kFd807UNa0MjhtZq4tUlVBF0tXC3aO70FjOW97q0gp/BTnq+9t4S/u+vaS
         VmxJqpApcUYDOvktKJzUYR80CHTCLFzTinsX7B9iblxbsRO/XMb38/WRC0LOmRcWILuw
         SMEySDDfmLp15puJYI8+9e2162u3upPVF6zlqiL0rhNZunDPW6AqBz9kwuD4NgLSZVEl
         5G4w4TizEjOrG3z+MMNFSJgKkvTaUEmkwYkIuJDPd8pv8YWmEJz8bsWrZ7RZ6NuiCp5k
         VZ6w5pfViW+hkXlVPSrmjoiF29SPLRg9jtHa6IHjaxwnnytF9kAfjJLPKG8tOY4pTU4C
         YK6g==
X-Gm-Message-State: APjAAAWjxGg4q6VKuZT0WcsEPCQcfXfR0HVQFX+spSP5lkWcm9maHuRq
        c74r4DY15EVylX5HsBhpS1J9uHF0Pao=
X-Google-Smtp-Source: APXvYqxC58jH+YVSM8IOmV0kV1VyZBdQVm7yePJM+Y2/BxjPAGsb3xhTH2/dY5iUX2I2iGcgQm94xQ==
X-Received: by 2002:a17:90a:9705:: with SMTP id x5mr22110495pjo.37.1573857254692;
        Fri, 15 Nov 2019 14:34:14 -0800 (PST)
Received: from xps15.cg.shawcable.net (S0106002369de4dac.cg.shawcable.net. [68.147.8.254])
        by smtp.gmail.com with ESMTPSA id m15sm11699724pfh.19.2019.11.15.14.34.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2019 14:34:14 -0800 (PST)
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [stable 4.19+][PATCH 19/20] media: ov5640: fix framerate update
Date:   Fri, 15 Nov 2019 15:33:55 -0700
Message-Id: <20191115223356.27675-19-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191115223356.27675-1-mathieu.poirier@linaro.org>
References: <20191115223356.27675-1-mathieu.poirier@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hugues Fruchet <hugues.fruchet@st.com>

commit 0929983e49c81c1d413702cd9b83bb06c4a2555c upstream

Changing framerate right before streamon had no effect,
the new framerate value was taken into account only at
next streamon, fix this.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: stable <stable@vger.kernel.org> # 4.19+
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/media/i2c/ov5640.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index a3bbef682fb8..2023df14f828 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -2572,8 +2572,6 @@ static int ov5640_s_frame_interval(struct v4l2_subdev *sd,
 	if (frame_rate < 0)
 		frame_rate = OV5640_15_FPS;
 
-	sensor->current_fr = frame_rate;
-	sensor->frame_interval = fi->interval;
 	mode = ov5640_find_mode(sensor, frame_rate, mode->hact,
 				mode->vact, true);
 	if (!mode) {
@@ -2581,7 +2579,10 @@ static int ov5640_s_frame_interval(struct v4l2_subdev *sd,
 		goto out;
 	}
 
-	if (mode != sensor->current_mode) {
+	if (mode != sensor->current_mode ||
+	    frame_rate != sensor->current_fr) {
+		sensor->current_fr = frame_rate;
+		sensor->frame_interval = fi->interval;
 		sensor->current_mode = mode;
 		sensor->pending_mode_change = true;
 	}
-- 
2.17.1

