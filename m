Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6DD6157FB
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:42:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230311AbiKBCmt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbiKBCms (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:42:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71FD820BE3
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:42:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27677B82072
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:42:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C0A7C43470;
        Wed,  2 Nov 2022 02:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667356963;
        bh=BLo5HlDaeTCESuskRpIISrw2S2aFZHcA1uX9uU8EAbg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y3ii/SusnrYgxG9ncQmrPsvY2CdCz2c8vjHIxDTh0oaZWlqr7LhVNpONtOMSjJfW2
         B6eAebGhCZImKVy/uvDvzJyzFbI0zVfwoYt+P6mF6eLACoPNoqgaNmJlvBOA6dTcqZ
         Ca+n2aAdepBkVcIS0G0Y+qUvj8/MiSsLvErqXKcw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chengming Gui <Jack.Gui@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.0 063/240] drm/amdgpu: fix pstate setting issue
Date:   Wed,  2 Nov 2022 03:30:38 +0100
Message-Id: <20221102022112.827290641@linuxfoundation.org>
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

From: Chengming Gui <Jack.Gui@amd.com>

commit 79610d3041338dc1ef554d6fd8b3b3e23be527f5 upstream.

[WHY]
0, original pstate X
1, ctx_A_create -> ctx_A->stable_pstate = X
2, ctx_A_set_pstate (Y) -> current pstate is Y (PEAK or STANDARD)
3, ctx_B_create -> ctx_B->stable_pstate =  Y
4, ctx_A_destroy -> restore pstate to X
5, ctx_B_destroy -> restore pstate to Y
Above sequence will cause final pstate is wrong (Y), should be original X.

[HOW]
When ctx_B create,
if  ctx_A touched pstate setting
(not auto, stable_pstate_ctx != NULL),
set ctx_B->stable_pstate the same value as ctx_A saved,
if stable_pstate_ctx == NULL,
fetch current pstate to fill
ctx_B->stable_pstate.

Signed-off-by: Chengming Gui <Jack.Gui@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c
@@ -327,7 +327,10 @@ static int amdgpu_ctx_init(struct amdgpu
 	if (r)
 		return r;
 
-	ctx->stable_pstate = current_stable_pstate;
+	if (mgr->adev->pm.stable_pstate_ctx)
+		ctx->stable_pstate = mgr->adev->pm.stable_pstate_ctx->stable_pstate;
+	else
+		ctx->stable_pstate = current_stable_pstate;
 
 	return 0;
 }


