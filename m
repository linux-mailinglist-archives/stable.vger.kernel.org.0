Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 954FD3CA8D2
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241693AbhGOTDN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:03:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:38862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243237AbhGOTBq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:01:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9855E613E7;
        Thu, 15 Jul 2021 18:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375511;
        bh=dQZVRB0s0ZaI5JuJSNJrI0CmVThru6IXPILSsXFNzc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KAAuZ2PTwUGOcR+k40SaXXFMYsqWUye0VL/RE6BdfO4krHVawkH3yRIpsCt8uz/cz
         J4KgV0d8ahJ7jDMAxBirKo8bA9kAc1h4/vTmWILF5n/8JRhYAWSB/2FUoBxM96RDAt
         BUNsxxUybaUYs4YTalvKiRziP+zj504WoeplSadE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aric Cyr <aric.cyr@amd.com>,
        Krunoslav Kovac <Krunoslav.Kovac@amd.com>,
        Stylon Wang <stylon.wang@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 075/242] drm/amd/display: Fix crash during MPO + ODM combine mode recalculation
Date:   Thu, 15 Jul 2021 20:37:17 +0200
Message-Id: <20210715182606.116649811@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aric Cyr <aric.cyr@amd.com>

[ Upstream commit 665f28507a2a3d8d72ed9afa9a2b9b17fd43add1 ]

[Why]
When calculating recout width for an MPO plane on a mode that's using
ODM combine, driver can calculate a negative value, resulting in a
crash.

[How]
For negative widths, use zero such that validation will prune the
configuration correctly and disallow MPO.

Signed-off-by: Aric Cyr <aric.cyr@amd.com>
Reviewed-by: Krunoslav Kovac <Krunoslav.Kovac@amd.com>
Acked-by: Stylon Wang <stylon.wang@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
index 325e0d656d6a..749189eb20ba 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -733,6 +733,11 @@ static void calculate_recout(struct pipe_ctx *pipe_ctx)
 			if (split_idx == split_count) {
 				/* rightmost pipe is the remainder recout */
 				data->recout.width -= data->h_active * split_count - data->recout.x;
+
+				/* ODM combine cases with MPO we can get negative widths */
+				if (data->recout.width < 0)
+					data->recout.width = 0;
+
 				data->recout.x = 0;
 			} else
 				data->recout.width = data->h_active - data->recout.x;
-- 
2.30.2



