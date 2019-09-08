Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F5B9ACA65
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 04:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbfIHCsO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Sep 2019 22:48:14 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:44711 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726749AbfIHCsO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Sep 2019 22:48:14 -0400
Received: by mail-pg1-f195.google.com with SMTP id i18so5686164pgl.11
        for <stable@vger.kernel.org>; Sat, 07 Sep 2019 19:48:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PophNlEimsQW360UTE3HQyearMFRv+hM8VNUZL4CMeI=;
        b=ZThJ03WFI8SPKxX6XqzhzHk60Cs0xzV68F3dRgBtre5sIeoFQNjo1b83wI4DqPX85V
         AMTRguTZwHUCxw/czq6CmQKaoF2lTXMEkOGIWfCgaIVwGoRfZLQIqJTeotRAslB7yHDw
         Qj8QsO2o6iWEbddFYukiai9xvaZBy0JLPYG8hQgzRBTKqfowfQxw8EiXDF+aFTOaeuvo
         TfZR9OHPZ6Le4UfK8NDuex+qxNVwajDFkmyfChdvOnPipi3NFohEIeBM/3iknRPF8GKc
         /Iy/abiy4b86t4DpdgLT6HFidS71gCdkwwsGUUjhqRKcIF/bGNXLFGdYkV2Y3HVeQlq1
         SCrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PophNlEimsQW360UTE3HQyearMFRv+hM8VNUZL4CMeI=;
        b=Ap17IFq2aak85zxOzG77CXrsPJ2XL8Lp5KGAOE6QbYgQASak+kr1C91+t/Wd3ox0ZB
         RJVxIPaUiIwHwzieFC/EH6WH2092wQNOTgH5uihzx26RLvSdxX2joeyqjlarl4ctikAR
         XgbZcVTMBxoThRq/uxCYnaH3PqaxW4i9jvvySbszBPKSa2afJwkzHe3y+AmkLE8avev3
         KHNfLWFD8qvbrN+qY9AtYhcTjfRAxT+HN+LGLCIvDUPvzLJvpfTThnkU9ThuYmktFcZ4
         oG2jwwvqBwG3UE3D+eiM5PR6R7s+xylpWDERYz5cjFSPp+ERoAdPCxorwnauTcG+S/RI
         YFCA==
X-Gm-Message-State: APjAAAWenXuEwHrtacKg83XbgcysXdWXgJwWWNMUrgFdJKvpkXzBS7e/
        GDKfmuQJEs7xeIYaimqUsjM=
X-Google-Smtp-Source: APXvYqwpjlSpKsw3qJDP3BhodT3Sfm86dXKHhTTDo6E1SqPbcCYLOndwf34ATa8oKEZuP0In7Ihi6g==
X-Received: by 2002:a63:2a87:: with SMTP id q129mr15507096pgq.101.1567910893480;
        Sat, 07 Sep 2019 19:48:13 -0700 (PDT)
Received: from anarsoul-thinkpad.lan (216-71-213-236.dyn.novuscom.net. [216.71.213.236])
        by smtp.gmail.com with ESMTPSA id u9sm10193930pjb.4.2019.09.07.19.48.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Sep 2019 19:48:13 -0700 (PDT)
From:   Vasily Khoruzhick <anarsoul@gmail.com>
To:     Qiang Yu <yuq825@gmail.com>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org, lima@lists.freedesktop.org
Cc:     Vasily Khoruzhick <anarsoul@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] drm/lima: fix lima_gem_wait() return value
Date:   Sat,  7 Sep 2019 19:48:00 -0700
Message-Id: <20190908024800.23229-1-anarsoul@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

drm_gem_reservation_object_wait() returns 0 if it succeeds and -ETIME
if it timeouts, but lima driver assumed that 0 is error.

Cc: stable@vger.kernel.org
Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
---
 drivers/gpu/drm/lima/lima_gem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/lima/lima_gem.c b/drivers/gpu/drm/lima/lima_gem.c
index 477c0f766663..b609dc030d6c 100644
--- a/drivers/gpu/drm/lima/lima_gem.c
+++ b/drivers/gpu/drm/lima/lima_gem.c
@@ -342,7 +342,7 @@ int lima_gem_wait(struct drm_file *file, u32 handle, u32 op, s64 timeout_ns)
 	timeout = drm_timeout_abs_to_jiffies(timeout_ns);
 
 	ret = drm_gem_reservation_object_wait(file, handle, write, timeout);
-	if (ret == 0)
+	if (ret == -ETIME)
 		ret = timeout ? -ETIMEDOUT : -EBUSY;
 
 	return ret;
-- 
2.23.0

