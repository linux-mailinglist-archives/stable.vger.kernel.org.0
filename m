Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD162267EC
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388452AbgGTQPs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:15:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:56790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388461AbgGTQPr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:15:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B01292064B;
        Mon, 20 Jul 2020 16:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261747;
        bh=GTQrvfkHkrixypBA4qDS5vPkp36CgEG6atA3IEfLCA0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fI8T0mLnNTKyayoRozJtnBnTIEK9/C10wqGFxBOwZcCzPx555AyD8Lvz9vSMmSjy4
         fhwNUzcKYweSPA8DWdFfqRmX7fX0ocnlYTX32r1cpxiGRl1ON4Tk+EpZ8htiTHeBIU
         f7ptXX5bP6hDVQvTFwag3h59HvWvCRAQnrvXai60=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, hersen wu <hersenxs.wu@amd.com>,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.7 227/244] drm/amd/display: OLED panel backlight adjust not work with external display connected
Date:   Mon, 20 Jul 2020 17:38:18 +0200
Message-Id: <20200720152836.649939898@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: hersen wu <hersenxs.wu@amd.com>

commit b448d30b0c303d5454ea572b772d1ffae96bc6e7 upstream.

[Why]
amdgpu_dm->backlight_caps is for single eDP only. the caps are upddated
for very connector. Real eDP caps will be overwritten by other external
display. For OLED panel, caps->aux_support is set to 1 for OLED pnael.
after external connected, caps+.aux_support is set to 0. This causes
OLED backlight adjustment not work.

[How]
within update_conector_ext_caps, backlight caps will be updated only for
eDP connector.

Cc: stable@vger.kernel.org
Signed-off-by: hersen wu <hersenxs.wu@amd.com>
Reviewed-by: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1804,6 +1804,7 @@ static void update_connector_ext_caps(st
 	struct amdgpu_display_manager *dm;
 	struct drm_connector *conn_base;
 	struct amdgpu_device *adev;
+	struct dc_link *link = NULL;
 	static const u8 pre_computed_values[] = {
 		50, 51, 52, 53, 55, 56, 57, 58, 59, 61, 62, 63, 65, 66, 68, 69,
 		71, 72, 74, 75, 77, 79, 81, 82, 84, 86, 88, 90, 92, 94, 96, 98};
@@ -1811,6 +1812,10 @@ static void update_connector_ext_caps(st
 	if (!aconnector || !aconnector->dc_link)
 		return;
 
+	link = aconnector->dc_link;
+	if (link->connector_signal != SIGNAL_TYPE_EDP)
+		return;
+
 	conn_base = &aconnector->base;
 	adev = conn_base->dev->dev_private;
 	dm = &adev->dm;


