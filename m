Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B6083AEDF
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 08:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387728AbfFJGEA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jun 2019 02:04:00 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:45909 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387724AbfFJGEA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jun 2019 02:04:00 -0400
Received: by mail-pl1-f195.google.com with SMTP id bi6so2796694plb.12
        for <stable@vger.kernel.org>; Sun, 09 Jun 2019 23:04:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JwO2WB6asZ4mw8wReUIkxIzRzfIqL7feHMnNpkrKs9E=;
        b=j7wAb4MyjCnbfhgoqxwj2rSD2KcW8wXHMlwZ+9BbiO4m2PFkOuKRgE7ibilnX4ygIY
         hLWhjlZZwwQWqNH9sAzhV86bORHm8iqfS6E8xb1YYqvx6KKgxpJTcg3usgH+/Vu+HT3f
         mWwwGqCmbfMhm+mICctGBz5nBDxID7QJ6RETFEXJtK+nETDU3WuYMf2g//zrAhy9Qo0T
         gF1+bE+MV4rt0TWwU+oAlfvFX1mk2t8CC9BoItF3BDQlzWZwhIwpyv6Asc7xuMNexQ/4
         bK8Hhl8MKGDXCmbhtjlm6PSPESsc0O+xVQexgWZLd1QEXChJZMBn+UkJylWvZ1lUXIGM
         KDow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JwO2WB6asZ4mw8wReUIkxIzRzfIqL7feHMnNpkrKs9E=;
        b=fBLHJQ9X+51kAhnHRM3C4fmvpyCe1eD/wvR8l6cKBQ4ktchKNQUtWkZumzlPdxzGhW
         VfdehPK9NABUqqjTChU0y1AnVHse1SJjPyVJm6Pa0hzMRhcCEtVe9Jf9pXIS8hG2dZFg
         kJhQ8OKQdo4mismv7mdcj85rzUNwnq+DQGu3THlR77KEFgu1CEDAYttk/NZYyzHVm66C
         r0hDZq7/IrKJJpas8g8iMXp3bzUVedAs75EUPYgP/THEP0Mxa27I2wFNNgUqWr/y5K3Y
         w4yiJvQxzURediU/oDRIpJo/yVBzHUWSaCjAMEzaxKeo19O6TtbY/9+F29XinEieTKdt
         +zzA==
X-Gm-Message-State: APjAAAUns2c9Ec3QQ/yXhpt+nJDOOdDYS9ZeT3pSINxSt9mRSQ/aHcUY
        1VjbAPVGheBwTw5MBuVZaSVmc+jEUkW44L1wOKSuGqdZgGxSpA3/q1Qfk1i/9/UWiJ/avnpE79D
        2o9kWJSm+17UmQI2LKs8iNrUSyqcetLyRogXvaAtoDlFwP1fVeiusKm9T/W1XtROJaX5FOF3AiQ
        ==
X-Google-Smtp-Source: APXvYqyMfIkcs2BCORARZScdbx+/kr6UixjphG5xChEWqkw/Klto18jvTmk0E4YLnJhJDSDjCgFzDw==
X-Received: by 2002:a17:902:1c9:: with SMTP id b67mr21594632plb.333.1560146639398;
        Sun, 09 Jun 2019 23:03:59 -0700 (PDT)
Received: from localhost.localdomain (123-204-46-122.static.seed.net.tw. [123.204.46.122])
        by smtp.gmail.com with ESMTPSA id x17sm8914263pgk.72.2019.06.09.23.03.57
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 09 Jun 2019 23:03:58 -0700 (PDT)
From:   Jian-Hong Pan <jian-hong@endlessm.com>
To:     stable@vger.kernel.org
Cc:     linux@endlessm.com, hui.wang@canonical.com,
        Imre Deak <imre.deak@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Jian-Hong Pan <jian-hong@endlessm.com>
Subject: [PATCH stable-5.1 2/3] drm/i915: Remove redundant store of logical CDCLK state
Date:   Mon, 10 Jun 2019 14:01:42 +0800
Message-Id: <20190610060141.5377-3-jian-hong@endlessm.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190603100938.5414-1-jian-hong@endlessm.com>
References: <20190603100938.5414-1-jian-hong@endlessm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Imre Deak <imre.deak@intel.com>

commit 2b21dfbeee725778daed2c3dd45a3fc808176feb upstream.

We copied the original state into the atomic state already earlier in
the function, so no need to do it a second time.

Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190320135439.12201-3-imre.deak@intel.com
Cc: <stable@vger.kernel.org> # 5.1.x
Signed-off-by: Jian-Hong Pan <jian-hong@endlessm.com>
---
 drivers/gpu/drm/i915/intel_display.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index dd1a059cf850..aa16804687c2 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -12827,8 +12827,6 @@ static int intel_modeset_checks(struct drm_atomic_state *state)
 		DRM_DEBUG_KMS("New voltage level calculated to be logical %u, actual %u\n",
 			      intel_state->cdclk.logical.voltage_level,
 			      intel_state->cdclk.actual.voltage_level);
-	} else {
-		to_intel_atomic_state(state)->cdclk.logical = dev_priv->cdclk.logical;
 	}
 
 	intel_modeset_clear_plls(state);
-- 
2.22.0

