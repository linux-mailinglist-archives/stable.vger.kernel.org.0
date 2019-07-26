Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 268CC7645A
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 13:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726004AbfGZL1u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 07:27:50 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:41609 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726302AbfGZL1s (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jul 2019 07:27:48 -0400
Received: by mail-lf1-f66.google.com with SMTP id 62so31971915lfa.8
        for <stable@vger.kernel.org>; Fri, 26 Jul 2019 04:27:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tkrBq1SnQkOBmUfMH8XCY0QYWm6lQdUCAmJmwMI79D0=;
        b=M1iiTajuphNdCuVUNMETkotkLA2uwCvt8+fc0HhCeN8FY+jFkztC4vtaGleozZsjp0
         6RMNu1DG/drs0/txBSzX43RNK90A7jWVLQKj7569hfsTDoGateqOXe1wyVw2ycSt2flz
         WQE50mSYm5i94JOt4yAmI7YS+QcvOophZcWXbxWG5SMmo6KvALzHHE/IkQL/6c4yP81B
         RIPsLIdqUHaX33s/nJ46/ywpe+27JJ3KnbewYtlEdXxprzRmSC8RwalTuBTXMkecFgst
         ogj0phHtXMzsMPeheYDnkX5vAAIX2ZSvetV6x7plm+lhzWJymY3iXk8EpWfyRmHC/sI5
         JVRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tkrBq1SnQkOBmUfMH8XCY0QYWm6lQdUCAmJmwMI79D0=;
        b=MrSAgUncFih75z1T47lf1JbR4ncSyRmzWa/7G059q4FTyIpKycmXCOzjQ6VSWDRH3f
         JKtTEO7Y/shMr+yO9XSqEsRV46y+2n0FwY3HDWztKlr3GTsYzDvjCFjc+G39a2Vx0g7/
         ndASbD0XmNekAFxUxYdcGbnGumO25ECaSmrtXjhQ05d9iubEu8JSxJUW/+8TqGjLvr24
         fp0NUdd4eQ+oR6LRz+4dM+HeayuPxBgulT4GkPeNoITcdqhX+58KeRosQk3prYDLuDsx
         abvZEK6FHeiKFmJZ7XyI2tIdzW5hIfEh3qxoClSdqlc69GcwgaOZ9wgbfFSpB5l1z7p/
         M7Sw==
X-Gm-Message-State: APjAAAWKa8gB+1drvwsfASKrYkK4YctoEABh5UWvZQ1jIqOcwM+1cgsp
        MfRkTYWdLNZXDqefVfOec2c75A==
X-Google-Smtp-Source: APXvYqymqL8+0NGle9LgsNo7cZJpanm/SQJZbXSjQtqaniNF93z4a6wOvybY0QrHQE3O8e+4n1Fo6A==
X-Received: by 2002:ac2:5b09:: with SMTP id v9mr6868915lfn.22.1564140466048;
        Fri, 26 Jul 2019 04:27:46 -0700 (PDT)
Received: from localhost (c-243c70d5.07-21-73746f28.bbcust.telenor.se. [213.112.60.36])
        by smtp.gmail.com with ESMTPSA id u17sm8391919lfq.69.2019.07.26.04.27.45
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 26 Jul 2019 04:27:45 -0700 (PDT)
From:   Anders Roxell <anders.roxell@linaro.org>
To:     airlied@linux.ie, daniel@ffwll.ch
Cc:     dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Anders Roxell <anders.roxell@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH] drm: mali-dp: Mark expected switch fall-through
Date:   Fri, 26 Jul 2019 13:27:41 +0200
Message-Id: <20190726112741.19360-1-anders.roxell@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When fall-through warnings was enabled by default, commit d93512ef0f0e
("Makefile: Globally enable fall-through warning"), the following
warnings was starting to show up:

../drivers/gpu/drm/arm/malidp_hw.c: In function ‘malidp_format_get_bpp’:
../drivers/gpu/drm/arm/malidp_hw.c:387:8: warning: this statement may fall
 through [-Wimplicit-fallthrough=]
    bpp = 30;
    ~~~~^~~~
../drivers/gpu/drm/arm/malidp_hw.c:388:3: note: here
   case DRM_FORMAT_YUV420_10BIT:
   ^~~~
../drivers/gpu/drm/arm/malidp_hw.c: In function ‘malidp_se_irq’:
../drivers/gpu/drm/arm/malidp_hw.c:1311:4: warning: this statement may fall
 through [-Wimplicit-fallthrough=]
    drm_writeback_signal_completion(&malidp->mw_connector, 0);
    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
../drivers/gpu/drm/arm/malidp_hw.c:1313:3: note: here
   case MW_START:
   ^~~~

Rework to add a 'break;' in a case that didn't have it so that
the compiler doesn't warn about fall-through.

Cc: stable@vger.kernel.org # v4.9+
Fixes: b8207562abdd ("drm/arm/malidp: Specified the rotation memory requirements for AFBC YUV formats")
Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
---
 drivers/gpu/drm/arm/malidp_hw.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/arm/malidp_hw.c b/drivers/gpu/drm/arm/malidp_hw.c
index 50af399d7f6f..dc5fff9af338 100644
--- a/drivers/gpu/drm/arm/malidp_hw.c
+++ b/drivers/gpu/drm/arm/malidp_hw.c
@@ -385,6 +385,7 @@ int malidp_format_get_bpp(u32 fmt)
 		switch (fmt) {
 		case DRM_FORMAT_VUY101010:
 			bpp = 30;
+			break;
 		case DRM_FORMAT_YUV420_10BIT:
 			bpp = 15;
 			break;
@@ -1309,7 +1310,7 @@ static irqreturn_t malidp_se_irq(int irq, void *arg)
 			break;
 		case MW_RESTART:
 			drm_writeback_signal_completion(&malidp->mw_connector, 0);
-			/* fall through to a new start */
+			/* fall through */
 		case MW_START:
 			/* writeback started, need to emulate one-shot mode */
 			hw->disable_memwrite(hwdev);
-- 
2.20.1

