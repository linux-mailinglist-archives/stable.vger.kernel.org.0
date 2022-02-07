Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBAF44ABC90
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:49:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386851AbiBGLhy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:37:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384663AbiBGL3d (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:29:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA8D6C03E90F;
        Mon,  7 Feb 2022 03:27:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81642B80EC3;
        Mon,  7 Feb 2022 11:27:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BB45C340EB;
        Mon,  7 Feb 2022 11:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233271;
        bh=+vD/we64CXzKQ+evO7omnlTqMOtfkb0divxIeNZ98KU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PtJaqYaDgUUNE1IvjAghhoKgpjJHk25WI8HVYBSfZ+jzERWg8GQA/52kp7wj5uczN
         OuZbt27vS1AbYAPo7cH6W8lh7uHt5F8FgisTKcqXe7IEoG81+6C5m+HK/LHS+IWByM
         uunsZgCqezy20yYBmVc3sRBK36QQ2vu8Wnkt4N/s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 5.15 070/110] drm/amd: avoid suspend on dGPUs w/ s2idle support when runtime PM enabled
Date:   Mon,  7 Feb 2022 12:06:43 +0100
Message-Id: <20220207103804.655136591@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103802.280120990@linuxfoundation.org>
References: <20220207103802.280120990@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Mario Limonciello <mario.limonciello@amd.com>

commit e55a3aea418269266d84f426b3bd70794d3389c8 upstream.

dGPUs connected to Intel systems configured for suspend to idle
will not have the power rails cut at suspend and resetting the GPU
may lead to problematic behaviors.

Fixes: e25443d2765f4 ("drm/amdgpu: add a dev_pm_ops prepare callback (v2)")
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/1879
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -1504,8 +1504,7 @@ static int amdgpu_pmops_prepare(struct d
 	 * DPM_FLAG_SMART_SUSPEND works properly
 	 */
 	if (amdgpu_device_supports_boco(drm_dev))
-		return pm_runtime_suspended(dev) &&
-			pm_suspend_via_firmware();
+		return pm_runtime_suspended(dev);
 
 	return 0;
 }


