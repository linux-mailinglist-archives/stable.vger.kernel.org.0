Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3932B3AEDEC
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbhFUQYM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:24:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:41468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231932AbhFUQWf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:22:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B69F26134F;
        Mon, 21 Jun 2021 16:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292407;
        bh=fEHaDeENKM+/qiBkujykmIefjGkEyJV67f0z9bVtxHw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ox2xduggFh9z7VDX90ZhflPOndE8yw7GyWFZuBtgGZHmBFVszyvEqi7d+KARN5QGo
         lqmD4dC+SV2+TYYGafRcO8thoysFivgi3qlxoF9tsaz/AA8vsa2wwLPk6gMyd39fWs
         WZdTPAiMWmx1rTFUzYrV/tChB0kw/yjzWhrSDYiI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yifan Zhang <yifan1.zhang@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.4 72/90] drm/amdgpu/gfx10: enlarge CP_MEC_DOORBELL_RANGE_UPPER to cover full doorbell.
Date:   Mon, 21 Jun 2021 18:15:47 +0200
Message-Id: <20210621154906.588365065@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154904.159672728@linuxfoundation.org>
References: <20210621154904.159672728@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yifan Zhang <yifan1.zhang@amd.com>

commit 1c0b0efd148d5b24c4932ddb3fa03c8edd6097b3 upstream.

If GC has entered CGPG, ringing doorbell > first page doesn't wakeup GC.
Enlarge CP_MEC_DOORBELL_RANGE_UPPER to workaround this issue.

Signed-off-by: Yifan Zhang <yifan1.zhang@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
@@ -3416,8 +3416,12 @@ static int gfx_v10_0_kiq_init_register(s
 	if (ring->use_doorbell) {
 		WREG32_SOC15(GC, 0, mmCP_MEC_DOORBELL_RANGE_LOWER,
 			(adev->doorbell_index.kiq * 2) << 2);
+		/* If GC has entered CGPG, ringing doorbell > first page doesn't
+		 * wakeup GC. Enlarge CP_MEC_DOORBELL_RANGE_UPPER to workaround
+		 * this issue.
+		 */
 		WREG32_SOC15(GC, 0, mmCP_MEC_DOORBELL_RANGE_UPPER,
-			(adev->doorbell_index.userqueue_end * 2) << 2);
+			(adev->doorbell.size - 4));
 	}
 
 	WREG32_SOC15(GC, 0, mmCP_HQD_PQ_DOORBELL_CONTROL,


