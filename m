Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D82465BAAEC
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 12:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231478AbiIPKPF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 06:15:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231616AbiIPKN7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 06:13:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D56A96F57A;
        Fri, 16 Sep 2022 03:10:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4618B82518;
        Fri, 16 Sep 2022 10:10:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54CCAC433C1;
        Fri, 16 Sep 2022 10:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663323025;
        bh=lRYtQB69EtfQRubg8vFLUURPMKviBMHdbvGlQzE+pyY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HHy9qVlIGltDrUoINB5XwDZy+oLaBIs4etQU6T2fH77Ikl+SkYM2eJvrP90d/grlQ
         6Lkdlp3OBXDmvy5cSbJf1cGF35Jn5eHN453xidW6VvDbKTkzPbrCkaAFHuJ2NF8mHs
         ZV/Lt9gP3P67xSKOMoGzjGIgo+Lqwc0mwxMOSpSI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chengming Gui <Jack.Gui@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 15/24] drm/amd/amdgpu: skip ucode loading if ucode_size == 0
Date:   Fri, 16 Sep 2022 12:08:40 +0200
Message-Id: <20220916100446.047884480@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220916100445.354452396@linuxfoundation.org>
References: <20220916100445.354452396@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Chengming Gui <Jack.Gui@amd.com>

[ Upstream commit 39c84b8e929dbd4f63be7e04bf1a2bcd92b44177 ]

Restrict the ucode loading check to avoid frontdoor loading error.

Signed-off-by: Chengming Gui <Jack.Gui@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
index ae84d3b582aa5..8a2abcfd5a889 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -1921,7 +1921,7 @@ static int psp_load_smu_fw(struct psp_context *psp)
 static bool fw_load_skip_check(struct psp_context *psp,
 			       struct amdgpu_firmware_info *ucode)
 {
-	if (!ucode->fw)
+	if (!ucode->fw || !ucode->ucode_size)
 		return true;
 
 	if (ucode->ucode_id == AMDGPU_UCODE_ID_SMC &&
-- 
2.35.1



