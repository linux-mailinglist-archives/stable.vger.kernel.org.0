Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5E575219B2
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242373AbiEJNup (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:50:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245030AbiEJNrM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:47:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4311C62206;
        Tue, 10 May 2022 06:33:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F36C9B81D24;
        Tue, 10 May 2022 13:33:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47290C385A6;
        Tue, 10 May 2022 13:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189625;
        bh=bzqli6wHMqa6fSFnhXTYiXjyfTUibBvqBc9rZjwUU/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TN9I64OxK0O1Gza6+51K46mKvgDfjkQpslvkMOSMTeVnvAw28hxLvXak/MAxl5zC5
         sM6wPAsmRJIFspd2mwZLJr13djCeI352ZmwR/zJCGrIZSD/BiS29VeN4pIMDvUNiEf
         YK9IaZx8FHsgpI0rvxBR2MwOlR1Wnp7zVC25tlsI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mario Limonciello <mario.limonciello@amd.com>,
        Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 084/135] drm/amdgpu: dont set s3 and s0ix at the same time
Date:   Tue, 10 May 2022 15:07:46 +0200
Message-Id: <20220510130742.821409946@linuxfoundation.org>
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

commit eac4c54bf7f17fb4681b85e5fe383b74d6261a2b upstream.

This makes it clearer which codepaths are in use specifically in
one state or the other.

Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Acked-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -2250,9 +2250,9 @@ static int amdgpu_pmops_suspend(struct d
 
 	if (amdgpu_acpi_is_s0ix_active(adev))
 		adev->in_s0ix = true;
-	adev->in_s3 = true;
+	else
+		adev->in_s3 = true;
 	r = amdgpu_device_suspend(drm_dev, true);
-	adev->in_s3 = false;
 	if (r)
 		return r;
 	if (!adev->in_s0ix)
@@ -2269,6 +2269,8 @@ static int amdgpu_pmops_resume(struct de
 	r = amdgpu_device_resume(drm_dev, true);
 	if (amdgpu_acpi_is_s0ix_active(adev))
 		adev->in_s0ix = false;
+	else
+		adev->in_s3 = false;
 	return r;
 }
 


