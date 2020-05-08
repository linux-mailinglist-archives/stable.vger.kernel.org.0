Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 538631CAD09
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730199AbgEHM6f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:58:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:36552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729237AbgEHMyU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:54:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C570924959;
        Fri,  8 May 2020 12:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942458;
        bh=kM7+HFRE0/0UEm+Mj0kDhSBN1RPvUO4QEoA7Ra4ujk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HGr6dH88iJyZYpJmFgXscssHXNS0Ctfm+a0/EGIjpLTg4gVZV9xljeV6XUZtq8X2t
         msTf0Wr6FrY5eHLq9BiRqQcQ+4FNYWGQNok/QhNoAGb8XftXAqj9K1wfdnurd8g5BH
         bsaaHf6AVAl3HRmj2B1MPrqS2aTqt63B0OoZcNls=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.vger.org,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        Matt Atwood <matthew.s.atwood@intel.com>,
        Radhakrishna Sripada <radhakrishna.sripada@intel.com>,
        Matt Roper <matthew.d.roper@intel.com>
Subject: [PATCH 5.4 30/50] drm/i915: Extend WaDisableDARBFClkGating to icl,ehl,tgl
Date:   Fri,  8 May 2020 14:35:36 +0200
Message-Id: <20200508123047.472455641@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123043.085296641@linuxfoundation.org>
References: <20200508123043.085296641@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matt Roper <matthew.d.roper@intel.com>

commit 1e1a139d62d1c11e3083c8638d31a9744bec3918 upstream.

WaDisableDARBFClkGating, now known as Wa_14010480278, has been added to
the workaround tables for ICL, EHL, and TGL so we need to extend our
platform test accordingly.

Bspec: 33450
Bspec: 33451
Bspec: 52890
Cc: stable@kernel.vger.org
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: Matt Atwood <matthew.s.atwood@intel.com>
Cc: Radhakrishna Sripada <radhakrishna.sripada@intel.com>
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20191224012026.3157766-2-matthew.d.roper@intel.com
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/display/intel_display.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -16860,8 +16860,11 @@ get_encoder_power_domains(struct drm_i91
 
 static void intel_early_display_was(struct drm_i915_private *dev_priv)
 {
-	/* Display WA #1185 WaDisableDARBFClkGating:cnl,glk */
-	if (IS_CANNONLAKE(dev_priv) || IS_GEMINILAKE(dev_priv))
+	/*
+	 * Display WA #1185 WaDisableDARBFClkGating:cnl,glk,icl,ehl,tgl
+	 * Also known as Wa_14010480278.
+	 */
+	if (IS_GEN_RANGE(dev_priv, 10, 12) || IS_GEMINILAKE(dev_priv))
 		I915_WRITE(GEN9_CLKGATE_DIS_0, I915_READ(GEN9_CLKGATE_DIS_0) |
 			   DARBF_GATING_DIS);
 


