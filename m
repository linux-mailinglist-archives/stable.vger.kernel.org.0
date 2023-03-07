Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEC1A6AF13A
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233092AbjCGSl0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:41:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233088AbjCGSlE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:41:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25041C220D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:31:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB907B819F9
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:29:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19554C433A1;
        Tue,  7 Mar 2023 18:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213779;
        bh=BP0SfKB7cBDQGHplT9Kn9rPAtTu5NHZ4y45KJYtSqDc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vl6ivS25eTLMpci+vb0keTJ9CFnWy1fJSckphBQ7Ew9pJUaDQKLvsQQoLImBzGuV5
         LQTycXmSyLzCaaQMTxWG7kxLuBMlYaI4YptyWzeLWCh03cGYtK3K0Ptd3XRkd8dAt0
         3fa2P/Xd0sTVqk2dCnaiZHM50oObmPiDY12VEh3g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        Alan Liu <HaoPing.Liu@amd.com>, Roman Li <roman.li@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 617/885] drm/amd/display: Set hvm_enabled flag for S/G mode
Date:   Tue,  7 Mar 2023 17:59:11 +0100
Message-Id: <20230307170029.089846914@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roman Li <roman.li@amd.com>

[ Upstream commit 40e9f3f067bc6fb47b878f8ba0a9cc7b93abbf49 ]

[Why]
After enabling S/G on dcn314 a screen corruption may be observed.
HostVM flag should be set in S/G mode to be included in DML calculations.

[How]
In S/G mode gpu_vm_support flag is set.
Use its value to init is_hvm_enabled.

Reviewed-by: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Acked-by: Alan Liu <HaoPing.Liu@amd.com>
Signed-off-by: Roman Li <roman.li@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 25ffc51ae6fa7..050e7a52c8f62 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1240,7 +1240,7 @@ static void mmhub_read_system_context(struct amdgpu_device *adev, struct dc_phy_
 	pa_config->gart_config.page_table_end_addr = page_table_end.quad_part << 12;
 	pa_config->gart_config.page_table_base_addr = page_table_base.quad_part;
 
-	pa_config->is_hvm_enabled = 0;
+	pa_config->is_hvm_enabled = adev->mode_info.gpu_vm_support;
 
 }
 
-- 
2.39.2



