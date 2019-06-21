Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A58E24E56F
	for <lists+stable@lfdr.de>; Fri, 21 Jun 2019 12:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbfFUKIY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jun 2019 06:08:24 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:46220 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726218AbfFUKIY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Jun 2019 06:08:24 -0400
Received: by mail-pf1-f194.google.com with SMTP id 81so3333634pfy.13
        for <stable@vger.kernel.org>; Fri, 21 Jun 2019 03:08:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Rou5ztsbbIHgrWGmwhUUrHhWDnpDAQXUecU8EYRDD/8=;
        b=aBzfC4Hs/Ghoc1Y9joOkBOj0CYZ7vffePpyQv8VnN4+8Tc/KHUp3eXucM9CTNs678L
         s+4VeNEopVQFh9kIRceGLjPZgu/n/G1fn0mIatmcX5X+OPRZI5aBVqbAYwfqXSyEV95v
         Xz33aiFBzZ30jSYzKC1fcIffIbmW7J/oHvSm1yUGzedDIaVqQ/yg1gaJxqjmDvJd9u3q
         zKZDPYbXgID3w5dlNKyYGUy/LKzlv1IOZv8HH2QxkYxG2bgAweE64cQpplWB+d7ixMD0
         xLO3teSuiRFHYOZIEgkgT13RcYWdP+i02G7MUvceJUWUjZJq9fnEb9tbXqpbitYrS2EE
         Vvpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Rou5ztsbbIHgrWGmwhUUrHhWDnpDAQXUecU8EYRDD/8=;
        b=SuQiUiSYIXfC7MRl0Py1YmVWayAX7/ZhYK4AQUDxq3b3Y26o6Mp+f1zDSv/1ofryOX
         mk4VLL+nmKYAIX351WX54WEjtlBZEqLffrK1sMvuQciepONfbbLKk/MM1zyiZfkyy+oJ
         E43LSpf+SnDFvMXTEc6Jjvt3mxRrGckAufhWi45fILgdsJCoyM0HyY6OJ1RETt521d4A
         1+fkUE+8xCx4UCkALn7gJURo+MQsaLb/ROemM5vQL8oGyCophbXYl6uZZX/7ybYUsPWH
         SWZjQJIerR051HEhZLsPy4S+ou/kIJj1jOQaW8agkq1pUxJnz+i5EBD+dTnNPazQUc0b
         zwZQ==
X-Gm-Message-State: APjAAAWGjQy8djKrw7X2zMtYLO28sWt2RCeMMWYxnurcgHxpph7LAebv
        NMX8oA/DpKXMDBTa8d7go/VntA==
X-Google-Smtp-Source: APXvYqyakKHW1ndCszeObrdGcdP9eaqL+rMHKlnseZpfHd18JKmnnl2KnnPXE6Fkojd1NXmBzRaVYA==
X-Received: by 2002:a63:3383:: with SMTP id z125mr3870504pgz.8.1561111703374;
        Fri, 21 Jun 2019 03:08:23 -0700 (PDT)
Received: from localhost.localdomain (123-204-46-122.static.seed.net.tw. [123.204.46.122])
        by smtp.gmail.com with ESMTPSA id c18sm2246892pfc.180.2019.06.21.03.08.20
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 21 Jun 2019 03:08:23 -0700 (PDT)
From:   Jian-Hong Pan <jian-hong@endlessm.com>
To:     Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc:     Imre Deak <imre.deak@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Abhay Kumar <abhay.kumar@intel.com>, tiwai@suse.de,
        hui.wang@canonical.com, linux@endlessm.com,
        Jian-Hong Pan <jian-hong@endlessm.com>
Subject: [PATCH stable-5.1 v2 3/4] drm/i915: Remove redundant store of logical CDCLK state
Date:   Fri, 21 Jun 2019 18:07:16 +0800
Message-Id: <20190621100716.8032-4-jian-hong@endlessm.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190621100716.8032-1-jian-hong@endlessm.com>
References: <20190620141949.GD9832@kroah.com>
 <20190621100716.8032-1-jian-hong@endlessm.com>
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
index fb2a23830325..d8fabe4643d9 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -12831,8 +12831,6 @@ static int intel_modeset_checks(struct drm_atomic_state *state)
 		DRM_DEBUG_KMS("New voltage level calculated to be logical %u, actual %u\n",
 			      intel_state->cdclk.logical.voltage_level,
 			      intel_state->cdclk.actual.voltage_level);
-	} else {
-		to_intel_atomic_state(state)->cdclk.logical = dev_priv->cdclk.logical;
 	}
 
 	intel_modeset_clear_plls(state);
-- 
2.22.0

