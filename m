Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 157183CA95B
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238564AbhGOTGK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:06:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:39758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242693AbhGOTFO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:05:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8ACC613D7;
        Thu, 15 Jul 2021 19:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375701;
        bh=eWt/Pgp9ZAHzb7tz++3SmyziJHNnYt8Y3CLGHrP1eRs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XXVRJg3IzSTcYy9V0dFXa01uDhwid3oXpLjLN93mg9S3kmHUPPWDa0Lbh6qvHzdFc
         HX336Xck5B44opBcovs2dbLNVCioh0/nA7BSM4g8TufBSTa+Zu7QpPe5cM/jnp9aPv
         rMwO0UEE7Vv3Fux6/zMYVh/YAk3xLtLQ+izOazX8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Joseph Greathouse <Joseph.Greathouse@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>
Subject: [PATCH 5.12 162/242] drm/amdgpu: Update NV SIMD-per-CU to 2
Date:   Thu, 15 Jul 2021 20:38:44 +0200
Message-Id: <20210715182621.691426884@linuxfoundation.org>
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


