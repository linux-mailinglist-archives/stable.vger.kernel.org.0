Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9BFC1C449F
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 20:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730356AbgEDSIj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 14:08:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:38584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731071AbgEDSHj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 14:07:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B22BC2078C;
        Mon,  4 May 2020 18:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615659;
        bh=VteYMk1LR6te1UA/DCtb6VMoHlcOc655RQxOBLcsWgs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PJXOQ0aQVsMtI5gVGXMm/GOyukP9EqdIxuy/nrI86Tdtm6s13cQds215sDVa7+Aq0
         Wj4Kk+2mCZy+Y5VK3cwAmgHnwum+Xj+K6tZ71fqomeP+J7PHjU6fLmCaaZd1kHB/Rt
         +u8Td2dEdkkxNndZ4kP870NRn0aKNctSS4Vm/epw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
        Matt Roper <matthew.d.roper@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.6 70/73] drm/i915: Use proper fault mask in interrupt postinstall too
Date:   Mon,  4 May 2020 19:58:13 +0200
Message-Id: <20200504165510.444897810@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504165501.781878940@linuxfoundation.org>
References: <20200504165501.781878940@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matt Roper <matthew.d.roper@intel.com>

commit 8598eb781cf68fd6cb67c479f1479ae58bd54fb9 upstream.

The IRQ postinstall handling had open-coded pipe fault mask selection
that never got updated for gen11.  Switch it to use
gen8_de_pipe_fault_mask() to ensure we don't miss updates for new
platforms.

Cc: José Roberto de Souza <jose.souza@intel.com>
Fixes: d506a65d56fd ("drm/i915: Catch GTT fault errors for gen11+ planes")
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200424231423.4065231-1-matthew.d.roper@intel.com
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
(cherry picked from commit 869129ee0c624a78c74e50b51635e183196cd2c6)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_irq.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -3321,7 +3321,8 @@ static void gen8_de_irq_postinstall(stru
 {
 	struct intel_uncore *uncore = &dev_priv->uncore;
 
-	u32 de_pipe_masked = GEN8_PIPE_CDCLK_CRC_DONE;
+	u32 de_pipe_masked = gen8_de_pipe_fault_mask(dev_priv) |
+		GEN8_PIPE_CDCLK_CRC_DONE;
 	u32 de_pipe_enables;
 	u32 de_port_masked = GEN8_AUX_CHANNEL_A;
 	u32 de_port_enables;
@@ -3332,13 +3333,10 @@ static void gen8_de_irq_postinstall(stru
 		de_misc_masked |= GEN8_DE_MISC_GSE;
 
 	if (INTEL_GEN(dev_priv) >= 9) {
-		de_pipe_masked |= GEN9_DE_PIPE_IRQ_FAULT_ERRORS;
 		de_port_masked |= GEN9_AUX_CHANNEL_B | GEN9_AUX_CHANNEL_C |
 				  GEN9_AUX_CHANNEL_D;
 		if (IS_GEN9_LP(dev_priv))
 			de_port_masked |= BXT_DE_PORT_GMBUS;
-	} else {
-		de_pipe_masked |= GEN8_DE_PIPE_IRQ_FAULT_ERRORS;
 	}
 
 	if (INTEL_GEN(dev_priv) >= 11)


