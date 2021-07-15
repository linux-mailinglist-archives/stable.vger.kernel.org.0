Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E9183CAADF
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241023AbhGOTPu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:15:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:51362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244652AbhGOTPB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:15:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D030461413;
        Thu, 15 Jul 2021 19:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626376262;
        bh=g5KchM9DXxcv9S6mGCD25XdSLy+DyVBq9Kh+7G1R5mI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hcxzWaNDwpt7rNFYloK44bLuTpY6sBdPCRAfjT35MpItS4yde/gwgy0L6zuaMuyOZ
         EaJIYSXG9QZATtEwPAquxyB2A3qdL6vlX451umNa5R3qRtzgRIU1UEsZGFTtKaGgCq
         i4XBBeAFT/2D8KDivp4DT0RJVMaPES66elxVgJhY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lyude Paul <lyude@redhat.com>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20de=20Bretagne?= 
        <jerome.debretagne@gmail.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>
Subject: [PATCH 5.13 195/266] drm/dp: Handle zeroed port counts in drm_dp_read_downstream_info()
Date:   Thu, 15 Jul 2021 20:39:10 +0200
Message-Id: <20210715182645.081719708@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lyude Paul <lyude@redhat.com>

commit 205bb69a90363541a634a662a599fddb95956524 upstream.

While the DP specification isn't entirely clear on if this should be
allowed or not, some branch devices report having downstream ports present
while also reporting a downstream port count of 0. So to avoid breaking
those devices, we need to handle this in drm_dp_read_downstream_info().

So, to do this we assume there's no downstream port info when the
downstream port count is 0.

Signed-off-by: Lyude Paul <lyude@redhat.com>
Tested-by: Jérôme de Bretagne <jerome.debretagne@gmail.com>
Bugzilla: https://gitlab.freedesktop.org/drm/intel/-/issues/3416
Fixes: 3d3721ccb18a ("drm/i915/dp: Extract drm_dp_read_downstream_info()")
Cc: <stable@vger.kernel.org> # v5.10+
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210430223428.10514-1-lyude@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/drm_dp_helper.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/gpu/drm/drm_dp_helper.c
+++ b/drivers/gpu/drm/drm_dp_helper.c
@@ -679,7 +679,14 @@ int drm_dp_read_downstream_info(struct d
 	    !(dpcd[DP_DOWNSTREAMPORT_PRESENT] & DP_DWN_STRM_PORT_PRESENT))
 		return 0;
 
+	/* Some branches advertise having 0 downstream ports, despite also advertising they have a
+	 * downstream port present. The DP spec isn't clear on if this is allowed or not, but since
+	 * some branches do it we need to handle it regardless.
+	 */
 	len = drm_dp_downstream_port_count(dpcd);
+	if (!len)
+		return 0;
+
 	if (dpcd[DP_DOWNSTREAMPORT_PRESENT] & DP_DETAILED_CAP_INFO_AVAILABLE)
 		len *= 4;
 


