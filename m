Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA862793CD
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 23:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727459AbgIYVzh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 17:55:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726689AbgIYVzh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Sep 2020 17:55:37 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4BDEC0613CE
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 14:55:36 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id v23so3670612ljd.1
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 14:55:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IqWRtJXL3h+0YNOWDfr/oyE5XU2E5SGs9B5R12b/mYU=;
        b=smLOvcFFfth/d/eCeWfi6sPNLPRxKuTHjZl6Qa78IJFY39bb2+0XlYQLC/pEPb0S5f
         krWWfpXYbxD08VHxrcxWjPchRtbLuzebmEukSrshxr4xU4tX1dR3f82OTovIcu62v4qP
         g20pfMDZ8diisUnm+1Se1IT4VvLZ2kruNSpscC6of4431D4LgyhrDdtXJZYCE10wtpdt
         gxO0psNfOrRHtRtDqjM8ju1BdpYSQbTemoNMxpKvwnAofmyb1mB3SQUq2a4pcitvlfIv
         b+hARjlJum+osgCVbXdK/+NORGUg++RWT54fIlmgTwTdM1sxpO02quE75L1NTKySgjPZ
         KjOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=IqWRtJXL3h+0YNOWDfr/oyE5XU2E5SGs9B5R12b/mYU=;
        b=j2Z/cr0Kgbs6yEaCN7YGqBRlfGBYm/DUllfW8edZNhzKzwZSGGW3oliVHb3CxFUZJq
         JNy7mwh396kuRbc+uLuestZQt6vKZk4v0pqRxGX8QeXsx+Ue7Wz4zGu9maKn2apcRA9p
         iUd0PETS/S1Q4wWVEi3LITmpVp+KqN4x/WtnHKAOyRfhD8t8YCwto5myzeDbb62CpjbX
         oN5xdRPBFJPa+Lm1MIxESEwBGc+5aA57Iwyp+48yQgHgJtgPX21XL99sQNcqCcKXwQS+
         cWPlrueJEOrJb5EgY7fBWzTBaUZ14VCOA2xg+fLuN98VG7ps1vXVPm8+fa5LG2ccPJWm
         zyvw==
X-Gm-Message-State: AOAM532E9sMw+ls07rBoZVgXrrWwjEwLWIJtWxYNcF6bm4EXkXVrS83k
        1CSCJer1urcczaWWvSj3qrQ=
X-Google-Smtp-Source: ABdhPJwmQGAytj+dmXke/hXv+JGQ4Kg6h02qEjK+GXB10/h+Q3MdC1ggeZKjWovNpDVBdcczonRk5w==
X-Received: by 2002:a2e:90d6:: with SMTP id o22mr1769262ljg.442.1601070935198;
        Fri, 25 Sep 2020 14:55:35 -0700 (PDT)
Received: from saturn.localdomain ([2a00:fd00:805f:db00:3926:b59a:e618:9f9c])
        by smtp.gmail.com with ESMTPSA id j8sm261277lfr.80.2020.09.25.14.55.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 14:55:34 -0700 (PDT)
Sender: Sam Ravnborg <sam.ravnborg@gmail.com>
From:   Sam Ravnborg <sam@ravnborg.org>
To:     dri-devel@lists.freedesktop.org, Heiko Stuebner <heiko@sntech.de>,
        Thomas Zimmermann <tzimmermann@suse.de>
Cc:     Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org,
        Sandy Huang <hjc@rock-chips.com>, stable@vger.kernel.org,
        Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH v1 2/2] drm/rockchip: fix warning from cdn_dp_resume
Date:   Fri, 25 Sep 2020 23:55:24 +0200
Message-Id: <20200925215524.2899527-3-sam@ravnborg.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200925215524.2899527-1-sam@ravnborg.org>
References: <20200925215524.2899527-1-sam@ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 7c49abb4c2f8 ("drm/rockchip: cdn-dp-core: Make cdn_dp_core_suspend/resume static")
introduced the following warning in some builds:

cdn-dp-core.c:1124:12: warning: ‘cdn_dp_resume’ defined but not used
 1124 | static int cdn_dp_resume(struct device *dev)
      |            ^~~~~~~~~~~~~

Fix this by defining cdn_dp_resume __maybe_unused

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Fixes: 7c49abb4c2f8 ("drm/rockchip: cdn-dp-core: Make cdn_dp_core_suspend/resume static")
Cc: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Cc: Heiko Stuebner <heiko@sntech.de>
Cc: Sandy Huang <hjc@rock-chips.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-rockchip@lists.infradead.org
Cc: <stable@vger.kernel.org> # v5.8+
---
 drivers/gpu/drm/rockchip/cdn-dp-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/rockchip/cdn-dp-core.c b/drivers/gpu/drm/rockchip/cdn-dp-core.c
index a4a45daf93f2..1162e321aaed 100644
--- a/drivers/gpu/drm/rockchip/cdn-dp-core.c
+++ b/drivers/gpu/drm/rockchip/cdn-dp-core.c
@@ -1121,7 +1121,7 @@ static int cdn_dp_suspend(struct device *dev)
 	return ret;
 }
 
-static int cdn_dp_resume(struct device *dev)
+static int __maybe_unused cdn_dp_resume(struct device *dev)
 {
 	struct cdn_dp_device *dp = dev_get_drvdata(dev);
 
-- 
2.25.1

