Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF343CAB01
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244422AbhGOTQV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:16:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:51284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244837AbhGOTPR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:15:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85FA76141D;
        Thu, 15 Jul 2021 19:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626376302;
        bh=OSCJ7Nc1IxcH8xx6U5OG5FjvhGPZcW7dI1JL+GUw39Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KEXHIl7u4wL6Rz16qr5k142dpQQi/cLTG9rk4kwgScBnMPaw+8VnPSRcDokveT79r
         oUz1uX3nRUOVhMltGwn3C28z/8qdBlBIxe4Q4tCb5W6GivF/AIpO40EVNOoHzlwilT
         iV23uTYM3v7e/Oy5HW93CkxhI93782R2UObV2qX8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.13 206/266] drm/i915/display: Do not zero past infoframes.vsc
Date:   Thu, 15 Jul 2021 20:39:21 +0200
Message-Id: <20210715182646.349674659@linuxfoundation.org>
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

From: Kees Cook <keescook@chromium.org>

commit 07b72960d2b4a087ff2445e286159e69742069cc upstream.

intel_dp_vsc_sdp_unpack() was using a memset() size (36, struct dp_sdp)
larger than the destination (24, struct drm_dp_vsc_sdp), clobbering
fields in struct intel_crtc_state after infoframes.vsc. Use the actual
target size for the memset().

Fixes: 1b404b7dbb10 ("drm/i915/dp: Read out DP SDPs")
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: José Roberto de Souza <jose.souza@intel.com>
Signed-off-by: José Roberto de Souza <jose.souza@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210617213301.1824728-1-keescook@chromium.org
(cherry picked from commit c88e2647c5bb45d04dc4302018ebe6ebbf331823)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/display/intel_dp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -2850,7 +2850,7 @@ static int intel_dp_vsc_sdp_unpack(struc
 	if (size < sizeof(struct dp_sdp))
 		return -EINVAL;
 
-	memset(vsc, 0, size);
+	memset(vsc, 0, sizeof(*vsc));
 
 	if (sdp->sdp_header.HB0 != 0)
 		return -EINVAL;


