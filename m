Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB9E4124D6
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381534AbhITSic (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:38:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:53062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1380105AbhITSgX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:36:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0186B61462;
        Mon, 20 Sep 2021 17:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158959;
        bh=R8WwoA9dgNBx8r/MeqzbMfPPh/4rnNix0yGpnXR+tX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SS4ZGoQ7TI4yUYfjpx4LdoctmXm27J9y5LzfJLeWU7WG8i+N2EOD5iMveljfzllC7
         +B3Cdq2cNcV4lQGWyHUpAKMvru6TBP7Bgrs6jzdiIuUmEMLxeOEHfIPUgrPeZk9QS1
         yUt4PouEuuzbV9v2DifxTqjqwPG1n2FTEe1kqcCE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Aaron Liu <aaron.liu@amd.com>,
        Harry Wentland <harry.wentland@amd.com>
Subject: [PATCH 5.14 012/168] drm/amd/display: Fix white screen page fault for gpuvm
Date:   Mon, 20 Sep 2021 18:42:30 +0200
Message-Id: <20210920163922.056034928@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

commit a70939851f9ced298dc7d523374b8c4d05239caf upstream.

[Why]
The "base_addr_is_mc_addr" field was added for dcn3.1 support but
pa_config was never updated to set it to false.

Uninitialized memory causes it to be set to true which results in
address mistranslation and white screen.

[How]
Use memset to ensure all fields are initialized to 0 by default.

Fixes: 64b1d0e8d500 ("drm/amd/display: Add DCN3.1 HWSEQ")
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Acked-by: Aaron Liu <aaron.liu@amd.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -998,6 +998,8 @@ static void mmhub_read_system_context(st
 	uint32_t agp_base, agp_bot, agp_top;
 	PHYSICAL_ADDRESS_LOC page_table_start, page_table_end, page_table_base;
 
+	memset(pa_config, 0, sizeof(*pa_config));
+
 	logical_addr_low  = min(adev->gmc.fb_start, adev->gmc.agp_start) >> 18;
 	pt_base = amdgpu_gmc_pd_addr(adev->gart.bo);
 


