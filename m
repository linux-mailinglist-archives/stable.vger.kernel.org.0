Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03A001C09A5
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 23:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726447AbgD3Vr2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 17:47:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726336AbgD3Vr2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Apr 2020 17:47:28 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BA16C035494;
        Thu, 30 Apr 2020 14:47:28 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id x2so569625pfx.7;
        Thu, 30 Apr 2020 14:47:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VEoKjaxo4U/H7kyegfaqsoRet1MtFuSswC0UEQ4BGR4=;
        b=nbxQst+Vtu3ZTqPSC6mNSEZiYn4TaBwPFH1Cm9loSUDn0Cx4uD9L6qTjQJW2wDaBpe
         kOdXjfwrvhcDUIu4FmnufwEAmTUW/ojO1BI7gdzDrhOivb3PeoZLBPImO19WiedKgIOc
         PY8VxGUt+gb82ydshSG3lAwaux9OPL47OB3tXOLykmO6eeZ3tAi0FPitnsfVNNVfxjjH
         xvs1o9S3M4wWVV4vs1/kEr234iwPmYJixT5ZIL34ivF9hTIXf7DVbX+alwr2+h4OhtbS
         DCNMA0eTr4zcCzsJB+3bY9JJUxWQ8IaCBmVsYr3jKjJxyo22EzkCG1e7e/7+GmGyYnFw
         AvTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=VEoKjaxo4U/H7kyegfaqsoRet1MtFuSswC0UEQ4BGR4=;
        b=U1BK4Fe0UebhUvd+M04VC9snPMp5dfRQNMKbcRO1qOtVus5MRyZqzGzDZOfPG1Q6Fz
         EQ6G4yZIt/gdWc5Cua3KiNMgSKyInemub3ugHCmhDgazlzp7a1aqdJMJcRybGesrgB15
         P+l5mNLsaJSVNlhDKBAKagIrjjsESCQdh1dfphXc2O7+szsaM/DPKpifeL5zfmKYYKDb
         Bc57YQapfaL1YxmyTsiOVzUb+YaHK6EyJVsuIoLHDh1WFmlmqcZ0KiWgXadh22iWxBjV
         DjCzK6R9OrLSZ+rn05nF9W9dUDx3DGV6U32smbbAZf6Qaf9wZMDv6kDxQt3RhF82Oecr
         KFTQ==
X-Gm-Message-State: AGi0Puar0hhqEhXF7JdcEZq7ceBMBg3Yuhg/jK6orrnfxBr9oJS+vmpI
        kIHM2Vzqm0j+6wmcBLFFVWs=
X-Google-Smtp-Source: APiQypJLBHCI0Je+tTdRicNw26y1+Ew484sXuohXU4E0SDVCVIZZQM+F5FstoyxkeZxW8D7rvXbsmg==
X-Received: by 2002:a63:da02:: with SMTP id c2mr1027206pgh.22.1588283247850;
        Thu, 30 Apr 2020 14:47:27 -0700 (PDT)
Received: from sultan-box.localdomain ([104.200.129.62])
        by smtp.gmail.com with ESMTPSA id c2sm625854pfp.118.2020.04.30.14.47.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2020 14:47:26 -0700 (PDT)
From:   Sultan Alsawaf <sultan@kerneltoast.com>
X-Google-Original-From: Sultan Alsawaf
Cc:     Sultan Alsawaf <sultan@kerneltoast.com>, stable@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drm/i915: Don't enable WaIncreaseLatencyIPCEnabled when IPC is disabled
Date:   Thu, 30 Apr 2020 14:46:54 -0700
Message-Id: <20200430214654.51314-1-sultan@kerneltoast.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sultan Alsawaf <sultan@kerneltoast.com>

In commit 5a7d202b1574, a logical AND was erroneously changed to an OR,
causing WaIncreaseLatencyIPCEnabled to be enabled unconditionally for
kabylake and coffeelake, even when IPC is disabled. Fix the logic so
that WaIncreaseLatencyIPCEnabled is only used when IPC is enabled.

Fixes: 5a7d202b1574 ("drm/i915: Drop WaIncreaseLatencyIPCEnabled/1140 for cnl")
Cc: stable@vger.kernel.org # 5.3.x+
Signed-off-by: Sultan Alsawaf <sultan@kerneltoast.com>
---
 drivers/gpu/drm/i915/intel_pm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
index 8375054ba27d..a52986a9e7a6 100644
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -4992,7 +4992,7 @@ static void skl_compute_plane_wm(const struct intel_crtc_state *crtc_state,
 	 * WaIncreaseLatencyIPCEnabled: kbl,cfl
 	 * Display WA #1141: kbl,cfl
 	 */
-	if ((IS_KABYLAKE(dev_priv) || IS_COFFEELAKE(dev_priv)) ||
+	if ((IS_KABYLAKE(dev_priv) || IS_COFFEELAKE(dev_priv)) &&
 	    dev_priv->ipc_enabled)
 		latency += 4;
 
-- 
2.26.2

