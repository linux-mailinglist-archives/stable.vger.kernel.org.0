Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE6815CA4C
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbfGBICl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:02:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:47270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727088AbfGBICk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:02:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0212D20659;
        Tue,  2 Jul 2019 08:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562054559;
        bh=vgsDzGUDj9eXwrIfUeDJq8jGG2+FUEtUFsElmbqhroQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U1gOggjjWBr4cA4wGhS89ttphFxXHxNSdxTUBpdaZaXC4dK1Iu8V8RT+6vfHVn4CY
         pcMEC4VSvHB4bhMPdq0ijKPPSb/6aKSwZzxqHKUbhbNb2WOcUvV+V0361Rqaazk4Oe
         XyCNIBnP6aa5OwYIeCOO+uGil4R6SHKxgbGJCnzQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Imre Deak <imre.deak@intel.com>,
        Jian-Hong Pan <jian-hong@endlessm.com>
Subject: [PATCH 5.1 11/55] drm/i915: Remove redundant store of logical CDCLK state
Date:   Tue,  2 Jul 2019 10:01:19 +0200
Message-Id: <20190702080124.603759643@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190702080124.103022729@linuxfoundation.org>
References: <20190702080124.103022729@linuxfoundation.org>
User-Agent: quilt/0.66
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Jian-Hong Pan <jian-hong@endlessm.com>

---
 drivers/gpu/drm/i915/intel_display.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -12828,8 +12828,6 @@ static int intel_modeset_checks(struct d
 		DRM_DEBUG_KMS("New voltage level calculated to be logical %u, actual %u\n",
 			      intel_state->cdclk.logical.voltage_level,
 			      intel_state->cdclk.actual.voltage_level);
-	} else {
-		to_intel_atomic_state(state)->cdclk.logical = dev_priv->cdclk.logical;
 	}
 
 	intel_modeset_clear_plls(state);


