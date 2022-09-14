Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C91975B83DB
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 11:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbiINJEt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 05:04:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231190AbiINJD7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 05:03:59 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 678BB77EA9;
        Wed, 14 Sep 2022 02:02:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E67C6CE1695;
        Wed, 14 Sep 2022 09:02:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF070C433D7;
        Wed, 14 Sep 2022 09:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663146137;
        bh=D6yNkS8/rv3f4Kgw0Cl2PR7CDS5sCEdTlxNUZbRpUZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FUxrWmKVswx5iLQJlNy9mkMpP7c/VG/VATG9p33vmnIAXosH1yEyaReTi0qDV2aa/
         snFxzPn+gdpxcUpVh/QymoZccAoSLXnNW+JyYuDwp9vXFjYM+7dKJxUm2a6qTZzZ/I
         jhY7mEb2reB6cIjU5siELL2mgBYGWZg/osnQidhpRkI81/D/11HWdhoHWLcOmXqNK2
         qAkd0bDiMMSZWovT387H4W+LCfQMbQrF/ZqrQmo12dnSP8dYObIysGQWKRUbfHZgAa
         N3o/vZ1liELjy7VimuMaDBV9C16xbnOtblhiWFm78X/8EkOVzHvcCSwn8wcvezPs1x
         shQTI1EUAME+A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guchun Chen <guchun.chen@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        Hawking.Zhang@amd.com, Likun.Gao@amd.com, john.clements@amd.com,
        candice.li@amd.com, tao.zhou1@amd.com, Bokun.Zhang@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.19 20/22] drm/amdgpu: prevent toc firmware memory leak
Date:   Wed, 14 Sep 2022 05:01:01 -0400
Message-Id: <20220914090103.470630-20-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220914090103.470630-1-sashal@kernel.org>
References: <20220914090103.470630-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guchun Chen <guchun.chen@amd.com>

[ Upstream commit aac4cec1ec45d72bd03eaf3fd772c5a609f5ed26 ]

It's missed in psp fini.

Signed-off-by: Guchun Chen <guchun.chen@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
index e9411c28d88ba..9cb7d208a09ad 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -481,11 +481,14 @@ static int psp_sw_fini(void *handle)
 		release_firmware(psp->ta_fw);
 		psp->ta_fw = NULL;
 	}
-	if (adev->psp.cap_fw) {
+	if (psp->cap_fw) {
 		release_firmware(psp->cap_fw);
 		psp->cap_fw = NULL;
 	}
-
+	if (psp->toc_fw) {
+		release_firmware(psp->toc_fw);
+		psp->toc_fw = NULL;
+	}
 	if (adev->ip_versions[MP0_HWIP][0] == IP_VERSION(11, 0, 0) ||
 	    adev->ip_versions[MP0_HWIP][0] == IP_VERSION(11, 0, 7))
 		psp_sysfs_fini(adev);
-- 
2.35.1

