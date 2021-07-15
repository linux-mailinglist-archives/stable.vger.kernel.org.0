Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9D123CA684
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239549AbhGOSsb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:48:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:49802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239563AbhGOSsP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:48:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5004F61158;
        Thu, 15 Jul 2021 18:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626374721;
        bh=eWt/Pgp9ZAHzb7tz++3SmyziJHNnYt8Y3CLGHrP1eRs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wf79cRd7ELBGLDwRFmcoFid774AYgqg+aL3IKKKjhE0ihiB47z0kU+AO4Y8ccJ6jr
         mpKvIgas87GGbuYtZ4yfzqg9UYqlmGAFF6D8/8ESvsA3AGjihagTarmF97ZC9pwEH2
         St2RYZw9jFwD0Wh1YN/ktlCfzvOIqLtAR+mgUF5o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Joseph Greathouse <Joseph.Greathouse@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>
Subject: [PATCH 5.4 077/122] drm/amdgpu: Update NV SIMD-per-CU to 2
Date:   Thu, 15 Jul 2021 20:38:44 +0200
Message-Id: <20210715182510.551071873@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182448.393443551@linuxfoundation.org>
References: <20210715182448.393443551@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joseph Greathouse <Joseph.Greathouse@amd.com>

commit aa6158112645aae514982ad8d56df64428fcf203 upstream.

Navi series GPUs have 2 SIMDs per CU (and then 2 CUs per WGP).
The NV enum headers incorrectly listed this as 4, which later meant
we were incorrectly reporting the number of SIMDs in the HSA
topology. This could cause problems down the line for user-space
applications that want to launch a fixed amount of work to each
SIMD.

Signed-off-by: Joseph Greathouse <Joseph.Greathouse@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/include/navi10_enum.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/include/navi10_enum.h
+++ b/drivers/gpu/drm/amd/include/navi10_enum.h
@@ -430,7 +430,7 @@ ARRAY_2D_DEPTH
  */
 
 typedef enum ENUM_NUM_SIMD_PER_CU {
-NUM_SIMD_PER_CU                          = 0x00000004,
+NUM_SIMD_PER_CU                          = 0x00000002,
 } ENUM_NUM_SIMD_PER_CU;
 
 /*


