Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18A2F499E20
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:07:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1587658AbiAXW3Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:29:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1582577AbiAXWPa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:15:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00A73C0E263F;
        Mon, 24 Jan 2022 12:44:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BCAECB810BD;
        Mon, 24 Jan 2022 20:44:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0E40C340E5;
        Mon, 24 Jan 2022 20:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057087;
        bh=d1hkeXXrifR0cTOtk0pASdzSQrHKudV+b+y9Amq7KG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XQZ27UyzFb7uhRFvc1uGHhNAQZzsmGFlgMNo7t2iGLzpubq1ynRCycg2t3emGDzgk
         +x5sO1pTjEPhm2pLheeMDG9mZ5E3mlTRJOFEzZn6P3HFVlEXBPRGSbvU1aZbiTMhwv
         owqYUORdckWMf1wBSBkUcaTcJEsrxCjGgw1QuOn0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 698/846] drm/amdgpu: dont do resets on APUs which dont support it
Date:   Mon, 24 Jan 2022 19:43:35 +0100
Message-Id: <20220124184125.131911663@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

commit e8309d50e97851ff135c4e33325d37b032666b94 upstream.

It can cause a hang.  This is normally not enabled for GPU
hangs on these asics, but was recently enabled for handling
aborted suspends.  This causes hangs on some platforms
on suspend.

Fixes: daf8de0874ab5b ("drm/amdgpu: always reset the asic in suspend (v2)")
Cc: stable@vger.kernel.org
Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1858
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/cik.c |    4 ++++
 drivers/gpu/drm/amd/amdgpu/vi.c  |    4 ++++
 2 files changed, 8 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/cik.c
+++ b/drivers/gpu/drm/amd/amdgpu/cik.c
@@ -1428,6 +1428,10 @@ static int cik_asic_reset(struct amdgpu_
 {
 	int r;
 
+	/* APUs don't have full asic reset */
+	if (adev->flags & AMD_IS_APU)
+		return 0;
+
 	if (cik_asic_reset_method(adev) == AMD_RESET_METHOD_BACO) {
 		dev_info(adev->dev, "BACO reset\n");
 		r = amdgpu_dpm_baco_reset(adev);
--- a/drivers/gpu/drm/amd/amdgpu/vi.c
+++ b/drivers/gpu/drm/amd/amdgpu/vi.c
@@ -956,6 +956,10 @@ static int vi_asic_reset(struct amdgpu_d
 {
 	int r;
 
+	/* APUs don't have full asic reset */
+	if (adev->flags & AMD_IS_APU)
+		return 0;
+
 	if (vi_asic_reset_method(adev) == AMD_RESET_METHOD_BACO) {
 		dev_info(adev->dev, "BACO reset\n");
 		r = amdgpu_dpm_baco_reset(adev);


