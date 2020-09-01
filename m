Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82D1B259281
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728331AbgIAPNG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:13:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:55872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728851AbgIAPNF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:13:05 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 583A1206FA;
        Tue,  1 Sep 2020 15:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598973184;
        bh=zby1bdyNKvlbw/2B9KxrATkPOOQOOknxZ7Nnr25BQoc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vWDvmPMwi+Pkp5ijDWb9VxsWAlffsgh2I4UVvcZnmteq/uhwiNqHNaaULE/roIlpJ
         QsIKl1kd1vXGfPHKTXwiR8WKSVA8ukpvvIg0RmO4iQ1XaLuMnnWsB1ehg8Fz0AT5nQ
         f0bdlfhHoDqNxoaz1EHw+ntZ5O2I9VS23DD1bQk8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aditya Pakki <pakki001@umn.edu>,
        Ben Skeggs <bskeggs@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 23/62] drm/nouveau: Fix reference count leak in nouveau_connector_detect
Date:   Tue,  1 Sep 2020 17:10:06 +0200
Message-Id: <20200901150921.904221454@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150920.697676718@linuxfoundation.org>
References: <20200901150920.697676718@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aditya Pakki <pakki001@umn.edu>

[ Upstream commit 990a1162986e8eff7ca18cc5a0e03b4304392ae2 ]

nouveau_connector_detect() calls pm_runtime_get_sync and in turn
increments the reference count. In case of failure, decrement the
ref count before returning the error.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nouveau_connector.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_connector.c b/drivers/gpu/drm/nouveau/nouveau_connector.c
index 1855b475cc0b2..42be04813b682 100644
--- a/drivers/gpu/drm/nouveau/nouveau_connector.c
+++ b/drivers/gpu/drm/nouveau/nouveau_connector.c
@@ -263,8 +263,10 @@ nouveau_connector_detect(struct drm_connector *connector, bool force)
 		pm_runtime_get_noresume(dev->dev);
 	} else {
 		ret = pm_runtime_get_sync(dev->dev);
-		if (ret < 0 && ret != -EACCES)
+		if (ret < 0 && ret != -EACCES) {
+			pm_runtime_put_autosuspend(dev->dev);
 			return conn_status;
+		}
 	}
 
 	nv_encoder = nouveau_connector_ddc_detect(connector);
-- 
2.25.1



