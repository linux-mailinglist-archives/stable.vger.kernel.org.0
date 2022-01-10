Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 421CE489283
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:46:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241689AbiAJHoI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:44:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240478AbiAJHmH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:42:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C4D7C02C464;
        Sun,  9 Jan 2022 23:35:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE27B61195;
        Mon, 10 Jan 2022 07:35:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1225C36AED;
        Mon, 10 Jan 2022 07:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641800100;
        bh=ohg4GoSO1ps3HImiu0Ef5jCTHEStxq1PJauztRyVqmU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=11k3QaaB5+WGfUHT8srCSJWjv1P/Yjyy8mDcDk6t+GEmS16HC6zdTI0YPK5Hfup5/
         yEX4CAQtK5DqTmCm8ZI/Ilg4W9o2yiWhMauz48Ky2ovDwWm8vHXlRpgF8nZ5ZZGe0P
         qd/G+8syeP2cK1BVGQ6ZZqZJijtvDC+WPchRMtfE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Guchun Chen <guchun.chen@amd.com>
Subject: [PATCH 5.15 72/72] drm/amd/pm: keep the BACO feature enabled for suspend
Date:   Mon, 10 Jan 2022 08:23:49 +0100
Message-Id: <20220110071823.999586047@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071821.500480371@linuxfoundation.org>
References: <20220110071821.500480371@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Quan <evan.quan@amd.com>

commit eaa090538e8d21801c6d5f94590c3799e6a528b5 upstream.

To pair with the workaround which always reset the ASIC in suspend.
Otherwise, the reset which relies on BACO will fail.

Fixes: daf8de0874ab5b ("drm/amdgpu: always reset the asic in suspend (v2)")

Signed-off-by: Evan Quan <evan.quan@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Guchun Chen <guchun.chen@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
@@ -1386,8 +1386,14 @@ static int smu_disable_dpms(struct smu_c
 {
 	struct amdgpu_device *adev = smu->adev;
 	int ret = 0;
+	/*
+	 * TODO: (adev->in_suspend && !adev->in_s0ix) is added to pair
+	 * the workaround which always reset the asic in suspend.
+	 * It's likely that workaround will be dropped in the future.
+	 * Then the change here should be dropped together.
+	 */
 	bool use_baco = !smu->is_apu &&
-		((amdgpu_in_reset(adev) &&
+		(((amdgpu_in_reset(adev) || (adev->in_suspend && !adev->in_s0ix)) &&
 		  (amdgpu_asic_reset_method(adev) == AMD_RESET_METHOD_BACO)) ||
 		 ((adev->in_runpm || adev->in_s4) && amdgpu_asic_supports_baco(adev)));
 


