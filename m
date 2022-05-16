Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87608529151
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346490AbiEPULc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:11:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351103AbiEPUCC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 16:02:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBEE05F84;
        Mon, 16 May 2022 12:58:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7DEB5B81611;
        Mon, 16 May 2022 19:58:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF13AC34100;
        Mon, 16 May 2022 19:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652731132;
        bh=HmGUBe0x93Fyp4SHu7EWZrecH5EDBrIut2MMvpPE8Q4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DzmbyuTLll1A1lsz6/6fc0csW1G4LRlXvdDztrfEQEs1BkV6Fy8K6JiOhVQCBxk3K
         /ELhqH0toc4HExBJpf0pZ+4hSRRksucliDM0gF+MLXoBuGAFQ/bcMKO3pH+1ZeCyHj
         QghEWDRe+C+WxLR0V36SR+WzKlSfZBYAimQRNAQ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lijo Lazar <lijo.lazar@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.17 110/114] Revert "drm/amd/pm: keep the BACO feature enabled for suspend"
Date:   Mon, 16 May 2022 21:37:24 +0200
Message-Id: <20220516193628.632120218@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193625.489108457@linuxfoundation.org>
References: <20220516193625.489108457@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

commit a56f445f807b0276fc0660c330bf93a9ea78e8ea upstream.

This reverts commit eaa090538e8d21801c6d5f94590c3799e6a528b5.

Commit ebc002e3ee78 ("drm/amdgpu: don't use BACO for reset in S3")
stops using BACO for reset during suspend, so it's no longer
necessary to leave BACO enabled during suspend.  This fixes
resume from suspend on the navy flounder dGPU in the ASUS ROG
Strix G513QY.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2008
Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1982
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
@@ -1405,14 +1405,8 @@ static int smu_disable_dpms(struct smu_c
 {
 	struct amdgpu_device *adev = smu->adev;
 	int ret = 0;
-	/*
-	 * TODO: (adev->in_suspend && !adev->in_s0ix) is added to pair
-	 * the workaround which always reset the asic in suspend.
-	 * It's likely that workaround will be dropped in the future.
-	 * Then the change here should be dropped together.
-	 */
 	bool use_baco = !smu->is_apu &&
-		(((amdgpu_in_reset(adev) || (adev->in_suspend && !adev->in_s0ix)) &&
+		((amdgpu_in_reset(adev) &&
 		  (amdgpu_asic_reset_method(adev) == AMD_RESET_METHOD_BACO)) ||
 		 ((adev->in_runpm || adev->in_s4) && amdgpu_asic_supports_baco(adev)));
 


