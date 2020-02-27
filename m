Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4599E171D7C
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:21:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389712AbgB0OR2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:17:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:57860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389705AbgB0OR1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:17:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2FB02469D;
        Thu, 27 Feb 2020 14:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582813047;
        bh=yRLEektdeDkCtrr1P2ul+A4zBxpX5zc0GQg0vycFNg8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=INjAmd+y6ZINIoGqUb3HO0nCPsb2sJdcoLiQHa11zPHxup0RX/BKObaSysoE2wura
         sHCOTh9YXHwHJXkc8sID96fKRaVQfNTONSLjEPGi7I3FoXSWGi5kFiKQn4PaClay6F
         9m6osBJllLWrqxBHjvVnAX/5MN439LC9Dmv//fEI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
        Matt Roper <matthew.d.roper@intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.5 117/150] drm/i915/ehl: Update port clock voltage level requirements
Date:   Thu, 27 Feb 2020 14:37:34 +0100
Message-Id: <20200227132249.936963458@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132232.815448360@linuxfoundation.org>
References: <20200227132232.815448360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matt Roper <matthew.d.roper@intel.com>

commit 58e9121c32a245fab47f29ab4ad29dd62470a7e8 upstream.

Voltage level depends not only on the cdclk, but also on the DDI clock.
Last time the bspec voltage level table for EHL was updated, we only
updated the cdclk requirements, but forgot to account for the new port
clock criteria.

Bspec: 21809
Fixes: d147483884ed ("drm/i915/ehl: Update voltage level checks")
Cc: José Roberto de Souza <jose.souza@intel.com>
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200207001417.1229251-1-matthew.d.roper@intel.com
Reviewed-by: José Roberto de Souza <jose.souza@intel.com>
(cherry picked from commit 9d5fd37ed7e26efdbe90f492d7eb8b53dcdb61d6)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/display/intel_ddi.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/display/intel_ddi.c
+++ b/drivers/gpu/drm/i915/display/intel_ddi.c
@@ -4227,7 +4227,9 @@ static bool intel_ddi_is_audio_enabled(s
 void intel_ddi_compute_min_voltage_level(struct drm_i915_private *dev_priv,
 					 struct intel_crtc_state *crtc_state)
 {
-	if (INTEL_GEN(dev_priv) >= 11 && crtc_state->port_clock > 594000)
+	if (IS_ELKHARTLAKE(dev_priv) && crtc_state->port_clock > 594000)
+		crtc_state->min_voltage_level = 3;
+	else if (INTEL_GEN(dev_priv) >= 11 && crtc_state->port_clock > 594000)
 		crtc_state->min_voltage_level = 1;
 	else if (IS_CANNONLAKE(dev_priv) && crtc_state->port_clock > 594000)
 		crtc_state->min_voltage_level = 2;


