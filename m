Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 581AE65D9BC
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:28:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239834AbjADQ2F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:28:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239858AbjADQ1t (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:27:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 582723F139
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:27:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38748617A6
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:27:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47F20C433F1;
        Wed,  4 Jan 2023 16:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672849644;
        bh=TxGshAc87D7Y48cE1HmthEhHBOwAKCGyFC5MM6RoQS8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0WdD/x9tNIheZKCOTczsxL4CAwBYjFDgPoyDrpKrxd8E4MP0xHh4J1x+nE80L+ftK
         YFqbUccKb0F1ZleIDlR6XYM6IGQe3582xAvKeN/3YiwDUWKHFrskp42y6fUN2c+MAt
         C7+K40pttC7j1Kx8XiirsKSck0pLFuBoj1q945lk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Luben Tuikov <luben.tuikov@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.0 171/177] drm/amdgpu: make display pinning more flexible (v2)
Date:   Wed,  4 Jan 2023 17:07:42 +0100
Message-Id: <20230104160512.857202423@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

commit 81d0bcf9900932633d270d5bc4a54ff599c6ebdb upstream.

Only apply the static threshold for Stoney and Carrizo.
This hardware has certain requirements that don't allow
mixing of GTT and VRAM.  Newer asics do not have these
requirements so we should be able to be more flexible
with where buffers end up.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2270
Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2291
Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2255
Acked-by: Luben Tuikov <luben.tuikov@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
@@ -1506,7 +1506,8 @@ u64 amdgpu_bo_gpu_offset_no_check(struct
 uint32_t amdgpu_bo_get_preferred_domain(struct amdgpu_device *adev,
 					    uint32_t domain)
 {
-	if (domain == (AMDGPU_GEM_DOMAIN_VRAM | AMDGPU_GEM_DOMAIN_GTT)) {
+	if ((domain == (AMDGPU_GEM_DOMAIN_VRAM | AMDGPU_GEM_DOMAIN_GTT)) &&
+	    ((adev->asic_type == CHIP_CARRIZO) || (adev->asic_type == CHIP_STONEY))) {
 		domain = AMDGPU_GEM_DOMAIN_VRAM;
 		if (adev->gmc.real_vram_size <= AMDGPU_SG_THRESHOLD)
 			domain = AMDGPU_GEM_DOMAIN_GTT;


