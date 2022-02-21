Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5219B4BE262
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:55:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348135AbiBUJXp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:23:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350402AbiBUJWa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:22:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B08BDFF4;
        Mon, 21 Feb 2022 01:10:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF08C6097C;
        Mon, 21 Feb 2022 09:10:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9D1AC340EB;
        Mon, 21 Feb 2022 09:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434600;
        bh=8PHSfbSFw3lo5uJLbK+AnrOXMEOu7hVwjAb8jPJw4Sw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LI3wUl1jq+SRzMGOkt6dWoRW1iDFOth64hmX/m04aK4CeXr38S/5z3wBF1fnKJ5qi
         K0SJbbiFovlriVxll/r3TsW2YcGq+/TFVprIrygX213Pz+1HlKjvj2PnRL6XZERaQ8
         +d2oGutdPDJbNHwJBAlQ8qarDLE72Ppl7iERsuNk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mario Limonciello <mario.limonciello@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Rajib Mahapatra <rajib.mahapatra@amd.com>
Subject: [PATCH 5.15 064/196] drm/amdgpu: skipping SDMA hw_init and hw_fini for S0ix.
Date:   Mon, 21 Feb 2022 09:48:16 +0100
Message-Id: <20220221084933.080515591@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
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

From: Rajib Mahapatra <rajib.mahapatra@amd.com>

commit f8f4e2a518347063179def4e64580b2d28233d03 upstream.

[Why]
SDMA ring buffer test failed if suspend is aborted during
S0i3 resume.

[How]
If suspend is aborted for some reason during S0i3 resume
cycle, it follows SDMA ring test failing and errors in amdgpu
resume. For RN/CZN/Picasso, SMU saves and restores SDMA
registers during S0ix cycle. So, skipping SDMA suspend and
resume from driver solves the issue. This time, the system
is able to resume gracefully even the suspend is aborted.

Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Rajib Mahapatra <rajib.mahapatra@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
@@ -2062,6 +2062,10 @@ static int sdma_v4_0_suspend(void *handl
 {
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
 
+	/* SMU saves SDMA state for us */
+	if (adev->in_s0ix)
+		return 0;
+
 	return sdma_v4_0_hw_fini(adev);
 }
 
@@ -2069,6 +2073,10 @@ static int sdma_v4_0_resume(void *handle
 {
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
 
+	/* SMU restores SDMA state for us */
+	if (adev->in_s0ix)
+		return 0;
+
 	return sdma_v4_0_hw_init(adev);
 }
 


