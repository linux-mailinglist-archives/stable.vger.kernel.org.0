Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A626565D76B
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 16:44:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235317AbjADPnx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 10:43:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235146AbjADPna (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 10:43:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D30A339F87
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 07:43:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6BBDC61780
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 15:43:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E780C433D2;
        Wed,  4 Jan 2023 15:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672847008;
        bh=eI+JmE+4Kh0YUhVqn2LlrEx0zPP2fBe7A3RNRG0jgEg=;
        h=Subject:To:Cc:From:Date:From;
        b=c9xQFRkfk030lMzQt7FoVrWEXbC/XqLvTX5oqcHDf9TI731uoA9W/lj+vXdpQ5vOT
         IUIGQ4kC6P3r0rvrGQ6qP7YJ/G8J4emznOK9Wngy5Pi78psu99buA92R1dzvPasJPN
         M2gAXAn8YwjAewC1Kkk+1sgqyqi3LF9QRYni31YA=
Subject: FAILED: patch "[PATCH] drm/amdgpu: enable VCN DPG for GC IP v11.0.4" failed to apply to 6.1-stable tree
To:     saleemkhan.jamadar@amd.com, alexander.deucher@amd.com,
        veerabadhran.gopalakrishnan@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 16:43:25 +0100
Message-ID: <1672847005124188@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

e1d900df63ad ("drm/amdgpu: enable VCN DPG for GC IP v11.0.4")
2a0fe2ca6e9c ("drm/amdgpu: Enable pg/cg flags on GC11_0_4 for VCN")
311d52367d0a ("drm/amdgpu: add soc21 common ip block support for GC 11.0.4")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e1d900df63adcb748905131dd6258e570e11aed1 Mon Sep 17 00:00:00 2001
From: Saleemkhan Jamadar <saleemkhan.jamadar@amd.com>
Date: Tue, 20 Dec 2022 13:21:44 +0530
Subject: [PATCH] drm/amdgpu: enable VCN DPG for GC IP v11.0.4

Enable VCN Dynamic Power Gating control for GC IP v11.0.4.

Signed-off-by: Saleemkhan Jamadar <saleemkhan.jamadar@amd.com>
Reviewed-by: Veerabadhran Gopalakrishnan <veerabadhran.gopalakrishnan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.0, 6.1

diff --git a/drivers/gpu/drm/amd/amdgpu/soc21.c b/drivers/gpu/drm/amd/amdgpu/soc21.c
index 7d5fdf450d0c..5562670b7b52 100644
--- a/drivers/gpu/drm/amd/amdgpu/soc21.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc21.c
@@ -666,6 +666,7 @@ static int soc21_common_early_init(void *handle)
 			AMD_CG_SUPPORT_VCN_MGCG |
 			AMD_CG_SUPPORT_JPEG_MGCG;
 		adev->pg_flags = AMD_PG_SUPPORT_VCN |
+			AMD_PG_SUPPORT_VCN_DPG |
 			AMD_PG_SUPPORT_GFX_PG |
 			AMD_PG_SUPPORT_JPEG;
 		adev->external_rev_id = adev->rev_id + 0x1;

