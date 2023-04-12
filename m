Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 452DD6DEEF4
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231130AbjDLIqh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:46:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231161AbjDLIqa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:46:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C6627AA7
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:46:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D267630F9
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:46:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F7C8C433EF;
        Wed, 12 Apr 2023 08:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289168;
        bh=M0pOMAesmv9+NrTgGaXjIPREvL0v4vzo8Aqvu0uGCus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V1D4uIW5DqiEAG/4NJB43dWiTx9LWlFan5qsQu6iCHULGmi18XkUD9FpfYj/r45JF
         EUM2c7Rw5tNVz9bvU2q7uY56rUwCL5GqG36R4eyvHYDNShCPwAxBRsdayaH6wmPngc
         P/t0Dtu7B7VdbtwivtpDNgkgB3eFQMYqRkoAd5Zo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mario Limonciello <mario.limonciello@amd.com>,
        Rajneesh Bhardwaj <rajneesh.bhardwaj@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        "Limonciello, Mario" <Mario.Limonciello@amd.com>
Subject: [PATCH 6.1 144/164] drm/amdgpu: for S0ix, skip SDMA 5.x+ suspend/resume
Date:   Wed, 12 Apr 2023 10:34:26 +0200
Message-Id: <20230412082842.730050483@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

commit 2a7798ea7390fd78f191c9e9bf68f5581d3b4a02 upstream.

SDMA 5.x is part of the GFX block so it's controlled via
GFXOFF.  Skip suspend as it should be handled the same
as GFX.

v2: drop SDMA 4.x.  That requires special handling.

Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Acked-by: Rajneesh Bhardwaj <rajneesh.bhardwaj@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: "Limonciello, Mario" <Mario.Limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -3034,6 +3034,12 @@ static int amdgpu_device_ip_suspend_phas
 		     adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_MES))
 			continue;
 
+		/* SDMA 5.x+ is part of GFX power domain so it's covered by GFXOFF */
+		if (adev->in_s0ix &&
+		    (adev->ip_versions[SDMA0_HWIP][0] >= IP_VERSION(5, 0, 0)) &&
+		    (adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_SDMA))
+			continue;
+
 		/* XXX handle errors */
 		r = adev->ip_blocks[i].version->funcs->suspend(adev);
 		/* XXX handle errors */


