Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDB2F24FAC4
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726502AbgHXJ7m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 05:59:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:40756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726986AbgHXIdR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:33:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BE70207D3;
        Mon, 24 Aug 2020 08:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598257996;
        bh=kCkV9GnogaTy4jEU/uZ8pRQps80RvBYxzFXGpYVLYd4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LCd+UiMDo5qgyrjOv0Nps/+Zd8u/Y6fPM73ddyUIy3KGzQkNEDaLGOy8aKcIvama8
         31Pe/ISi+bffjUx9zRg7wXX1QyDqEYEahMMZEAXTy5aEx2JDKDjK0J6BJz+F72gyuB
         7TjVutS9SWPFNqiZdeoag33GucjzLMhP/RwIaDXA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.8 036/148] drm: amdgpu: Use the correct size when allocating memory
Date:   Mon, 24 Aug 2020 10:28:54 +0200
Message-Id: <20200824082415.777369848@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082413.900489417@linuxfoundation.org>
References: <20200824082413.900489417@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit 78484d7c747e30468b35bd5f19edf602f50162a7 upstream.

When '*sgt' is allocated, we must allocated 'sizeof(**sgt)' bytes instead
of 'sizeof(*sg)'.

The sizeof(*sg) is bigger than sizeof(**sgt) so this wastes memory but
it won't lead to corruption.

Fixes: f44ffd677fb3 ("drm/amdgpu: add support for exporting VRAM using DMA-buf v3")
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
@@ -465,7 +465,7 @@ int amdgpu_vram_mgr_alloc_sgt(struct amd
 	unsigned int pages;
 	int i, r;
 
-	*sgt = kmalloc(sizeof(*sg), GFP_KERNEL);
+	*sgt = kmalloc(sizeof(**sgt), GFP_KERNEL);
 	if (!*sgt)
 		return -ENOMEM;
 


