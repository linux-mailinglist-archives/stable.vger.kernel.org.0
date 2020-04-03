Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A435219DFD5
	for <lists+stable@lfdr.de>; Fri,  3 Apr 2020 22:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728344AbgDCUvt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Apr 2020 16:51:49 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35881 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726368AbgDCUvt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Apr 2020 16:51:49 -0400
Received: by mail-wr1-f66.google.com with SMTP id k1so698162wrm.3;
        Fri, 03 Apr 2020 13:51:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4PywjeEUlJfhIhA45DrSAIjo99aXNCUjCyujBOC9psU=;
        b=SaOHk5lP3Kz6iO4J8i7k0c+ke5bsyK8od63PRGN1+k8WLbAZbnI/C2uVv9omWdI7YK
         OOaLDtNEiLsNjKZr6btwRBMaNF7pVpJhsI2TxBrafJNV8jGSrCTbzVeJLSAZmCy2fXdT
         X5dudJTS7Trd6HVxOJpXgcuDu6cLCvjzgSxtzlKiO2gUwqqzldsQI9JhsgrqXzwYSZTh
         MmBbq4/TgdYyMQ0ZamEN/fVzWsF0Y58gtq87/UJyxTN4NUnDQQp6gI8lJVrNrkIcBXbU
         hNsADOogPfBcdCfOQXxlV8d+c+uarVRtIJCOV7xW4wP79NZma9cc5q8/7Ue9coK8zsLx
         xEFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4PywjeEUlJfhIhA45DrSAIjo99aXNCUjCyujBOC9psU=;
        b=kKp+uXgZ78WFPz06mv3DC4sHalGoGbz5Z5204+g96dZYhXJQDbTwv92myUsQ887HpQ
         +QJRrZTvXXgzXlmopaqssgPhv+/cS9YAJXnMeTOcx9lcVp6QjHQOgNbuhyXzWUelJQbC
         +IOnjavyeeHuFuuuSvUcKzW9CI2SBuCp21l9JwQnLmW5UBHl2I3lWYAnnCaFgpzFlGGk
         RnTb4zKdN//uLGwY+FQwAhtd0h4p1cqYTfOCMYgpPLNxhI+sL9ZtX8FFw62U58pjezCC
         9dIrmZS/e2NigYhHPyefcLrhBgtDbq6E9EtKkapnEji9l9vx3d9tEzcauhjV3bY6G7ty
         s0Og==
X-Gm-Message-State: AGi0PubfJce5Cv0TKNNCs5E62og5bEvVzqTs/P9ozx3czz/RB8zSaL3l
        hmfsazqLb38z1hm44LZgRzE=
X-Google-Smtp-Source: APiQypK8znDXBlsXr5rob+lCHljMExi2W9qfZYxd28jH2SBn/+sltlwfPMWfacf7IgYNXuwiC85iHA==
X-Received: by 2002:a5d:5586:: with SMTP id i6mr8111632wrv.23.1585947106737;
        Fri, 03 Apr 2020 13:51:46 -0700 (PDT)
Received: from localhost.localdomain (p200300F13710ED00428D5CFFFEB99DB8.dip0.t-ipconnect.de. [2003:f1:3710:ed00:428d:5cff:feb9:9db8])
        by smtp.googlemail.com with ESMTPSA id d13sm13437570wrv.34.2020.04.03.13.51.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2020 13:51:45 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     rui.zhang@intel.com, daniel.lezcano@linaro.org,
        amit.kucheria@verdurent.com, linux-pm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, javi.merino@kernel.org,
        edubezval@gmail.com, orjan.eide@arm.com, tzimmermann@suse.de,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        stable@vger.kernel.org
Subject: [PATCH] thermal: devfreq_cooling: inline all stubs for CONFIG_DEVFREQ_THERMAL=n
Date:   Fri,  3 Apr 2020 22:51:33 +0200
Message-Id: <20200403205133.1101808-1-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When CONFIG_DEVFREQ_THERMAL is disabled all functions except
of_devfreq_cooling_register_power() were already inlined. Also inline
the last function to avoid compile errors when multiple drivers call
of_devfreq_cooling_register_power() when CONFIG_DEVFREQ_THERMAL is not
set. Compilation failed with the following message:
  multiple definition of `of_devfreq_cooling_register_power'
(which then lists all usages of of_devfreq_cooling_register_power())

Thomas Zimmermann reported this problem [0] on a kernel config with
CONFIG_DRM_LIMA={m,y}, CONFIG_DRM_PANFROST={m,y} and
CONFIG_DEVFREQ_THERMAL=n after both, the lima and panfrost drivers
gained devfreq cooling support.

[0] https://www.spinics.net/lists/dri-devel/msg252825.html

Fixes: a76caf55e5b356 ("thermal: Add devfreq cooling")
Cc: stable@vger.kernel.org
Reported-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 include/linux/devfreq_cooling.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/devfreq_cooling.h b/include/linux/devfreq_cooling.h
index 4635f95000a4..79a6e37a1d6f 100644
--- a/include/linux/devfreq_cooling.h
+++ b/include/linux/devfreq_cooling.h
@@ -75,7 +75,7 @@ void devfreq_cooling_unregister(struct thermal_cooling_device *dfc);
 
 #else /* !CONFIG_DEVFREQ_THERMAL */
 
-struct thermal_cooling_device *
+static inline struct thermal_cooling_device *
 of_devfreq_cooling_register_power(struct device_node *np, struct devfreq *df,
 				  struct devfreq_cooling_power *dfc_power)
 {
-- 
2.26.0

