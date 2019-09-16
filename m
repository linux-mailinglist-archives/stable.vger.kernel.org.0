Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60BE4B3F11
	for <lists+stable@lfdr.de>; Mon, 16 Sep 2019 18:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731852AbfIPQgF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Sep 2019 12:36:05 -0400
Received: from mail-pl1-f176.google.com ([209.85.214.176]:39614 "EHLO
        mail-pl1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727950AbfIPQgF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Sep 2019 12:36:05 -0400
Received: by mail-pl1-f176.google.com with SMTP id bd8so127967plb.6
        for <stable@vger.kernel.org>; Mon, 16 Sep 2019 09:36:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jlekstrand-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PI3pxRC+GZHeQL82Z+jOShZWy9ITmZi+dui65RciUWo=;
        b=cNcZqgla2hApmVJpNhYsmcFIWXeiYUNRkgo01zHIMzCwbTSVxmtyUYiq8qCA+DqXYH
         8zCYVYj1QVUGzkDl/ucjhozvp9q8WzRUwwdGyc7o5lW68Ls5fXSEZvEZvo2WOzmpIY3V
         TOjNcYg2e0iRuqpqOPncia9U7clEt15cIcC5Itw/jpdnxiYzAtROH5BlhfoRzhGc1Vhq
         COTRDhcS9uhLUsTlhtS0Y5fn012eARwqBZf3pfk0rQDd2enfQXH77pLH/gw+wMzVrpgJ
         r9nLYUbDzgehYTVcbzmFdzLa/KFXnhkdrvmTprcC3t3RYCbK5RBdZTjy45AVkADi/hZX
         bG0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PI3pxRC+GZHeQL82Z+jOShZWy9ITmZi+dui65RciUWo=;
        b=bWZfdUCPgk//ULigmHBuPwZEnK4GWH6Q2JYNHWTl8KBV3dNnyBxDz0leiRoBF6wof7
         ewXMSrbHvTQKJM8IxIID0O8iaD+2R0Q4/JNrKaEUzWMY454Wt8U+3Ht2vAFs6EDGt261
         f2wdeSOAsWncVlnB8MlSsAl7cAFkLsd07gnEVSH4JSHd3xjFAYRJtVseJlMl6rjOTCQb
         1S9FUBzGjIFKRBStfvYt4eFc+B2WsKAhsyLooMac073sm/YFk9TIUX3JNzkXhqDMwChe
         gAMGgGQatcO0MVG5fCHX6kxjKzcg1FbWBNmXWoJByLzUjqkFA4IxxeNiKwoY2g6NiV8C
         eM0A==
X-Gm-Message-State: APjAAAXc7cl29y4LUENVWl3WkD/oUAB1uFkjMeVe0PUBLhVyDCTIncpt
        u6nls8cMF+0OBpgxaSkb5QrIDouF8nER9g==
X-Google-Smtp-Source: APXvYqwowmn+FXo70UFPpClW0eYqbScScnze869NecVhu4hR/B2ONnCt3hM8Hyy/gqXrINBSWf7psA==
X-Received: by 2002:a17:902:ff08:: with SMTP id f8mr648798plj.309.1568651763985;
        Mon, 16 Sep 2019 09:36:03 -0700 (PDT)
Received: from omlet.jf.intel.com ([2605:6000:1026:c030::cf8])
        by smtp.gmail.com with ESMTPSA id 71sm72256782pfw.147.2019.09.16.09.36.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Sep 2019 09:36:03 -0700 (PDT)
From:   Jason Ekstrand <jason@jlekstrand.net>
To:     stable@vger.kernel.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Jason Ekstrand <jason@jlekstrand.net>,
        denys.kostin@globallogic.com,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH] drm/i915: Restore relaxed padding (OCL_OOB_SUPPRES_ENABLE) for skl+
Date:   Mon, 16 Sep 2019 11:35:54 -0500
Message-Id: <20190916163554.25287-1-jason@jlekstrand.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <156864710545220@kroah.com>
References: <156864710545220@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

This bit was fliped on for "syncing dependencies between camera and
graphics". BSpec has no recollection why, and it is causing
unrecoverable GPU hangs with Vulkan compute workloads.

From BSpec, setting bit5 to 0 enables relaxed padding requirements for
buffers, 1D and 2D non-array, non-MSAA, non-mip-mapped linear surfaces;
and *must* be set to 0h on skl+ to ensure "Out of Bounds" case is
suppressed.

Back-ported from 2eb0964eec5f1d99f9eaf4963eee267acc72b615 to 4.19.72 by
Jason Ekstrand

Reported-by: Jason Ekstrand <jason@jlekstrand.net>
Suggested-by: Jason Ekstrand <jason@jlekstrand.net>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=110998
Fixes: 8424171e135c ("drm/i915/gen9: h/w w/a: syncing dependencies between camera and graphics")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Tested-by: denys.kostin@globallogic.com
Cc: Jason Ekstrand <jason@jlekstrand.net>
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: <stable@vger.kernel.org> # v4.1+
Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190904100707.7377-1-chris@chris-wilson.co.uk
(cherry picked from commit 9d7b01e93526efe79dbf75b69cc5972b5a4f7b37)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Jason Ekstrand <jason@jlekstrand.net>
---
 drivers/gpu/drm/i915/intel_workarounds.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_workarounds.c b/drivers/gpu/drm/i915/intel_workarounds.c
index c44bb37e434c..bbb7411fc11b 100644
--- a/drivers/gpu/drm/i915/intel_workarounds.c
+++ b/drivers/gpu/drm/i915/intel_workarounds.c
@@ -227,11 +227,6 @@ static int gen9_ctx_workarounds_init(struct drm_i915_private *dev_priv)
 			  FLOW_CONTROL_ENABLE |
 			  PARTIAL_INSTRUCTION_SHOOTDOWN_DISABLE);
 
-	/* Syncing dependencies between camera and graphics:skl,bxt,kbl */
-	if (!IS_COFFEELAKE(dev_priv))
-		WA_SET_BIT_MASKED(HALF_SLICE_CHICKEN3,
-				  GEN9_DISABLE_OCL_OOB_SUPPRESS_LOGIC);
-
 	/* WaEnableYV12BugFixInHalfSliceChicken7:skl,bxt,kbl,glk,cfl */
 	/* WaEnableSamplerGPGPUPreemptionSupport:skl,bxt,kbl,cfl */
 	WA_SET_BIT_MASKED(GEN9_HALF_SLICE_CHICKEN7,
-- 
2.21.0

