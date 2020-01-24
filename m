Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56F1F148206
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:24:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403787AbgAXLYk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:24:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:38254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391085AbgAXLYj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:24:39 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2EFA20838;
        Fri, 24 Jan 2020 11:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865079;
        bh=/uFn5WmS2Rcrpg5Cad3o1dLefQ/cMWBBikWfx9CbPds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VD4zrijSxMXn8jPgV3tn3rkeEmK2sTo/KiAIT8mEACOwKsZzk8y5fW2IMU2/ZTSUt
         2knpt7LC7kxX69LAeJ0fwmboObInEz+BFh+0YX9XhK+sz3v77iArTtFovfk5sLzXpF
         WG11gy5A38gULYeIROR7i9pvonkBrDwFkaV5W0WE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeffrey Hugo <jeffrey.l.hugo@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 434/639] drm/msm/mdp5: Fix mdp5_cfg_init error return
Date:   Fri, 24 Jan 2020 10:30:04 +0100
Message-Id: <20200124093141.386075416@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
 drivers/gpu/drm/msm/disp/mdp5/mdp5_cfg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/disp/mdp5/mdp5_cfg.c b/drivers/gpu/drm/msm/disp/mdp5/mdp5_cfg.c
index 824067d2d4277..42f0ecb0cf35f 100644
--- a/drivers/gpu/drm/msm/disp/mdp5/mdp5_cfg.c
+++ b/drivers/gpu/drm/msm/disp/mdp5/mdp5_cfg.c
@@ -635,7 +635,7 @@ fail:
 	if (cfg_handler)
 		mdp5_cfg_destroy(cfg_handler);
 
-	return NULL;
+	return ERR_PTR(ret);
 }
 
 static struct mdp5_cfg_platform *mdp5_get_config(struct platform_device *dev)
-- 
2.20.1



