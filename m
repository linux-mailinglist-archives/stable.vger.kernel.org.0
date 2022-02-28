Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADF6A4C74AC
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:45:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238673AbiB1RqN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:46:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239646AbiB1Ro0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:44:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5823589CDE;
        Mon, 28 Feb 2022 09:36:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2070B815C2;
        Mon, 28 Feb 2022 17:36:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16E01C340F6;
        Mon, 28 Feb 2022 17:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069806;
        bh=VQdY0C3fKQDElC+gRi2LMy2/1Au1SFhhlrXAKAmiWyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZJpGqgdD0Bo6KxGtj/+ffoP04zvEjdkig5Wx5F6klU9rSk70E4NyBbd30WOKrHo4S
         AeO5j3cN9/tdxvJjAou6dwTXedQ9VeXobrKZBCdN5lIrrzcOzIZIy0G3PB3iqJICZg
         kUW3vUPKxiLaRAMEZL5idtqsoclCTmB6QIn32kd0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen Gong <curry.gong@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 5.15 019/139] drm/amdgpu: do not enable asic reset for raven2
Date:   Mon, 28 Feb 2022 18:23:13 +0100
Message-Id: <20220228172349.920321831@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172347.614588246@linuxfoundation.org>
References: <20220228172347.614588246@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen Gong <curry.gong@amd.com>

commit 1e2be869c8a7247a7253ef4f461f85e2f5931b95 upstream.

The GPU reset function of raven2 is not maintained or tested, so it should be
very unstable.

Now the amdgpu_asic_reset function is added to amdgpu_pmops_suspend, which
causes the S3 test of raven2 to fail, so the asic_reset of raven2 is ignored
here.

Fixes: daf8de0874ab5b ("drm/amdgpu: always reset the asic in suspend (v2)")
Signed-off-by: Chen Gong <curry.gong@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/soc15.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/soc15.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc15.c
@@ -607,8 +607,8 @@ soc15_asic_reset_method(struct amdgpu_de
 static int soc15_asic_reset(struct amdgpu_device *adev)
 {
 	/* original raven doesn't have full asic reset */
-	if ((adev->apu_flags & AMD_APU_IS_RAVEN) &&
-	    !(adev->apu_flags & AMD_APU_IS_RAVEN2))
+	if ((adev->apu_flags & AMD_APU_IS_RAVEN) ||
+	    (adev->apu_flags & AMD_APU_IS_RAVEN2))
 		return 0;
 
 	switch (soc15_asic_reset_method(adev)) {


