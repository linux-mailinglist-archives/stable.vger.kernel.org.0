Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01CE6259709
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729211AbgIAQJx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:09:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:47796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731396AbgIAPig (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:38:36 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF87A20866;
        Tue,  1 Sep 2020 15:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974715;
        bh=n75o0aAf/+BpfFHjMfxty7dAyPCCoLWc4WD/E5h1CFA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nExTYb4W7WoaXjqT7agKcYDyb9FDRcTzKMCKJAowhafsTB/6p88yECPRwEydbRG9I
         g82rx3I6a585B2izwlBjFT1h9Pnm2p/hNx1FoFRXdGt503MTlCSmjL0j+mBG+W3jWm
         FNs5AMjXW9VpEYBEB4AMLx4I+N5Tuwy80dnT3nQA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Lewis Huang <Lewis.Huang@amd.com>, Aric Cyr <Aric.Cyr@amd.com>,
        Alexander Deucher <Alexander.Deucher@amd.com>,
        Harry Wentland <hwentlan@amd.com>,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 067/255] drm/amd/display: fix compilation error on allmodconfig
Date:   Tue,  1 Sep 2020 17:08:43 +0200
Message-Id: <20200901151003.942710728@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qingqing Zhuo <qingqing.zhuo@amd.com>

[ Upstream commit 8c823e4ff67c78659ab403d63d071103416f49eb ]

when compiled with allmodconfig option, there are error
messages as below:

ERROR: modpost:
"mod_color_is_table_init"
[drivers/gpu/drm/amd/amdgpu/amdgpu.ko] undefined!
ERROR: modpost:
"mod_color_get_table"
[drivers/gpu/drm/amd/amdgpu/amdgpu.ko] undefined!
ERROR: modpost:
"mod_color_set_table_init_state"
[drivers/gpu/drm/amd/amdgpu/amdgpu.ko] undefined!

To fix the issue, this commits removes
CONFIG_DRM_AMD_DC_DCN guard in color/makefile.

Signed-off-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
CC: Lewis Huang <Lewis.Huang@amd.com>
CC: Aric Cyr <Aric.Cyr@amd.com>
CC: Alexander Deucher <Alexander.Deucher@amd.com>
CC: Harry Wentland <hwentlan@amd.com>
CC: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
CC: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/modules/color/Makefile | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/modules/color/Makefile b/drivers/gpu/drm/amd/display/modules/color/Makefile
index 3ee7f27ff93b9..e66c19a840c29 100644
--- a/drivers/gpu/drm/amd/display/modules/color/Makefile
+++ b/drivers/gpu/drm/amd/display/modules/color/Makefile
@@ -23,11 +23,7 @@
 # Makefile for the color sub-module of DAL.
 #
 
-MOD_COLOR = color_gamma.o
-
-ifdef CONFIG_DRM_AMD_DC_DCN
-MOD_COLOR += color_table.o
-endif
+MOD_COLOR = color_gamma.o color_table.o
 
 AMD_DAL_MOD_COLOR = $(addprefix $(AMDDALPATH)/modules/color/,$(MOD_COLOR))
 #$(info ************  DAL COLOR MODULE MAKEFILE ************)
-- 
2.25.1



