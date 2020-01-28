Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7D4814B856
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:24:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731617AbgA1OWe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:22:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:48404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727549AbgA1OWd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:22:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4BA524686;
        Tue, 28 Jan 2020 14:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221353;
        bh=OEcU7b+/F7+cumlbFBaYVrG3ZfIqMFdLfhcW1NhHUTA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b9YPw17E7xuJj+8c2vSFZQEq6sd0YWeV+htH+2KobSbwQc+bcSFkXuTKb2mdbyMoW
         kkl2Rau5D6j7jjZFACR0f3dlwXgoRLYnB3nmDYqyL68B67Om6/IMBfDtRc2nVFXkIr
         0ryd50p1FooWkjxwNd3VjLjGZT9LzArRyXc6X9QU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeffrey Hugo <jeffrey.l.hugo@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 154/271] drm/msm/mdp5: Fix mdp5_cfg_init error return
Date:   Tue, 28 Jan 2020 15:05:03 +0100
Message-Id: <20200128135904.029585964@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
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
index 8b4e3004f4518..86b0448d2ce58 100644
--- a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_cfg.c
+++ b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_cfg.c
@@ -542,7 +542,7 @@ fail:
 	if (cfg_handler)
 		mdp5_cfg_destroy(cfg_handler);
 
-	return NULL;
+	return ERR_PTR(ret);
 }
 
 static struct mdp5_cfg_platform *mdp5_get_config(struct platform_device *dev)
-- 
2.20.1



