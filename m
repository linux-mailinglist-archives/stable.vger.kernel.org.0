Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63DB9795D3
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389266AbfG2TqU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:46:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:35522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390067AbfG2TqS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:46:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1EBB217D4;
        Mon, 29 Jul 2019 19:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429578;
        bh=CsgfY+e1u5uoRmZEQN7hZu88CVLTpMRvfIJ9CDmdiWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QYAXgo0fwI9DEfvFF3lq7AsjCWZvFLt3RblFznifRS1UO1+p3p3UKG9sCnOx7sW7/
         57FjRO31VUd6bhalJeSJncNM12MlP7zesxGCFggE/mYbC6jl535AdUx8PU6EfmtgxU
         4W7uT52TkOhd+siMCVYpUYEaVZBF2byDdkym3XZE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Hsieh <paul.hsieh@amd.com>,
        Anthony Koo <Anthony.Koo@amd.com>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 028/215] drm/amd/display: Disable ABM before destroy ABM struct
Date:   Mon, 29 Jul 2019 21:20:24 +0200
Message-Id: <20190729190744.923661551@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



