Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50F454AFA86
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 19:38:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236030AbiBISiK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 13:38:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239886AbiBISiA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 13:38:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D86BDC03E942;
        Wed,  9 Feb 2022 10:37:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A58D61C44;
        Wed,  9 Feb 2022 18:37:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6249FC340E7;
        Wed,  9 Feb 2022 18:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644431858;
        bh=/olF6Us9lbxAbXC7th3DTXiim40Q8iwY7LdThfGvC7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FrH1Toqxll0sofbbbjgNZUUSZNGt8sgjRscydLAG6ExRH2GmkdKAfj42JEcZibtnk
         meikSg1QeY6NybF70LPT8Gju3NvB1eC8Tzi3qe7jes9c8qoLF4bpzUKvKFaZCcClQZ
         U+rOPjRGRpP2H8+d86w2z5OpLIlH7gKvYA86UORd7Q9Bjk6KDP7QIKzJx61x1ciz1p
         DqFJxdjtgac2rzr1RQEbE7J1XXmtvZGAwZDf/ef4zmZTWd0g8wp/DsTBpHp3mKrcGw
         k3x9D8eU0r6J6Dlc7gEBVnYkXA+5WrjPqZjfo8Le6B4iQlnXHQQRqR4Ow4kANSwT2G
         vusStTaqABMOQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, Xinhui.Pan@amd.com,
        airlied@linux.ie, daniel@ffwll.ch, nirmoy.das@amd.com,
        Oak.Zeng@amd.com, kevin1.wang@amd.com, tzimmermann@suse.de,
        Philip.Yang@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.16 38/42] drm/amdgpu: fix logic inversion in check
Date:   Wed,  9 Feb 2022 13:33:10 -0500
Message-Id: <20220209183335.46545-38-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220209183335.46545-1-sashal@kernel.org>
References: <20220209183335.46545-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian König <christian.koenig@amd.com>

[ Upstream commit e8ae38720e1a685fd98cfa5ae118c9d07b45ca79 ]

We probably never trigger this, but the logic inside the check is
inverted.

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
index c875f1cdd2af7..ffc3ce0004e99 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -1913,7 +1913,7 @@ int amdgpu_copy_buffer(struct amdgpu_ring *ring, uint64_t src_offset,
 	unsigned i;
 	int r;
 
-	if (direct_submit && !ring->sched.ready) {
+	if (!direct_submit && !ring->sched.ready) {
 		DRM_ERROR("Trying to move memory with ring turned off.\n");
 		return -EINVAL;
 	}
-- 
2.34.1

