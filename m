Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6656C1330F7
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 21:56:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727185AbgAGU4a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 15:56:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:51998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727176AbgAGU43 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 15:56:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB2FE2081E;
        Tue,  7 Jan 2020 20:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430589;
        bh=hysfUu4p0Fqb8tnXbESrzUN74FW2jpMqqXphEDibYMA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u/4bFLEEzw5/wbpEFbfl646XZDv5JfH48+X/AGlx/WTwug1CGCPXNG4WQw8amG+/0
         f+pktRv778lVTcGe7VO3VteU50Ik3lBPhLEbZPeqRNYdW4aK52tuqDulyVJkSdclvm
         BLCuxNcxjyv7pvm+Kl9PBkJglFnCvPXNaSUMQYvE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 005/191] drm/amdgpu: add header line for power profile on Arcturus
Date:   Tue,  7 Jan 2020 21:52:05 +0100
Message-Id: <20200107205333.294699840@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 14891c316ca7e15d81dba78f30fb630e3f9ee2c9 ]

So the output is consistent with other asics.

Reviewed-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/powerplay/arcturus_ppt.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/amd/powerplay/arcturus_ppt.c b/drivers/gpu/drm/amd/powerplay/arcturus_ppt.c
index d493a3f8c07a..b68bf8dcfa78 100644
--- a/drivers/gpu/drm/amd/powerplay/arcturus_ppt.c
+++ b/drivers/gpu/drm/amd/powerplay/arcturus_ppt.c
@@ -1388,12 +1388,17 @@ static int arcturus_get_power_profile_mode(struct smu_context *smu,
 					"VR",
 					"COMPUTE",
 					"CUSTOM"};
+	static const char *title[] = {
+			"PROFILE_INDEX(NAME)"};
 	uint32_t i, size = 0;
 	int16_t workload_type = 0;
 
 	if (!smu->pm_enabled || !buf)
 		return -EINVAL;
 
+	size += sprintf(buf + size, "%16s\n",
+			title[0]);
+
 	for (i = 0; i <= PP_SMC_POWER_PROFILE_CUSTOM; i++) {
 		/*
 		 * Conv PP_SMC_POWER_PROFILE* to WORKLOAD_PPLIB_*_BIT
-- 
2.20.1



