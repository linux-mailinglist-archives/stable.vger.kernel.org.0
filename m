Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94C5E55E15D
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243716AbiF1CVZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 22:21:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243603AbiF1CVA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 22:21:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9EF324BED;
        Mon, 27 Jun 2022 19:20:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55414B81C11;
        Tue, 28 Jun 2022 02:20:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6C61C34115;
        Tue, 28 Jun 2022 02:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656382821;
        bh=Asz9ew2hFmI18bnYpVbWeSIOuLQ9FU4MX/wfshCkR5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wm5qD/N3uSHISZ4abRUbRUHGlbp6c62EBG4ghbYADH1y0iqvooDAeYFKu/Z8xHajv
         O/ZOgu6IvwnB6w8oofFgvGBub5Zr6RPiv7OivKBznV4zq/J4jkiV6G7LvJ/X68gN2r
         qyyg1lE3bsqKR+K/IhuhYkGYqa9dT142qZwXaplHvhr3mxLjdx2RWa/G6eycCF+VKI
         OD3SSDc2tyubnptvlVVLa4Zb4XIDX9XoYpQFxJ/aqNp4Jl6kZyXactH5c0MlnGdY8v
         KmAI1V1sln3R00n6ZXBKb42phdZMC1rSbCowJ+57RxcYspLkdt8J1iEFw5CmPQL9up
         B9cKq3/Ukrs8w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>,
        Juergen Gross <jgross@suse.com>,
        Sasha Levin <sashal@kernel.org>, airlied@linux.ie,
        daniel@ffwll.ch, dri-devel@lists.freedesktop.org,
        xen-devel@lists.xenproject.org
Subject: [PATCH AUTOSEL 5.18 38/53] drm/xen: Add missing VM_DONTEXPAND flag in mmap callback
Date:   Mon, 27 Jun 2022 22:18:24 -0400
Message-Id: <20220628021839.594423-38-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628021839.594423-1-sashal@kernel.org>
References: <20220628021839.594423-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>

[ Upstream commit ca6969013d13282b42cb5edcc13db731a08e0ad8 ]

With Xen PV Display driver in use the "expected" VM_DONTEXPAND flag
is not set (neither explicitly nor implicitly), so the driver hits
the code path in drm_gem_mmap_obj() which triggers the WARNING.

Signed-off-by: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Reviewed-by: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
Link: https://lore.kernel.org/r/1652104303-5098-1-git-send-email-olekstysh@gmail.com
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xen/xen_drm_front_gem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xen/xen_drm_front_gem.c b/drivers/gpu/drm/xen/xen_drm_front_gem.c
index 5a5bf4e5b717..e31554d7139f 100644
--- a/drivers/gpu/drm/xen/xen_drm_front_gem.c
+++ b/drivers/gpu/drm/xen/xen_drm_front_gem.c
@@ -71,7 +71,7 @@ static int xen_drm_front_gem_object_mmap(struct drm_gem_object *gem_obj,
 	 * the whole buffer.
 	 */
 	vma->vm_flags &= ~VM_PFNMAP;
-	vma->vm_flags |= VM_MIXEDMAP;
+	vma->vm_flags |= VM_MIXEDMAP | VM_DONTEXPAND;
 	vma->vm_pgoff = 0;
 
 	/*
-- 
2.35.1

