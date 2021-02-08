Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E0FE3137D9
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:32:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233959AbhBHPcW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:32:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:37210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233874AbhBHP2I (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:28:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 91C6F64F23;
        Mon,  8 Feb 2021 15:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797366;
        bh=mUK36GO0KolvQVzwYMDTViAeAXKn43+8PaTLeu8qwL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZWvL9E4q7MITGi40jAHkvnBVL65qzHoMzE42t8YnQZrR2l2agJvsBRi1jVO+QDJQW
         OIktV55mxklrwp6LreKoReUrqPpHvyoyagmSlOP2wSVTa1omk5DodQg5lnhnyydsRp
         I1P/Vc+VM5egj0zuDrA1TMtOJLxZNkdn2jIXGw38=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Imre Deak <imre.deak@intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.10 084/120] drm/i915: Power up combo PHY lanes for for HDMI as well
Date:   Mon,  8 Feb 2021 16:01:11 +0100
Message-Id: <20210208145821.752642517@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit fad9bae9ee5d578afbe6380c82e4715efaddf118 upstream.

Currently we only explicitly power up the combo PHY lanes
for DP. The spec says we should do it for HDMI as well.

Cc: stable@vger.kernel.org
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210128155948.13678-3-ville.syrjala@linux.intel.com
Reviewed-by: Imre Deak <imre.deak@intel.com>
(cherry picked from commit 1e0cb7bef35f0d1aed383bf69a209df218b807c9)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_ddi.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/i915/display/intel_ddi.c
+++ b/drivers/gpu/drm/i915/display/intel_ddi.c
@@ -3936,6 +3936,8 @@ static void intel_enable_ddi_hdmi(struct
 		intel_de_write(dev_priv, reg, val);
 	}
 
+	intel_ddi_power_up_lanes(encoder, crtc_state);
+
 	/* In HDMI/DVI mode, the port width, and swing/emphasis values
 	 * are ignored so nothing special needs to be done besides
 	 * enabling the port.


