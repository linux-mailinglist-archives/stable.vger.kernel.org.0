Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90376593529
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 20:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240084AbiHOSUR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239819AbiHOSS5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:18:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC7012BB15;
        Mon, 15 Aug 2022 11:16:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64FB7B81063;
        Mon, 15 Aug 2022 18:16:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD08DC433D6;
        Mon, 15 Aug 2022 18:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587380;
        bh=lk6E3HO1m9rC2T2mQWrxN4dvmUWts8HkHyFZ9zjhZVE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U+Ib1274h5jvs5GsXXjw59HXOi8rgX7PNXLFtL2icL1rsjvyrWiScbXauQhg+qn7R
         55bbJO2GHsPYzl6ofZAH60krJ+UmlHDMVUUsEgVtZvYxCXZvVN/ZQKV6FA7LK0xPlm
         hnpQEjh+8KcjBm1/jitWVOqz0Ztfe54o3kt+PUz8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 5.15 068/779] drm/amdgpu: Check BOs requested pinning domains against its preferred_domains
Date:   Mon, 15 Aug 2022 19:55:12 +0200
Message-Id: <20220815180340.188431192@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leo Li <sunpeng.li@amd.com>

commit f5ba14043621f4afdf3ad5f92ee2d8dbebbe4340 upstream.

When pinning a buffer, we should check to see if there are any
additional restrictions imposed by bo->preferred_domains. This will
prevent the BO from being moved to an invalid domain when pinning.

For example, this can happen if the user requests to create a BO in GTT
domain for display scanout. amdgpu_dm will allow pinning to either VRAM
or GTT domains, since DCN can scanout from either or. However, in
amdgpu_bo_pin_restricted(), pinning to VRAM is preferred if there is
adequate carveout. This can lead to pinning to VRAM despite the user
requesting GTT placement for the BO.

v2: Allow the kernel to override the domain, which can happen when
    exporting a BO to a V4L camera (for example).

Signed-off-by: Leo Li <sunpeng.li@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
@@ -912,6 +912,10 @@ int amdgpu_bo_pin_restricted(struct amdg
 	if (WARN_ON_ONCE(min_offset > max_offset))
 		return -EINVAL;
 
+	/* Check domain to be pinned to against preferred domains */
+	if (bo->preferred_domains & domain)
+		domain = bo->preferred_domains & domain;
+
 	/* A shared bo cannot be migrated to VRAM */
 	if (bo->tbo.base.import_attach) {
 		if (domain & AMDGPU_GEM_DOMAIN_GTT)


