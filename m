Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62C2D68D869
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:09:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232229AbjBGNJ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:09:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232294AbjBGNJ0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:09:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2822739291
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:08:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09C4661422
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:08:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC195C43443;
        Tue,  7 Feb 2023 13:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775325;
        bh=FQoo1cYxT9+xUFmp7j4fTzAWcNSiimY92euimoOaADs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FgAwanx7dBNiaUIjfBfcNuSKZOqoS0hv5r0g6Rfik/M+cG5duIZMkyPISSCKul5kl
         NvWChSnyWBdYoFwHWaMHvY6nNHiRFInXviJgRzbWnlFY8lqfy4+DE2MQtN9SBxDGqt
         eKmKEeXZ0IKPQcw731xAxssM2q0IVc326QwuqQ7g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Graham Sider <Graham.Sider@amd.com>,
        Mukul Joshi <Mukul.Joshi@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 183/208] drm/amdgpu: update wave data type to 3 for gfx11
Date:   Tue,  7 Feb 2023 13:57:17 +0100
Message-Id: <20230207125642.759741948@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Graham Sider <Graham.Sider@amd.com>

commit ed8e793c65e4c6633e8577e40d574da8a56d2e0f upstream.

SQ_WAVE_INST_DW0 isn't present on gfx11 compared to gfx10, so update
wave data type to signify a difference.

Signed-off-by: Graham Sider <Graham.Sider@amd.com>
Reviewed-by: Mukul Joshi <Mukul.Joshi@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.1.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
index b9b57a66e113..66eb102cd88f 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -790,8 +790,8 @@ static void gfx_v11_0_read_wave_data(struct amdgpu_device *adev, uint32_t simd,
 	 * zero here */
 	WARN_ON(simd != 0);
 
-	/* type 2 wave data */
-	dst[(*no_fields)++] = 2;
+	/* type 3 wave data */
+	dst[(*no_fields)++] = 3;
 	dst[(*no_fields)++] = wave_read_ind(adev, wave, ixSQ_WAVE_STATUS);
 	dst[(*no_fields)++] = wave_read_ind(adev, wave, ixSQ_WAVE_PC_LO);
 	dst[(*no_fields)++] = wave_read_ind(adev, wave, ixSQ_WAVE_PC_HI);
-- 
2.39.1



