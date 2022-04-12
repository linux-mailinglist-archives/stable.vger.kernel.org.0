Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 867584FDB4E
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347800AbiDLHgc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:36:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354096AbiDLH0D (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:26:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C57B19292;
        Tue, 12 Apr 2022 00:05:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 169BFB81B4D;
        Tue, 12 Apr 2022 07:05:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8370AC385A8;
        Tue, 12 Apr 2022 07:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747138;
        bh=RThewDuSSaDhfeV7W7Ch/9tNuzdmzLS9RuWbGQ+yvVI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wxw0AtokIJul/pGuabouMeJqRJuvP8tR5dxqMU2uMYjwuMHxK5PpVp9nbexnkAlFN
         dIMqoUPMWDhZVNO5SD0mhqsOkwcWexYn+db3wK/8PA0SFP1F8dfK6CKUfilRYha2qH
         rMgWJJZxtZp/ubuHMYBhyd1p2kv2WA4YMJ2Tcctk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lijo Lazar <lijo.lazar@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.16 258/285] drm/amdgpu: dont use BACO for reset in S3
Date:   Tue, 12 Apr 2022 08:31:55 +0200
Message-Id: <20220412062951.107616504@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

commit ebc002e3ee78409c42156e62e4e27ad1d09c5a75 upstream.

Seems to cause a reboots or hangs on some systems.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1924
Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1953
Fixes: daf8de0874ab5b ("drm/amdgpu: always reset the asic in suspend (v2)")
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/amdgpu_dpm.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/gpu/drm/amd/pm/amdgpu_dpm.c
+++ b/drivers/gpu/drm/amd/pm/amdgpu_dpm.c
@@ -1045,6 +1045,17 @@ bool amdgpu_dpm_is_baco_supported(struct
 
 	if (!pp_funcs || !pp_funcs->get_asic_baco_capability)
 		return false;
+	/* Don't use baco for reset in S3.
+	 * This is a workaround for some platforms
+	 * where entering BACO during suspend
+	 * seems to cause reboots or hangs.
+	 * This might be related to the fact that BACO controls
+	 * power to the whole GPU including devices like audio and USB.
+	 * Powering down/up everything may adversely affect these other
+	 * devices.  Needs more investigation.
+	 */
+	if (adev->in_s3)
+		return false;
 
 	if (pp_funcs->get_asic_baco_capability(pp_handle, &baco_cap))
 		return false;


