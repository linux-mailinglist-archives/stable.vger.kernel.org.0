Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7856AEBD2
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:49:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232173AbjCGRtS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:49:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232238AbjCGRsq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:48:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BA0198E9B
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:43:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7BA21614FF
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:43:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95C71C433D2;
        Tue,  7 Mar 2023 17:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211015;
        bh=/SVtR0+JHOmhMrV2LTdPx4L5lYPsfb4KeJx0JuNTBE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rCmh8ciaqDNJpmYB8Gr2vz+WJlejS3mGfM7VeiLj2+jFZ1dASppzvMRM+OwZU5Wwp
         NP0akEGnoxJQDE0k2iiNmZp3f7gK7aPMYM6gICpfmowr4LyFrUvvbWQE4j+kUceEeg
         ap/sSMWoLL7MN72aiPxIwMLhqUYvBxV9YRUkgBIE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alex Deucher <alexander.deucher@amd.com>,
        Lijo Lazar <lijo.lazar@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0696/1001] drm/amd: Avoid BUG() for case of SRIOV missing IP version
Date:   Tue,  7 Mar 2023 17:57:48 +0100
Message-Id: <20230307170051.823466791@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 93fec4f8c158584065134b4d45e875499bf517c8 ]

No need to crash the kernel.  AMDGPU will now fail to probe.

Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
index 7a2fc920739bb..ba092072308fa 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -380,7 +380,7 @@ static int psp_init_sriov_microcode(struct psp_context *psp)
 		adev->virt.autoload_ucode_id = AMDGPU_UCODE_ID_CP_MES1_DATA;
 		break;
 	default:
-		BUG();
+		ret = -EINVAL;
 		break;
 	}
 	return ret;
-- 
2.39.2



