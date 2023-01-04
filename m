Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83FE065D7EB
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:08:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239590AbjADQIS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:08:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239776AbjADQIO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:08:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A16A33C383
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:08:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64ACBB81714
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:08:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA676C433EF;
        Wed,  4 Jan 2023 16:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672848490;
        bh=M9OzY5yiLHSLZnyefPAYocob9L9uO0naltWvhyTEApc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sZQQcUrTJnGZS62csLSSJ9YvhOYQ1nV1pKSeRC3Tx82h5ZZnFFWqxP+OCKwjyjzBq
         1X/Rtiqc/ERF8o9gv3rf2BskCQ7tdc/2zoZNAvqtyzt1NUy3DZ4toEGCOD4Ec2iRly
         6M8EATO+csNlKPDvAt2G+QCfWcMEbK3PDeJ6oIxo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mario Limonciello <mario.limonciello@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 001/207] drm/amdgpu: skip MES for S0ix as well since its part of GFX
Date:   Wed,  4 Jan 2023 17:04:19 +0100
Message-Id: <20230104160511.953759683@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
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

commit afa6646b1c5d3affd541f76bd7476e4b835a9174 upstream.

It's also part of gfxoff.

Cc: stable@vger.kernel.org # 6.0, 6.1
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -3005,14 +3005,15 @@ static int amdgpu_device_ip_suspend_phas
 			continue;
 		}
 
-		/* skip suspend of gfx and psp for S0ix
+		/* skip suspend of gfx/mes and psp for S0ix
 		 * gfx is in gfxoff state, so on resume it will exit gfxoff just
 		 * like at runtime. PSP is also part of the always on hardware
 		 * so no need to suspend it.
 		 */
 		if (adev->in_s0ix &&
 		    (adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_PSP ||
-		     adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_GFX))
+		     adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_GFX ||
+		     adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_MES))
 			continue;
 
 		/* XXX handle errors */


