Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD80311457
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 23:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbhBEWEW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 17:04:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:44990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232860AbhBEOyy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 09:54:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 489AE6501D;
        Fri,  5 Feb 2021 14:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534268;
        bh=QHgxueEDRYVRGiS1NoUc2gkhOgR2nFDtfZVzB9GvPbU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E4Vmt+EBvjthrA2ivS+L1NQbYu4me2H09DsmRUVdT6whZeK8YZ6Iux5tvpNi1RfUu
         Keg1GEh4Q4rC5gM2F6fS1gtfA/KgOcOZE89zRJ2FHH6/T1uZFjlPrcJfIvtkF5SxG3
         hkEhXShLnRrQSqiHSd+r5Sy6xu7gAEk0kf9QWDLw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Wheeler <daniel.wheeler@amd.com>,
        Bing Guo <bing.guo@amd.com>, Jun Lei <Jun.Lei@amd.com>,
        Anson Jacob <anson.jacob@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 48/57] drm/amd/display: Change function decide_dp_link_settings to avoid infinite looping
Date:   Fri,  5 Feb 2021 15:07:14 +0100
Message-Id: <20210205140658.036521911@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140655.982616732@linuxfoundation.org>
References: <20210205140655.982616732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bing Guo <bing.guo@amd.com>

[ Upstream commit 4716a7c50c5c66d6ddc42401e1e0ba13b492e105 ]

Why:
Function decide_dp_link_settings() loops infinitely when required bandwidth
can't be supported.

How:
Check the required bandwidth against verified_link_cap before trying to
find a link setting for it.

Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Bing Guo <bing.guo@amd.com>
Reviewed-by: Jun Lei <Jun.Lei@amd.com>
Acked-by: Anson Jacob <anson.jacob@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
index 98464886341f6..004e2b32e02fa 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
@@ -2375,6 +2375,9 @@ static bool decide_dp_link_settings(struct dc_link *link, struct dc_link_setting
 			initial_link_setting;
 	uint32_t link_bw;
 
+	if (req_bw > dc_link_bandwidth_kbps(link, &link->verified_link_cap))
+		return false;
+
 	/* search for the minimum link setting that:
 	 * 1. is supported according to the link training result
 	 * 2. could support the b/w requested by the timing
-- 
2.27.0



