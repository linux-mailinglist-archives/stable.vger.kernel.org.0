Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64F3B261A07
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 20:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731461AbgIHS3t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 14:29:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:56076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731399AbgIHQKZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:10:25 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 907412472E;
        Tue,  8 Sep 2020 15:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579649;
        bh=6qJvNmDRGejfAYEx5lKKBTmGe5r4//5E/gkQqoHT9U4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E2Jy/8EQ/b2q0ul7PYg7oOvHdEekXFfBsNMRr9A3FJwgIHqdoBfc1FpXBIzHawlhV
         Alf/aigqYMVDimkL+n0ILZaKRAowUGbLLnpEMkBhnY4x0NPsmffatC+HThoPP656gh
         b7JZpy/MI1fAusFJIDbF/4sXWmRcIPIF/8k6enZo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sandeep Raghuraman <sandy.8925@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.8 164/186] drm/amdgpu: Specify get_argument function for ci_smu_funcs
Date:   Tue,  8 Sep 2020 17:25:06 +0200
Message-Id: <20200908152249.612808835@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sandeep Raghuraman <sandy.8925@gmail.com>

commit f7b2e34b4afb8d712913dc199d3292ea9e078637 upstream.

Starting in Linux 5.8, the graphics and memory clock frequency were not being
reported for CIK cards. This is a regression, since they were reported correctly
in Linux 5.7.

After investigation, I discovered that the smum_send_msg_to_smc() function,
attempts to call the corresponding get_argument() function of ci_smu_funcs.
However, the get_argument() function is not defined in ci_smu_funcs.

This patch fixes the bug by specifying the correct get_argument() function.

Fixes: a0ec225633d9f6 ("drm/amd/powerplay: unified interfaces for message issuing and response checking")
Signed-off-by: Sandeep Raghuraman <sandy.8925@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/powerplay/smumgr/ci_smumgr.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/amd/powerplay/smumgr/ci_smumgr.c
+++ b/drivers/gpu/drm/amd/powerplay/smumgr/ci_smumgr.c
@@ -37,6 +37,7 @@
 #include "cgs_common.h"
 #include "atombios.h"
 #include "pppcielanes.h"
+#include "smu7_smumgr.h"
 
 #include "smu/smu_7_0_1_d.h"
 #include "smu/smu_7_0_1_sh_mask.h"
@@ -2948,6 +2949,7 @@ const struct pp_smumgr_func ci_smu_funcs
 	.request_smu_load_specific_fw = NULL,
 	.send_msg_to_smc = ci_send_msg_to_smc,
 	.send_msg_to_smc_with_parameter = ci_send_msg_to_smc_with_parameter,
+	.get_argument = smu7_get_argument,
 	.download_pptable_settings = NULL,
 	.upload_pptable_settings = NULL,
 	.get_offsetof = ci_get_offsetof,


