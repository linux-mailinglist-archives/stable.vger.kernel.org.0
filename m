Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8880563E048
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:55:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231523AbiK3Sz2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:55:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231573AbiK3Sz2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:55:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 884A09B7AD
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:55:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3779CB81C9F
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:55:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99A3CC4314B;
        Wed, 30 Nov 2022 18:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834525;
        bh=TkfpCa9WsJCTlHFmLyHUgmaeLUBBy/QxToYxH8Z9iFs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=clrRMvQrp0MU5gcFVjXhEmHiUSDjdMJsB5AKSD7ULIQChIFORQHhpTwM9J7bAKF1D
         GiyZJPu4tK/7dDt3gqcvgBX7tSR9jzexzJcHtmI5R+dPwG55ps1A96H+vrD4l5TrBW
         MP69CwccmonpCdNS/rK5jQThvrAiG68vSbqgNq6Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jack Xiao <Jack.Xiao@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.0 285/289] drm/amd/amdgpu: reserve vm invalidation engine for firmware
Date:   Wed, 30 Nov 2022 19:24:30 +0100
Message-Id: <20221130180550.563617782@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Xiao <Jack.Xiao@amd.com>

commit 91abf28a636291135ea5cab9af40f017cff6afce upstream.

If mes enabled, reserve VM invalidation engine 5 for firmware.

Signed-off-by: Jack Xiao <Jack.Xiao@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.0.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
@@ -479,6 +479,12 @@ int amdgpu_gmc_allocate_vm_inv_eng(struc
 	unsigned i;
 	unsigned vmhub, inv_eng;
 
+	if (adev->enable_mes) {
+		/* reserve engine 5 for firmware */
+		for (vmhub = 0; vmhub < AMDGPU_MAX_VMHUBS; vmhub++)
+			vm_inv_engs[vmhub] &= ~(1 << 5);
+	}
+
 	for (i = 0; i < adev->num_rings; ++i) {
 		ring = adev->rings[i];
 		vmhub = ring->funcs->vmhub;


