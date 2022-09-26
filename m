Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C333C5EA5DC
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 14:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235511AbiIZMXx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 08:23:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235428AbiIZMXY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 08:23:24 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F160E726A9;
        Mon, 26 Sep 2022 04:05:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2EF44CE1119;
        Mon, 26 Sep 2022 10:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4831CC433C1;
        Mon, 26 Sep 2022 10:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189413;
        bh=ON79Ezb0W4s0GNf/NoqKu+FimfoSIUQjcZclqHc3mXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lUFgjLXT/BCIzWCh/YyBnOunHKxYhw5alYQyaW/UGwg76Z3WI3D58Dxeomgo6bHpR
         sVMk5DgIr977na1NHhcGFh0O/GvJrLOBSS6npn/FK8/yozf+Voewg97RCTGXu+opnQ
         ytAjQDaznUqPKDJSmCDO5rBssnkvFTOg+xvquN2c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Candice Li <candice.li@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 180/207] drm/amdgpu: Skip reset error status for psp v13_0_0
Date:   Mon, 26 Sep 2022 12:12:49 +0200
Message-Id: <20220926100814.672275789@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Candice Li <candice.li@amd.com>

[ Upstream commit 86875d558b91cb46f43be112799c06ecce60ec1e ]

No need to reset error status since only umc ras supported on psp v13_0_0.

Signed-off-by: Candice Li <candice.li@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
index dac202ae864d..9193ca5d6fe7 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
@@ -1805,7 +1805,8 @@ static void amdgpu_ras_log_on_err_counter(struct amdgpu_device *adev)
 		amdgpu_ras_query_error_status(adev, &info);
 
 		if (adev->ip_versions[MP0_HWIP][0] != IP_VERSION(11, 0, 2) &&
-		    adev->ip_versions[MP0_HWIP][0] != IP_VERSION(11, 0, 4)) {
+		    adev->ip_versions[MP0_HWIP][0] != IP_VERSION(11, 0, 4) &&
+		    adev->ip_versions[MP0_HWIP][0] != IP_VERSION(13, 0, 0)) {
 			if (amdgpu_ras_reset_error_status(adev, info.head.block))
 				dev_warn(adev->dev, "Failed to reset error counter and error status");
 		}
-- 
2.35.1



