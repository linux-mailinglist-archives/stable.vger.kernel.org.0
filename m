Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3B813E7C8
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:28:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392287AbgAPR14 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:27:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:38266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392110AbgAPR1z (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:27:55 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C578246EB;
        Thu, 16 Jan 2020 17:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195674;
        bh=oZRjKA7GGnkS5D3Z+OySvQJHR7OF8LYaprgmuTMpSj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=st0XS/CsQB3YY4tUoFRsxc0l5o31qvG6+abTFCqybodyOiaMb06D9J642JYzlKJCq
         KJBgjnQBIE/thyBEvAYScVfgNdH+iyUbiWltfEKx6jljKQqLwZeOvl1yswwgSDj50x
         EEmzTIES5JykYg68UrolHQEUW66dv/CmPHleSJRc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeffrey Hugo <jeffrey.l.hugo@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.14 230/371] drm/msm/mdp5: Fix mdp5_cfg_init error return
Date:   Thu, 16 Jan 2020 12:21:42 -0500
Message-Id: <20200116172403.18149-173-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116172403.18149-1-sashal@kernel.org>
References: <20200116172403.18149-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeffrey Hugo <jeffrey.l.hugo@gmail.com>

[ Upstream commit fc19cbb785d7bbd1a1af26229b5240a3ab332744 ]

If mdp5_cfg_init fails because of an unknown major version, a null pointer
dereference occurs.  This is because the caller of init expects error
pointers, but init returns NULL on error.  Fix this by returning the
expected values on error.

Fixes: 2e362e1772b8 (drm/msm/mdp5: introduce mdp5_cfg module)
Signed-off-by: Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_cfg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_cfg.c b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_cfg.c
index 824067d2d427..42f0ecb0cf35 100644
--- a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_cfg.c
+++ b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_cfg.c
@@ -635,7 +635,7 @@ struct mdp5_cfg_handler *mdp5_cfg_init(struct mdp5_kms *mdp5_kms,
 	if (cfg_handler)
 		mdp5_cfg_destroy(cfg_handler);
 
-	return NULL;
+	return ERR_PTR(ret);
 }
 
 static struct mdp5_cfg_platform *mdp5_get_config(struct platform_device *dev)
-- 
2.20.1

