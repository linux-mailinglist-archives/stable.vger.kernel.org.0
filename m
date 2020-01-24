Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D9BC147DA7
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 11:02:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388036AbgAXKCe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 05:02:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:38046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733301AbgAXKCd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 05:02:33 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8077D2075D;
        Fri, 24 Jan 2020 10:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579860153;
        bh=S9JvEKSWbFGtFy5wvMsZfUycbazL3Z6A4O1HTYQj30A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H/brlE04UK9NU85sFMDU67/6n54cNh0R09RR8AVLcOmBa6BpzmmzK4cZJlb7xGc9p
         1x3uYB6fmnKXmylwon8IOeALt2H8SkAbX4A0I7Yjd6VOjqLPrGY+htoyH82LDjy0rC
         EMfcRUKBK/T7JcimoQ+Xk05h4/0xEsLAiT5XfnZ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeffrey Hugo <jeffrey.l.hugo@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 236/343] drm/msm/mdp5: Fix mdp5_cfg_init error return
Date:   Fri, 24 Jan 2020 10:30:54 +0100
Message-Id: <20200124092951.195605312@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
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
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_cfg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_cfg.c b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_cfg.c
index 824067d2d4277..42f0ecb0cf35f 100644
--- a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_cfg.c
+++ b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_cfg.c
@@ -635,7 +635,7 @@ fail:
 	if (cfg_handler)
 		mdp5_cfg_destroy(cfg_handler);
 
-	return NULL;
+	return ERR_PTR(ret);
 }
 
 static struct mdp5_cfg_platform *mdp5_get_config(struct platform_device *dev)
-- 
2.20.1



