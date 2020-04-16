Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F12A51AC478
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 16:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392615AbgDPOAZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 10:00:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:47396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729196AbgDPOAV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 10:00:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38C892078B;
        Thu, 16 Apr 2020 14:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045620;
        bh=RlRCokos5o0UeqHAQkpCYKjmo+MSA2vfNilvoTQkdxI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uP4fwNPPmM34NJZKTLoHqzrJO0HFiV/3ELat4u+knaUMaSjNNmnp5j8oJqZjbNvD4
         OfIW5MFeKVFfYsxa5jdFWhE1cKBXgR0BeYP6IE+69qUysRV2TjJ3PeV+vU9p7IJrym
         d6aC91p08nAr+N9zzh3X8RXzBCuHVeXkp7+VW01o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Imre Deak <imre.deak@intel.com>,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.6 209/254] drm/i915/icl+: Dont enable DDI IO power on a TypeC port in TBT mode
Date:   Thu, 16 Apr 2020 15:24:58 +0200
Message-Id: <20200416131352.201075226@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
References: <20200416131325.804095985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Imre Deak <imre.deak@intel.com>

commit 6e8a36c13382b7165d23928caee8d91c1b301142 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/display/intel_ddi.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/display/intel_ddi.c
+++ b/drivers/gpu/drm/i915/display/intel_ddi.c
@@ -2225,7 +2225,11 @@ static void intel_ddi_get_power_domains(
 		return;
 
 	dig_port = enc_to_dig_port(encoder);
-	intel_display_power_get(dev_priv, dig_port->ddi_io_power_domain);
+
+	if (!intel_phy_is_tc(dev_priv, phy) ||
+	    dig_port->tc_mode != TC_PORT_TBT_ALT)
+		intel_display_power_get(dev_priv,
+					dig_port->ddi_io_power_domain);
 
 	/*
 	 * AUX power is only needed for (e)DP mode, and for HDMI mode on TC


