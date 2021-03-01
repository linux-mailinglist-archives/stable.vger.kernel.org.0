Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67D0832918F
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:32:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243318AbhCAU1s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:27:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:47580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242936AbhCAUVM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:21:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B40D1653E7;
        Mon,  1 Mar 2021 18:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621847;
        bh=1ky7nt3ngZjKLGd7nTnrpKypDmjz25a4MrDHr3oVSPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UcUe0fQJTy3td3kn8KpMN1F8caMm/jiJHpTCJfUyb34MEwe12XVKS+oRehdQXcd1q
         FZgByWCeEJz4RQDsVUWMxh3aJBMlsg9vGk9MVgz3gnJ1OAYonw2bf/pTE/Jb/tKcgE
         2LJV9/Gqj9wgdUDghKxL/PEXweCAsExcjVlnZ76A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Daniel Stone <daniels@collabora.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Subject: [PATCH 5.11 625/775] drm/rockchip: Require the YTR modifier for AFBC
Date:   Mon,  1 Mar 2021 17:13:13 +0100
Message-Id: <20210301161232.283267572@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>

commit 5f94e3571459abb626077aedb65d71264c2a58c0 upstream.

The AFBC decoder used in the Rockchip VOP assumes the use of the
YUV-like colourspace transform (YTR). YTR is lossless for RGB(A)
buffers, which covers the RGBA8 and RGB565 formats supported in
vop_convert_afbc_format. Use of YTR is signaled with the
AFBC_FORMAT_MOD_YTR modifier, which prior to this commit was missing. As
such, a producer would have to generate buffers that do not use YTR,
which the VOP would erroneously decode as YTR, leading to severe visual
corruption.

The upstream AFBC support was developed against a captured frame, which
failed to exercise modifier support. Prior to bring-up of AFBC in Mesa
(in the Panfrost driver), no open userspace respected modifier
reporting. As such, this change is not expected to affect broken
userspaces.

Tested on RK3399 with Panfrost and Weston.

Fixes: 7707f7227f09 ("drm/rockchip: Add support for afbc")
Cc: stable@vger.kernel.org
Signed-off-by: Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>
Acked-by: Daniel Stone <daniels@collabora.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20200811202631.3603-1-alyssa.rosenzweig@collabora.com
Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/rockchip/rockchip_drm_vop.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop.h
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop.h
@@ -17,9 +17,20 @@
 
 #define NUM_YUV2YUV_COEFFICIENTS 12
 
+/* AFBC supports a number of configurable modes. Relevant to us is block size
+ * (16x16 or 32x8), storage modifiers (SPARSE, SPLIT), and the YUV-like
+ * colourspace transform (YTR). 16x16 SPARSE mode is always used. SPLIT mode
+ * could be enabled via the hreg_block_split register, but is not currently
+ * handled. The colourspace transform is implicitly always assumed by the
+ * decoder, so consumers must use this transform as well.
+ *
+ * Failure to match modifiers will cause errors displaying AFBC buffers
+ * produced by conformant AFBC producers, including Mesa.
+ */
 #define ROCKCHIP_AFBC_MOD \
 	DRM_FORMAT_MOD_ARM_AFBC( \
 		AFBC_FORMAT_MOD_BLOCK_SIZE_16x16 | AFBC_FORMAT_MOD_SPARSE \
+			| AFBC_FORMAT_MOD_YTR \
 	)
 
 enum vop_data_format {


