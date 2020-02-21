Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD2AF16751B
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:30:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387937AbgBUIXZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:23:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:35428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388476AbgBUIXZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:23:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F28C24697;
        Fri, 21 Feb 2020 08:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582273404;
        bh=H+HW9LdC+gGzgBI2knQjxdHksSbqipHsIqlIEKwTmKU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nW3vHUY849TmTd6zwWugXmE8o1ue8p0E7a+pGWPfWS27glGOZUwfL7vcB7Foo0qYd
         h+7uzhc8jN02Fk8i/ksopShSw6pnp6AO06sj5Y+qJL3XwWQVzT1kDxuhpHx6C2HF6e
         fCjy0vedCT5Tg+5lbk5bDTB3vKOol+hH5Rnjt4Q4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 157/191] drm/nouveau/mmu: fix comptag memory leak
Date:   Fri, 21 Feb 2020 08:42:10 +0100
Message-Id: <20200221072309.677035788@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072250.732482588@linuxfoundation.org>
References: <20200221072250.732482588@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Skeggs <bskeggs@redhat.com>

[ Upstream commit 35e4909b6a2b4005ced3c4238da60d926b78fdea ]

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nvkm/core/memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/core/memory.c b/drivers/gpu/drm/nouveau/nvkm/core/memory.c
index e85a08ecd9da5..4cc186262d344 100644
--- a/drivers/gpu/drm/nouveau/nvkm/core/memory.c
+++ b/drivers/gpu/drm/nouveau/nvkm/core/memory.c
@@ -91,8 +91,8 @@ nvkm_memory_tags_get(struct nvkm_memory *memory, struct nvkm_device *device,
 	}
 
 	refcount_set(&tags->refcount, 1);
+	*ptags = memory->tags = tags;
 	mutex_unlock(&fb->subdev.mutex);
-	*ptags = tags;
 	return 0;
 }
 
-- 
2.20.1



