Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19F4933BA5F
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235504AbhCOOJB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:09:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:49734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234471AbhCOODY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:03:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4406564E83;
        Mon, 15 Mar 2021 14:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615817004;
        bh=65FGN8tFjwc5m23owKilo2IaNt4swdnOZ2xh3T4ygqo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uxasuCUQ/ndmpM95igljsMRP3LY1snhXNkKh0se/D+FJgnBqaeFIvmFF3M2MvIVcf
         3E7M0EQyvG6FBf05AJHE3ko7BhrEUHICMIgImrldpxYSlTVYA+zFKv6yWzNg6bgJLg
         souTohcVgnvgO7lNbyL8LqX/3GBfi9kQqtcgHya4=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Airlie <airlied@redhat.com>,
        "Michael J. Ruhl" <michael.j.ruhl@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 255/306] drm/nouveau: fix dma syncing for loops (v2)
Date:   Mon, 15 Mar 2021 14:55:18 +0100
Message-Id: <20210315135516.263822597@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Dave Airlie <airlied@redhat.com>

[ Upstream commit 4042160c2e5433e0759782c402292a90b5bf458d ]

The index variable should only be increased in one place.

Noticed this while trying to track down another oops.

v2: use while loop.

Fixes: f295c8cfec83 ("drm/nouveau: fix dma syncing warning with debugging on.")
Signed-off-by: Dave Airlie <airlied@redhat.com>
Reviewed-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210311043527.5376-1-airlied@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nouveau_bo.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.c b/drivers/gpu/drm/nouveau/nouveau_bo.c
index 7ea367a5444d..f1c9a22083be 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bo.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
@@ -556,7 +556,8 @@ nouveau_bo_sync_for_device(struct nouveau_bo *nvbo)
 	if (nvbo->force_coherent)
 		return;
 
-	for (i = 0; i < ttm_dma->num_pages; ++i) {
+	i = 0;
+	while (i < ttm_dma->num_pages) {
 		struct page *p = ttm_dma->pages[i];
 		size_t num_pages = 1;
 
@@ -587,7 +588,8 @@ nouveau_bo_sync_for_cpu(struct nouveau_bo *nvbo)
 	if (nvbo->force_coherent)
 		return;
 
-	for (i = 0; i < ttm_dma->num_pages; ++i) {
+	i = 0;
+	while (i < ttm_dma->num_pages) {
 		struct page *p = ttm_dma->pages[i];
 		size_t num_pages = 1;
 
-- 
2.30.1



