Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 192856DF20
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727318AbfGSEdL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:33:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:35556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730474AbfGSEDb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:03:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 46E7820659;
        Fri, 19 Jul 2019 04:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509011;
        bh=mbhikaGMnXf+YnU2b1rwFEnK/QE9o+IzAB7O7T+g2HA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZZanhPKApbZQC9wwTzBYXVX2TrE7y78MqUtJ1S0wr3qqK61Kb3U4WgbwK3NzjYxik
         zou4D6hhnaEsCI8L1pRFvyba0SZ3v4W5KOCMkT4XFi10gOAhJ7TSfoH6KgEml1LIoQ
         woj6InYpM4hIvzj1jUuEzLCp+NM4kfYG33/PP+zI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paul Hsieh <paul.hsieh@amd.com>, Anthony Koo <Anthony.Koo@amd.com>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.1 018/141] drm/amd/display: Disable ABM before destroy ABM struct
Date:   Fri, 19 Jul 2019 00:00:43 -0400
Message-Id: <20190719040246.15945-18-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719040246.15945-1-sashal@kernel.org>
References: <20190719040246.15945-1-sashal@kernel.org>
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
index da96229db53a..2959c3c9390b 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dce_abm.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_abm.c
@@ -473,6 +473,8 @@ void dce_abm_destroy(struct abm **abm)
 {
 	struct dce_abm *abm_dce = TO_DCE_ABM(*abm);
 
+	abm_dce->base.funcs->set_abm_immediate_disable(*abm);
+
 	kfree(abm_dce);
 	*abm = NULL;
 }
-- 
2.20.1

