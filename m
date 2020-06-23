Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E7202059CA
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 19:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733176AbgFWRf2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 13:35:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:60014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733171AbgFWRf2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 13:35:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC6692078C;
        Tue, 23 Jun 2020 17:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592933727;
        bh=TQJveAd4iuxp3Js2y6oHTz1x2bBFGQmlIDZnSYRqzkY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C0lI0p2XA29CQ56pN07g4a2zueNXHRH/zt2F6GxCpmELLASHHp3j1Fc/vcFk6ez9n
         zHY2fw+FyyyiIHaWxWVsSFq16h0WB7QF+u6lFiV+jOt4T0ngP8tsMDmxr+ukrMXuTp
         EdOYPfWj1PQlSdWMZUUXGUGXm2yXqbFVEL9HESAk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Denis Efremov <efremov@linux.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.7 03/28] drm/amd/display: Use kfree() to free rgb_user in calculate_user_regamma_ramp()
Date:   Tue, 23 Jun 2020 13:34:58 -0400
Message-Id: <20200623173523.1355411-3-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200623173523.1355411-1-sashal@kernel.org>
References: <20200623173523.1355411-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Denis Efremov <efremov@linux.com>

[ Upstream commit 43a562774fceba867e8eebba977d7d42f8a2eac7 ]

Use kfree() instead of kvfree() to free rgb_user in
calculate_user_regamma_ramp() because the memory is allocated with
kcalloc().

Signed-off-by: Denis Efremov <efremov@linux.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/modules/color/color_gamma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/modules/color/color_gamma.c b/drivers/gpu/drm/amd/display/modules/color/color_gamma.c
index cac09d500fda9..2c2caa7d335c8 100644
--- a/drivers/gpu/drm/amd/display/modules/color/color_gamma.c
+++ b/drivers/gpu/drm/amd/display/modules/color/color_gamma.c
@@ -1777,7 +1777,7 @@ bool calculate_user_regamma_ramp(struct dc_transfer_func *output_tf,
 
 	kfree(rgb_regamma);
 rgb_regamma_alloc_fail:
-	kvfree(rgb_user);
+	kfree(rgb_user);
 rgb_user_alloc_fail:
 	return ret;
 }
-- 
2.25.1

