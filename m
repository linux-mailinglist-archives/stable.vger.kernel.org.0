Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 602D462806A
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:05:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237790AbiKNNFq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:05:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237782AbiKNNFp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:05:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3AF72A71C
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:05:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 600886116E
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:05:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BC38C433C1;
        Mon, 14 Nov 2022 13:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668431143;
        bh=dJBAVPP0fWGJcLEgMUJjd/x//yuaCBqXRY2+FK1/Uhc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q4v4a8y2s/GL68SNb1lVlrw3eVxQ0/AVfUY98TT8tSUHfMcIO+D7xQB1IYwnEEIcG
         Ct+CmlNRHU4ClurTXoXoQW2TQluuQnXkKSlC04lxRzM0N6xVg3OtcFnGfFr6Gg/5+k
         c9zJ/ZMDxtC6hKn9hkU0tG0yRoAkVPyy8E7E3Rj8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ma Jun <Jun.Ma2@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        "Limonciello, Mario" <Mario.Limonciello@amd.com>
Subject: [PATCH 6.0 117/190] drm/amdgpu: Fix the lpfn checking condition in drm buddy
Date:   Mon, 14 Nov 2022 13:45:41 +0100
Message-Id: <20221114124503.807036765@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
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

From: Ma Jun <Jun.Ma2@amd.com>

commit e0b26b9482461e9528552f54fa662c2269f75b3f upstream.

Because the value of man->size is changed during suspend/resume process,
use mgr->mm.size instead of man->size here for lpfn checking.

Signed-off-by: Ma Jun <Jun.Ma2@amd.com>
Suggested-by: Christian König <christian.koenig@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220914125331.2467162-1-Jun.Ma2@amd.com
Signed-off-by: Christian König <christian.koenig@amd.com>
Cc: "Limonciello, Mario" <Mario.Limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
@@ -435,7 +435,7 @@ static int amdgpu_vram_mgr_new(struct tt
 	if (place->flags & TTM_PL_FLAG_TOPDOWN)
 		vres->flags |= DRM_BUDDY_TOPDOWN_ALLOCATION;
 
-	if (fpfn || lpfn != man->size)
+	if (fpfn || lpfn != mgr->mm.size)
 		/* Allocate blocks in desired range */
 		vres->flags |= DRM_BUDDY_RANGE_ALLOCATION;
 


