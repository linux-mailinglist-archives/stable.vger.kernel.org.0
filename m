Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE19615801
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbiKBCnY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:43:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230322AbiKBCnW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:43:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 491C0E3
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:43:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA54A617A9
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:43:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F01EC433C1;
        Wed,  2 Nov 2022 02:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667356999;
        bh=18izH+nAButBghnQwFux71qhr/dINukLrRwTHGai6GE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WPnwjYrh/3cH2n4uIgyCY2eSTitO8MGHOg4mYCtSjF/aR2Ze115B/sU0wVowIWLS1
         kYWi1+9biurygCcVYcTr12osg4fE4z/7HkXHP+At4EE0xJ7QgrxnmCo2dt5171mztw
         CMuhb15rjPAwmsQ5B51cN1PfvKudnAgfRGj2Ogog=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        "Limonciello, Mario" <Mario.Limonciello@amd.com>
Subject: [PATCH 6.0 059/240] drm/amdgpu: Fix for BO move issue
Date:   Wed,  2 Nov 2022 03:30:34 +0100
Message-Id: <20221102022112.733681826@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>

commit 8273b4048664fff356fd10059033f0e2f5a422a1 upstream.

A user reported a bug on CAPE VERDE system where uvd_v3_1
IP component failed to initialize as there is an issue with
BO move code from one memory to other.

In function amdgpu_mem_visible() called by amdgpu_bo_move(),
when there are no blocks to compare or if we have a single
block then break the loop.

Fixes: 312b4dc11d4f ("drm/amdgpu: Fix VRAM BO swap issue")
Signed-off-by: Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: "Limonciello, Mario" <Mario.Limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -439,6 +439,9 @@ static bool amdgpu_mem_visible(struct am
 	while (cursor.remaining) {
 		amdgpu_res_next(&cursor, cursor.size);
 
+		if (!cursor.remaining)
+			break;
+
 		/* ttm_resource_ioremap only supports contiguous memory */
 		if (end != cursor.start)
 			return false;


