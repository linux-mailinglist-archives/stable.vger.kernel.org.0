Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3FB15219D3
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244935AbiEJNvd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:51:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244981AbiEJNrK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:47:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2345C2380EF;
        Tue, 10 May 2022 06:33:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B42DF6188A;
        Tue, 10 May 2022 13:33:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4477C385A6;
        Tue, 10 May 2022 13:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189592;
        bh=Z0xWQbgeZcOMALo5oszoheDr4ixi8SXV4KCqIovGVEI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sjMDT3eLcDYhvvNoP83By5GqKE2dfrFxBLTgvr0qpYGLetqBcBGb5ngWFcGgKTEDJ
         5afq7QnE541HCUAjbh6vZYpgzlHglDwNdNv4TJhI7iV3AjDlCZA6DE0QcS+PQPH9PO
         5HGECirpnRsL9Oy2ukxVNOh9a9stkT8z0+jKQWgg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mario Limonciello <mario.limonciello@amd.com>,
        Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        "Limonciello, Mario" <Mario.Limonciello@amd.com>
Subject: [PATCH 5.15 083/135] drm/amdgpu: explicitly check for s0ix when evicting resources
Date:   Tue, 10 May 2022 15:07:45 +0200
Message-Id: <20220510130742.793338598@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130740.392653815@linuxfoundation.org>
References: <20220510130740.392653815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Limonciello <mario.limonciello@amd.com>

commit e53d9665ab003df0ece8f869fcd3c2bbbecf7190 upstream.

This codepath should be running in both s0ix and s3, but only does
currently because s3 and s0ix are both set in the s0ix case.

Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Acked-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: "Limonciello, Mario" <Mario.Limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -3939,8 +3939,8 @@ void amdgpu_device_fini_sw(struct amdgpu
  */
 static void amdgpu_device_evict_resources(struct amdgpu_device *adev)
 {
-	/* No need to evict vram on APUs for suspend to ram */
-	if (adev->in_s3 && (adev->flags & AMD_IS_APU))
+	/* No need to evict vram on APUs for suspend to ram or s2idle */
+	if ((adev->in_s3 || adev->in_s0ix) && (adev->flags & AMD_IS_APU))
 		return;
 
 	if (amdgpu_ttm_evict_resources(adev, TTM_PL_VRAM))


