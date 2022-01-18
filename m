Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07814491E08
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343922AbiARDqX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 22:46:23 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50332 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347408AbiARClX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:41:23 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5DA3DB81253;
        Tue, 18 Jan 2022 02:41:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B988C36AEB;
        Tue, 18 Jan 2022 02:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473681;
        bh=mzszewQvu+rH1A9pS5GqxEif5yWkdOeZ53lYTxnWPLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lwNaKyShSdlYmTqnSFm0gI5JxDr9IaPwNEEHQwOaCAOCJdx/QRpSDNXIK4lYdKioi
         2VbZ9P2Ga2tdYk9wNat/3TwTqedhDKPpY5CgFO5j58wDUkDk/W5zUP7SLi3lD6vf2h
         tnX/ved8PfZusEmI7ovVm6DSJMrPe3Ml4E9uz8NyS3Oc7bZRyhYhCiiOMSl16RDPfs
         Bsx71oaPbAxuEDqTAQ8VFtRTtGHRI8qHIn5OsoonfZHdwk6xl36DPlkJeTIv6D6P2L
         wuSgzrsv9n1exD/4QKWLPCIQtAZFMsGia0R34jjJa6Du0TVbRqEu+ThuAGT3vcx23/
         59EbJIdEy2GBg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@linux.ie,
        daniel@ffwll.ch, nathan@kernel.org, ndesaulniers@google.com,
        nicholas.kazlauskas@amd.com, Anson.Jacob@amd.com, aric.cyr@amd.com,
        Wayne.Lin@amd.com, michael.strauss@amd.com,
        meenakshikumar.somasundaram@amd.com, haonan.wang2@amd.com,
        Martin.Leung@amd.com, Jimmy.Kizito@amd.com, Eric.Yang2@amd.com,
        lee.jones@linaro.org, Lewis.Huang@amd.com, roy.chan@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 5.10 022/116] drm/amd/display: check top_pipe_to_program pointer
Date:   Mon, 17 Jan 2022 21:38:33 -0500
Message-Id: <20220118024007.1950576-22-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024007.1950576-1-sashal@kernel.org>
References: <20220118024007.1950576-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Li <yang.lee@linux.alibaba.com>

[ Upstream commit a689e8d1f80012f90384ebac9dcfac4201f9f77e ]

Clang static analysis reports this error

drivers/gpu/drm/amd/amdgpu/../display/dc/core/dc.c:2870:7: warning:
Dereference of null pointer [clang-analyzer-core.NullDereference]
                if
(top_pipe_to_program->stream_res.tg->funcs->lock_doublebuffer_enable) {
                    ^

top_pipe_to_program being NULL is caught as an error
But then it is used to report the error.

So add a check before using it.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 284ed1c8a35ac..93f5229c303e7 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -2436,7 +2436,8 @@ static void commit_planes_for_stream(struct dc *dc,
 	}
 
 	if ((update_type != UPDATE_TYPE_FAST) && stream->update_flags.bits.dsc_changed)
-		if (top_pipe_to_program->stream_res.tg->funcs->lock_doublebuffer_enable) {
+		if (top_pipe_to_program &&
+			top_pipe_to_program->stream_res.tg->funcs->lock_doublebuffer_enable) {
 			if (should_use_dmub_lock(stream->link)) {
 				union dmub_hw_lock_flags hw_locks = { 0 };
 				struct dmub_hw_lock_inst_flags inst_flags = { 0 };
-- 
2.34.1

