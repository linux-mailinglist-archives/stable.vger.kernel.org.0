Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBDC7428F6E
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 15:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235476AbhJKN6y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 09:58:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:40706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237871AbhJKN4n (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 09:56:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E0F06113E;
        Mon, 11 Oct 2021 13:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960425;
        bh=/0tBGpF2fMEpWCmF9dekE4Dd8i04Y0hi+ckxHaw3qD0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cB9NLwVFu788WJD8iSxRhqhmgWUJPlOk2JsgpG/khFiEMsnHdKSYNPQ72aRd4ugUV
         dTMG25UB5m0KpVszbdYsDyl693EDIMLLiTPlmoY7+rz2RvTtWMfBms/sP4SsGo8aB0
         p8IDJsanqiOKSThrH75yNpXFEhNWjwTAaRemGsIk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thierry Reding <treding@nvidia.com>,
        Jeremy Cline <jcline@redhat.com>,
        Lyude Paul <lyude@redhat.com>,
        Karol Herbst <kherbst@redhat.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 56/83] drm/nouveau: avoid a use-after-free when BO init fails
Date:   Mon, 11 Oct 2021 15:46:16 +0200
Message-Id: <20211011134510.328120161@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134508.362906295@linuxfoundation.org>
References: <20211011134508.362906295@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeremy Cline <jcline@redhat.com>

[ Upstream commit bcf34aa5082ee2343574bc3f4d1c126030913e54 ]

nouveau_bo_init() is backed by ttm_bo_init() and ferries its return code
back to the caller. On failures, ttm_bo_init() invokes the provided
destructor which should de-initialize and free the memory.

Thus, when nouveau_bo_init() returns an error the gem object has already
been released and the memory freed by nouveau_bo_del_ttm().

Fixes: 019cbd4a4feb ("drm/nouveau: Initialize GEM object before TTM object")
Cc: Thierry Reding <treding@nvidia.com>
Signed-off-by: Jeremy Cline <jcline@redhat.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Reviewed-by: Karol Herbst <kherbst@redhat.com>
Signed-off-by: Karol Herbst <kherbst@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20201203000220.18238-1-jcline@redhat.com
Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nouveau_gem.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_gem.c b/drivers/gpu/drm/nouveau/nouveau_gem.c
index c2051380d18c..6504ebec1190 100644
--- a/drivers/gpu/drm/nouveau/nouveau_gem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_gem.c
@@ -196,10 +196,8 @@ nouveau_gem_new(struct nouveau_cli *cli, u64 size, int align, uint32_t domain,
 	}
 
 	ret = nouveau_bo_init(nvbo, size, align, domain, NULL, NULL);
-	if (ret) {
-		nouveau_bo_ref(NULL, &nvbo);
+	if (ret)
 		return ret;
-	}
 
 	/* we restrict allowed domains on nv50+ to only the types
 	 * that were requested at creation time.  not possibly on
-- 
2.33.0



