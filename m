Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 466BE3CA944
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240120AbhGOTF6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:05:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:39764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241861AbhGOTEp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:04:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D805061412;
        Thu, 15 Jul 2021 19:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375661;
        bh=ttQVaGB8SboQmHsifcEZIS+k4cOHnitcuUdP62zEDuY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pqhk1yP/z+bbIMiD0meOqRMicw3DO6ccUQT/IM2b1U9bagbbZB0BURr7IDTbjL60N
         pn+LQ0ejy1ShMbUwKGL/Wdrroh6EQKNZZrQpbU3PnZjJNzA5E2vIMvPiEUP3xrwAMe
         WmuM2yyeiI4qrIz1zxtfLZyv1QCGlzdUprmJ/n3I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.12 182/242] drm/i915/display: Do not zero past infoframes.vsc
Date:   Thu, 15 Jul 2021 20:39:04 +0200
Message-Id: <20210715182625.355413881@linuxfoundation.org>
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
@@ -3913,7 +3913,7 @@ static int intel_dp_vsc_sdp_unpack(struc
 	if (size < sizeof(struct dp_sdp))
 		return -EINVAL;
 
-	memset(vsc, 0, size);
+	memset(vsc, 0, sizeof(*vsc));
 
 	if (sdp->sdp_header.HB0 != 0)
 		return -EINVAL;


