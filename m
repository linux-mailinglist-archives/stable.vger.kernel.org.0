Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28E5A1676C3
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:38:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731373AbgBUIDf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:03:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:36366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731477AbgBUIDe (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:03:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA2502073A;
        Fri, 21 Feb 2020 08:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272214;
        bh=dfBe6pGOa3MtzNF/br7Jv7bQkVvBqp+VpqCIZVOiRto=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bfq4QM5CeGLSHShqvlrlCBegAPG9legWcFThCIP5wtm2V3LK5aF06wK1Ayet5FCoX
         afQwCH4kpqfDENP+YrpsGKWvXGM0UphXxnb8I0m8VFyHNuFVYyFhfLkiW900hPvBZD
         JVqHSljBJPgoK8dx4CZqX4pbvK8kb9wT3Hj63oLI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 058/344] drm/nouveau/nouveau: fix incorrect sizeof on args.src an args.dst
Date:   Fri, 21 Feb 2020 08:37:37 +0100
Message-Id: <20200221072354.310599788@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



