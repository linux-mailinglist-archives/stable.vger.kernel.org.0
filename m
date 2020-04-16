Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4889A1ACA33
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410423AbgDPPcV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:32:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:55264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727125AbgDPNmU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:42:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E1D32222E;
        Thu, 16 Apr 2020 13:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044540;
        bh=mDyuvzBU0DHXlkElGu1lIgKkQhTG1xpoGSILQu6UrOE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BMaXPPPpkr4F5wWBJG/T6OTLCBKVJu95xtkyCjE3/AutH2kzJiL6UyUw2hfE2GN08
         iyFSTLRK2i2oOJgD+gcnwQC28QJ75hf3Eht2OBVEAwG0bw3mnmbA+RA5gm5T6iFI+A
         K4tCmi9ae6uLrK8xjc5R8KP2P/MpNmHDY7mpHr/c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Imre Deak <imre.deak@intel.com>,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 250/257] drm/i915/icl+: Dont enable DDI IO power on a TypeC port in TBT mode
Date:   Thu, 16 Apr 2020 15:25:01 +0200
Message-Id: <20200416131356.855824146@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.891903893@linuxfoundation.org>
References: <20200416131325.891903893@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Imre Deak <imre.deak@intel.com>

The DDI IO power well must not be enabled for a TypeC port in TBT mode,
ensure this during driver loading/system resume.

This gets rid of error messages like
[drm] *ERROR* power well DDI E TC2 IO state mismatch (refcount 1/enabled 0)

and avoids leaking the power ref when disabling the output.

Cc: <stable@vger.kernel.org> # v5.4+
Signed-off-by: Imre Deak <imre.deak@intel.com>
Reviewed-by: José Roberto de Souza <jose.souza@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200330152244.11316-1-imre.deak@intel.com
(cherry picked from commit f77a2db27f26c3ccba0681f7e89fef083718f07f)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_ddi.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_ddi.c b/drivers/gpu/drm/i915/display/intel_ddi.c
index 1488822398fed..4872c357eb6da 100644
--- a/drivers/gpu/drm/i915/display/intel_ddi.c
+++ b/drivers/gpu/drm/i915/display/intel_ddi.c
@@ -2235,7 +2235,11 @@ static void intel_ddi_get_power_domains(struct intel_encoder *encoder,
 		return;
 
 	dig_port = enc_to_dig_port(&encoder->base);
-	intel_display_power_get(dev_priv, dig_port->ddi_io_power_domain);
+
+	if (!intel_phy_is_tc(dev_priv, phy) ||
+	    dig_port->tc_mode != TC_PORT_TBT_ALT)
+		intel_display_power_get(dev_priv,
+					dig_port->ddi_io_power_domain);
 
 	/*
 	 * AUX power is only needed for (e)DP mode, and for HDMI mode on TC
-- 
2.20.1



