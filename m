Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DCD85B6F7C
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232823AbiIMOL1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:11:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232740AbiIMOKO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:10:14 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9033758B53;
        Tue, 13 Sep 2022 07:09:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BECA8CE10F7;
        Tue, 13 Sep 2022 14:09:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17FCCC433C1;
        Tue, 13 Sep 2022 14:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078156;
        bh=avKLgB8ycs/5i5FbGLyyAohN1rYc0v6FmHyhCFQT7ME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OuZyVp5sjtMQOd4KQfzK9os6hSB27x1T55ERWer6RZqSc0dRv1A2fM77GRI/Wo0xs
         MAlFfUgMVWu/RZWgxmsSoKiR09Pij9DTKgcZd9GWfo1Y5gh49kog7jOV6K/ps9Xj+q
         0OJ9a7cgK6sygeYQRZuogTI1oJ3GlTDryu2LFK84=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Kuehling <Felix.Kuehling@amd.com>,
        shaoyunl <shaoyun.liu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 016/192] drm/amdgpu: Remove the additional kfd pre reset call for sriov
Date:   Tue, 13 Sep 2022 16:02:02 +0200
Message-Id: <20220913140410.731567502@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: shaoyunl <shaoyun.liu@amd.com>

[ Upstream commit 06671734881af2bcf7f453661b5f8616e32bb3fc ]

The additional call is caused by merge conflict

Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: shaoyunl <shaoyun.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index ea2b74c0fd229..67d4a3c13ed19 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -4475,8 +4475,6 @@ static int amdgpu_device_reset_sriov(struct amdgpu_device *adev,
 retry:
 	amdgpu_amdkfd_pre_reset(adev);
 
-	amdgpu_amdkfd_pre_reset(adev);
-
 	if (from_hypervisor)
 		r = amdgpu_virt_request_full_gpu(adev, true);
 	else
-- 
2.35.1



