Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7996C20421D
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 22:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728553AbgFVUp4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 16:45:56 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:41695 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728490AbgFVUp4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jun 2020 16:45:56 -0400
Received: by mail-lj1-f196.google.com with SMTP id 9so20939820ljc.8;
        Mon, 22 Jun 2020 13:45:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vLDSApuJ0v81hqVWKGC7U58iC5Y/D0ks2PXVy/bBVsQ=;
        b=FiYtyG5untV4L2JXWPRu6KC0XcsQkGXsgN0+mJrmDW1FxdFAv0PKHylmeCL/D3bnqv
         OEIODFq7l3xIq/4Lppb94Qa0mUchDq3RVFUCtEL3x1obpntPHVPkKvW1VXY0zsnbpXn5
         Q2sJz8ySSRnM5iD5IlS4SkB/bXIq2E4NI2Vx1idcfDfMsyeTRMwhKp4KF3KljL42XJ70
         VBW/riOUPO20fZ9CSPil3YYisGuWCwVff4wuNgLcKPZfQ/0WOQcvE/Vuw7TbxFMvAeEk
         4omYbj8CRWw+HpdOr/WHct7oojzspZN16u6xFfbUp/AHjZrQ+kItA+SvYnpZS/W35G61
         U3xg==
X-Gm-Message-State: AOAM531qZSZQSJkDpm414j2SpCBfvKNW8s7F4SKRpDjhLrr9Js9QmzSi
        +/L6OEEAvRMqRxSmHbOdJDA=
X-Google-Smtp-Source: ABdhPJwzB6UHwxJ1YrbwAUcm9GmVOZcbiVSJ0aSHpBEom2b+5l+RnXEAmCW0zZ8jMyLXZ9LGfBSzcA==
X-Received: by 2002:a2e:96cd:: with SMTP id d13mr9076836ljj.251.1592858753330;
        Mon, 22 Jun 2020 13:45:53 -0700 (PDT)
Received: from localhost.localdomain (broadband-37-110-38-130.ip.moscow.rt.ru. [37.110.38.130])
        by smtp.googlemail.com with ESMTPSA id j18sm3691359lfj.68.2020.06.22.13.45.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 13:45:52 -0700 (PDT)
From:   Denis Efremov <efremov@linux.com>
To:     Alan Cox <alan@linux.intel.com>,
        Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>
Cc:     Denis Efremov <efremov@linux.com>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] drm/gma500: Fix direction check in psb_accel_2d_copy()
Date:   Mon, 22 Jun 2020 23:45:37 +0300
Message-Id: <20200622204537.26792-1-efremov@linux.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

psb_accel_2d_copy() checks direction PSB_2D_COPYORDER_BR2TL twice.
Based on psb_accel_2d_copy_direction() results, PSB_2D_COPYORDER_TL2BR
should be checked instead in the second direction check.

Fixes: 4d8d096e9ae8 ("gma500: introduce the framebuffer support code")
Cc: stable@vger.kernel.org
Signed-off-by: Denis Efremov <efremov@linux.com>
---
 drivers/gpu/drm/gma500/accel_2d.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/gma500/accel_2d.c b/drivers/gpu/drm/gma500/accel_2d.c
index adc0507545bf..8dc86aac54d2 100644
--- a/drivers/gpu/drm/gma500/accel_2d.c
+++ b/drivers/gpu/drm/gma500/accel_2d.c
@@ -179,8 +179,8 @@ static int psb_accel_2d_copy(struct drm_psb_private *dev_priv,
 		src_x += size_x - 1;
 		dst_x += size_x - 1;
 	}
-	if (direction == PSB_2D_COPYORDER_BR2TL ||
-	    direction == PSB_2D_COPYORDER_BL2TR) {
+	if (direction == PSB_2D_COPYORDER_BL2TR ||
+	    direction == PSB_2D_COPYORDER_TL2BR) {
 		src_y += size_y - 1;
 		dst_y += size_y - 1;
 	}
-- 
2.26.2

