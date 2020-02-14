Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D07E15F2B7
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730461AbgBNPuc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:50:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:54718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729525AbgBNPub (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:50:31 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C0F924680;
        Fri, 14 Feb 2020 15:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695431;
        bh=dfBe6pGOa3MtzNF/br7Jv7bQkVvBqp+VpqCIZVOiRto=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uyV8WIm5YhkVyznJXE8okHh1walOKvIdRXRx3C7xcUCciBMzy5kIht/f1HnjSFX37
         gKJzy6t2cgaZ9VU3BsITxg9lggOMejt3+LFZpfddStJ9WxDqoSv2xe0lx+9tNnEQsY
         /hKfSAu5rJo7ybk62AJiBctUtt8yosdSjzKmZJ8I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.5 074/542] drm/nouveau/nouveau: fix incorrect sizeof on args.src an args.dst
Date:   Fri, 14 Feb 2020 10:41:06 -0500
Message-Id: <20200214154854.6746-74-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit f42e4b337b327b1336c978c4b5174990a25f68a0 ]

The sizeof is currently on args.src and args.dst and should be on
*args.src and *args.dst. Fortunately these sizes just so happen
to be the same size so it worked, however, this should be fixed
and it also cleans up static analysis warnings

Addresses-Coverity: ("sizeof not portable")
Fixes: f268307ec7c7 ("nouveau: simplify nouveau_dmem_migrate_vma")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nouveau_dmem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_dmem.c b/drivers/gpu/drm/nouveau/nouveau_dmem.c
index fa14399415965..0ad5d87b5a8e5 100644
--- a/drivers/gpu/drm/nouveau/nouveau_dmem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_dmem.c
@@ -635,10 +635,10 @@ nouveau_dmem_migrate_vma(struct nouveau_drm *drm,
 	unsigned long c, i;
 	int ret = -ENOMEM;
 
-	args.src = kcalloc(max, sizeof(args.src), GFP_KERNEL);
+	args.src = kcalloc(max, sizeof(*args.src), GFP_KERNEL);
 	if (!args.src)
 		goto out;
-	args.dst = kcalloc(max, sizeof(args.dst), GFP_KERNEL);
+	args.dst = kcalloc(max, sizeof(*args.dst), GFP_KERNEL);
 	if (!args.dst)
 		goto out_free_src;
 
-- 
2.20.1

