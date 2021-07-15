Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68DDB3CA7CF
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241489AbhGOS4V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:56:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:60090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240103AbhGOSzg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:55:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 510F1613D6;
        Thu, 15 Jul 2021 18:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375162;
        bh=eWt/Pgp9ZAHzb7tz++3SmyziJHNnYt8Y3CLGHrP1eRs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yEc676T75dKNE905aikovNP/L/m3R4xiETk76YoUTdasjHI9DAc+RX2FiyonCBA0N
         ojXKfEqmtXIzaWdxJl9cdd6dhrvS/XveZbJU1fUC/VCg6nxePOB8tcnh4PANfXzUdZ
         piM4rTdxSNKhkX6KjTHEBoHpqY2Vuga43Y7fdf9o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Joseph Greathouse <Joseph.Greathouse@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>
Subject: [PATCH 5.10 149/215] drm/amdgpu: Update NV SIMD-per-CU to 2
Date:   Thu, 15 Jul 2021 20:38:41 +0200
Message-Id: <20210715182625.971165379@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182558.381078833@linuxfoundation.org>
References: <20210715182558.381078833@linuxfoundation.org>
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


