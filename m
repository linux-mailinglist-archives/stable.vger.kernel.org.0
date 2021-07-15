Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7123CA935
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236333AbhGOTFs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:05:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:39498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243677AbhGOTEi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:04:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A1BA6140A;
        Thu, 15 Jul 2021 19:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375633;
        bh=g5KchM9DXxcv9S6mGCD25XdSLy+DyVBq9Kh+7G1R5mI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PpL3GVWV3mRRraartscZAtj6dugmzkJDRf2Zq2ag8I0iOaHS97BGYENwckwH5Hu/2
         Xvx9l81VKysiWGkj1iBQ1gf6W8FN7o/HSd0hVaatlVHs0MWdeSbY1NWI8g5MAsdaz0
         MkRYNWw0XlH48Mu0xU3AKPNX9qQht9zhZHfCU5eI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lyude Paul <lyude@redhat.com>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20de=20Bretagne?= 
        <jerome.debretagne@gmail.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>
Subject: [PATCH 5.12 171/242] drm/dp: Handle zeroed port counts in drm_dp_read_downstream_info()
Date:   Thu, 15 Jul 2021 20:38:53 +0200
Message-Id: <20210715182623.324295260@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
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
 


