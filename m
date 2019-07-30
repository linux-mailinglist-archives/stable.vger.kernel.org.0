Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98A1D7AC73
	for <lists+stable@lfdr.de>; Tue, 30 Jul 2019 17:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731751AbfG3PbO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jul 2019 11:31:14 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:40576 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725877AbfG3PbN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jul 2019 11:31:13 -0400
Received: by mail-lj1-f194.google.com with SMTP id m8so28903906lji.7
        for <stable@vger.kernel.org>; Tue, 30 Jul 2019 08:31:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ijf+IXMFVOGyvl/6lR3Dl4FHOPijwIT8zlA3D+mB5Zg=;
        b=ky12He8Kf8tUIMDwGJbIw/FAZCNoOYc2+0deJeoUMUYn71ibisQOQBx3k6VOLHsTuo
         B1dzMxoZdynUB6zjeAwIMLthlkJ+ZjykQ1XLvWnpUkORJ49J2i7rTLTrcxe5S5wVazgY
         sN4tUbFcMmf6azm9wd2Vt0HGmw8R3gjYK7q4u7dP3xcI6T0V84NL7ri6cxhfjiIWcTk8
         szRtTwondYA84H0RtHLJ59dTa0a8GMLmHcwNszu7oJaWMsbBkpH80NIHAuBR3faQ+lBp
         jC5V/LgKlFNaEWIBprf+MaSxhio7gITyAIw64IdCi+q4VVkTkoEPpDHFuEv0fQQHIDiz
         22OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ijf+IXMFVOGyvl/6lR3Dl4FHOPijwIT8zlA3D+mB5Zg=;
        b=CzNIdp8M1PiYAY/d70XaZogC9bFl4Gw41uGJ52OGUHG7T3+4ONw5RBNy22SYdhSIYZ
         f5jNiWCKPv515dd70pcxFYWopk0z1FlEOfCdl+TxDXi1qcMFhLFKh+Kd7CkQCLsfbF6f
         Sk43Bhw+ul31Dj+zc5E8LVvuUGXiYJ2GpavAuTQt0HBKVipDOBJ15C5npLlXXzjt7F7i
         7Zctb6t+i28CH4V6HkCYscIma9HKeVnYVpZkEw2c+1W4OlSP1eqDDVljYBp+MZe/dRKE
         vv0c2KrF4RZWkhf+qfhmXzmhsnkdNagshzwfYEjJEYVnUnW2FrqaBuei2eVbTiABoxTH
         b2fg==
X-Gm-Message-State: APjAAAXkobYvsB2XAoDKcivPBiJ0j/e0N8hxOuWODUtD1epLJQnX5Dsb
        AYxI4O1j4IVNjnDDCWsEhv8n2g==
X-Google-Smtp-Source: APXvYqwn5yHeNh2SggjrocFklpCW7DMwZmxMpOfufxOmSHRUb0st7KBTDbw62b+nH+RnCHOuX2bDgg==
X-Received: by 2002:a05:651c:1b8:: with SMTP id c24mr63473072ljn.2.1564500671320;
        Tue, 30 Jul 2019 08:31:11 -0700 (PDT)
Received: from localhost (c-243c70d5.07-21-73746f28.bbcust.telenor.se. [213.112.60.36])
        by smtp.gmail.com with ESMTPSA id l22sm13409494ljc.4.2019.07.30.08.31.09
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 30 Jul 2019 08:31:10 -0700 (PDT)
From:   Anders Roxell <anders.roxell@linaro.org>
To:     malidp@foss.arm.com, airlied@linux.ie, daniel@ffwll.ch
Cc:     dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        gustavo@embeddedor.com, liviu.dudau@arm.com,
        Anders Roxell <anders.roxell@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH v2] drm: mali-dp: Mark expected switch fall-through
Date:   Tue, 30 Jul 2019 17:30:56 +0200
Message-Id: <20190730153056.3606-1-anders.roxell@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Now that -Wimplicit-fallthrough is passed to GCC by default, the
following warnings shows up:

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

Cc: stable@vger.kernel.org # v5.2+
Fixes: b8207562abdd ("drm/arm/malidp: Specified the rotation memory requirements for AFBC YUV formats")
Acked-by: Liviu Dudau <liviu.dudau@arm.com>
Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
---
 drivers/gpu/drm/arm/malidp_hw.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/arm/malidp_hw.c b/drivers/gpu/drm/arm/malidp_hw.c
index 50af399d7f6f..380be66d4c6e 100644
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
+			/* fall through - to a new start */
 		case MW_START:
 			/* writeback started, need to emulate one-shot mode */
 			hw->disable_memwrite(hwdev);
-- 
2.20.1

