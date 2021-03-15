Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A2AB33B2D8
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 13:35:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbhCOMee (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 08:34:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbhCOMeL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Mar 2021 08:34:11 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0BC8C06175F
        for <stable@vger.kernel.org>; Mon, 15 Mar 2021 05:34:10 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id p8so65859881ejb.10
        for <stable@vger.kernel.org>; Mon, 15 Mar 2021 05:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1xoa3G+ISwKSIeuqcwnTgZqAGyqpi/mTiJ1R03k5mAc=;
        b=LVWU4ordRDJ4NugmIqMqf+p5Llh9f5FzvOIzFM4b15JxtT3XC0042nqDEoZatqLSoV
         JpFGPD0n2tJdGQDzDOGYjPBtfpFxAy5DMUzmjQ0cwHJn8jt9UCmSad/tFTVrJT4PZXCz
         LIaFZxddaQr9VAgYrOqJleg4s94tHuhXJS3m4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1xoa3G+ISwKSIeuqcwnTgZqAGyqpi/mTiJ1R03k5mAc=;
        b=YX5btKzhl/xhsLn6QDqXQQs/9V1hFT8Wl8wcKRpxkcpJ6PO28lCB/REL/K1rgfkZ0w
         Q3A1ssm+wKeH6rDLxwMryPK0/ipY8VupVoqQjzbYM5HXQDluP7/RMje3e5H4Oa92sjV8
         WeW7Y0fU8jNMq9zh29bhXYJx6nGZ+qlXLlibQda9yJbjXSE0PeRP/3RTdptBIBunLxXy
         n40vskJIQhr76jvihWY29ju9rdIdEvDWD4hgQvPKfUQmb35Z3WhzFdp4gdkPNSwf88Rs
         G95uydS3pB+oVVCyYWxRmnC1IdpNa0hWiYxuyX3yzyawXvNOe/u6WrWt4veHDoBNpeTA
         o6pg==
X-Gm-Message-State: AOAM532BvHKykaVZzar1I/KvopN6dWHompUfvSO8V/L0cCXiz+zMPGJv
        xAloYYY3yMJx2EVhizoRIR+znQ==
X-Google-Smtp-Source: ABdhPJxbz1uomQZnioarVABqV3L+IGQZFx3lXkxNbJZJrcgnEuUdljiCLjtxg/f6IbAHcTmWTaan+A==
X-Received: by 2002:a17:906:380b:: with SMTP id v11mr23826856ejc.183.1615811649657;
        Mon, 15 Mar 2021 05:34:09 -0700 (PDT)
Received: from alco.lan ([80.71.134.83])
        by smtp.gmail.com with ESMTPSA id p3sm7155128ejd.7.2021.03.15.05.34.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 05:34:09 -0700 (PDT)
From:   Ricardo Ribalda <ribalda@chromium.org>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Bingbu Cao <bingbu.cao@intel.com>,
        Tianshu Qiu <tian.shu.qiu@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc:     Ricardo Ribalda <ribalda@chromium.org>, stable@vger.kernel.org
Subject: [PATCH v2 1/2] media: staging/intel-ipu3: Fix memory leak in imu_fmt
Date:   Mon, 15 Mar 2021 13:34:05 +0100
Message-Id: <20210315123406.1523607-1-ribalda@chromium.org>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We are losing the reference to an allocated memory if try. Change the
order of the check to avoid that.

Cc: stable@vger.kernel.org
Fixes: 6d5f26f2e045 ("media: staging/intel-ipu3-v4l: reduce kernel stack usage")
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
---
 drivers/staging/media/ipu3/ipu3-v4l2.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/ipu3/ipu3-v4l2.c b/drivers/staging/media/ipu3/ipu3-v4l2.c
index 60aa02eb7d2a..35a74d99322f 100644
--- a/drivers/staging/media/ipu3/ipu3-v4l2.c
+++ b/drivers/staging/media/ipu3/ipu3-v4l2.c
@@ -693,6 +693,13 @@ static int imgu_fmt(struct imgu_device *imgu, unsigned int pipe, int node,
 		if (inode == IMGU_NODE_STAT_3A || inode == IMGU_NODE_PARAMS)
 			continue;
 
+		/* CSS expects some format on OUT queue */
+		if (i != IPU3_CSS_QUEUE_OUT &&
+		    !imgu_pipe->nodes[inode].enabled) {
+			fmts[i] = NULL;
+			continue;
+		}
+
 		if (try) {
 			fmts[i] = kmemdup(&imgu_pipe->nodes[inode].vdev_fmt.fmt.pix_mp,
 					  sizeof(struct v4l2_pix_format_mplane),
@@ -705,10 +712,6 @@ static int imgu_fmt(struct imgu_device *imgu, unsigned int pipe, int node,
 			fmts[i] = &imgu_pipe->nodes[inode].vdev_fmt.fmt.pix_mp;
 		}
 
-		/* CSS expects some format on OUT queue */
-		if (i != IPU3_CSS_QUEUE_OUT &&
-		    !imgu_pipe->nodes[inode].enabled)
-			fmts[i] = NULL;
 	}
 
 	if (!try) {
-- 
2.31.0.rc2.261.g7f71774620-goog

