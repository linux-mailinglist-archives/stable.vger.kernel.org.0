Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA6B36DE2A
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730795AbfGSEIH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:08:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:42142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726688AbfGSEIG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:08:06 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E8B8206DD;
        Fri, 19 Jul 2019 04:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509285;
        bh=/xHTl3zMoUagmM29NjxJWUm890kiOPGqTy99nxdmUAk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d2rK0D+pu5rCA0A43cNQxBvy0LWxFaqzMWQ8xhl1mRrgwJWd8OiJ9Hq1Q7fCdr1Hm
         xWBt/9fa894DHAG0gF9Dt358LN6i+Yf4DKGjJvr20P+EaG/bSaBF7ScRKTN9rEYynk
         mzNwerdIN2wfCBf0nTh8bYcsU249NTv7g+KrmMvQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paul Hsieh <paul.hsieh@amd.com>, Anthony Koo <Anthony.Koo@amd.com>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 012/101] drm/amd/display: Disable ABM before destroy ABM struct
Date:   Fri, 19 Jul 2019 00:06:03 -0400
Message-Id: <20190719040732.17285-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719040732.17285-1-sashal@kernel.org>
References: <20190719040732.17285-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Hsieh <paul.hsieh@amd.com>

[ Upstream commit 1090d58d4815b1fcd95a80987391006c86398b4c ]

[Why]
When disable driver, OS will set backlight optimization
then do stop device.  But this flag will cause driver to
enable ABM when driver disabled.

[How]
Send ABM disable command before destroy ABM construct

Signed-off-by: Paul Hsieh <paul.hsieh@amd.com>
Reviewed-by: Anthony Koo <Anthony.Koo@amd.com>
Acked-by: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dce/dce_abm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dce/dce_abm.c b/drivers/gpu/drm/amd/display/dc/dce/dce_abm.c
index 29294db1a96b..070ab56a8aca 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dce_abm.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_abm.c
@@ -474,6 +474,8 @@ void dce_abm_destroy(struct abm **abm)
 {
 	struct dce_abm *abm_dce = TO_DCE_ABM(*abm);
 
+	abm_dce->base.funcs->set_abm_immediate_disable(*abm);
+
 	kfree(abm_dce);
 	*abm = NULL;
 }
-- 
2.20.1

