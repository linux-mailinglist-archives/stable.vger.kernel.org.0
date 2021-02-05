Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05B6931148F
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 23:14:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231283AbhBEWH6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 17:07:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:44680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232847AbhBEOwM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 09:52:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 317D46506C;
        Fri,  5 Feb 2021 14:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534374;
        bh=uwFvfc6L4wpnKmbVy14n1pGZETZp9bDsqif3aF84e58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b977jaWgUz0ek9I20QieC5A0NmM7dJEo+HtCez2Y3v5iysueVRTupKrd2ltKQSsBq
         JoRlDoT3It4E41t+Y+Jh4JhZno6hn5hOnunU6n/dUWyl/XAvTuy8vQuqLTAnVOfd1V
         yYaLN7PAc6GTd7FQqEfk4sHg1FtZyhgqtH1DWOyo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Wheeler <daniel.wheeler@amd.com>,
        Bing Guo <bing.guo@amd.com>, Jun Lei <Jun.Lei@amd.com>,
        Anson Jacob <anson.jacob@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 29/32] drm/amd/display: Change function decide_dp_link_settings to avoid infinite looping
Date:   Fri,  5 Feb 2021 15:07:44 +0100
Message-Id: <20210205140653.578210069@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140652.348864025@linuxfoundation.org>
References: <20210205140652.348864025@linuxfoundation.org>
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
index 959eb075d11ed..c18f39271b034 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
@@ -1914,6 +1914,9 @@ static bool decide_dp_link_settings(struct dc_link *link, struct dc_link_setting
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



