Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 424B24F3180
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238669AbiDEJd6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:33:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245194AbiDEIyN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:54:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6256DD9F;
        Tue,  5 Apr 2022 01:51:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 10ED86117A;
        Tue,  5 Apr 2022 08:51:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22E5FC385A3;
        Tue,  5 Apr 2022 08:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148717;
        bh=Wps1JC5B9YkugJ8jm4NkjIUH9/IHZqEekVA56y5eWzY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z3EbqTdGDKNNEMIqUWPcNWuAcshyecqeQsrtq7GPYbGLx5j4PqGkYNO/qAGwq21+w
         zF0mDM0aAr+zFcP4sr0sTE73RBAdl6uvKib51YC/eZRVNS82zIyPEtk9pBJKttG8kd
         2s34bWKvL+DjW02ktJuPyYWhfm5dA9pgOJ9WhB04=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhou Qingyang <zhou1615@umn.edu>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0429/1017] drm/amd/display: Fix a NULL pointer dereference in amdgpu_dm_connector_add_common_modes()
Date:   Tue,  5 Apr 2022 09:22:22 +0200
Message-Id: <20220405070407.028698284@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Zhou Qingyang <zhou1615@umn.edu>

[ Upstream commit 588a70177df3b1777484267584ef38ab2ca899a2 ]

In amdgpu_dm_connector_add_common_modes(), amdgpu_dm_create_common_mode()
is assigned to mode and is passed to drm_mode_probed_add() directly after
that. drm_mode_probed_add() passes &mode->head to list_add_tail(), and
there is a dereference of it in list_add_tail() without recoveries, which
could lead to NULL pointer dereference on failure of
amdgpu_dm_create_common_mode().

Fix this by adding a NULL check of mode.

This bug was found by a static analyzer.

Builds with 'make allyesconfig' show no new warnings,
and our static analyzer no longer warns about this code.

Fixes: e7b07ceef2a6 ("drm/amd/display: Merge amdgpu_dm_types and amdgpu_dm")
Signed-off-by: Zhou Qingyang <zhou1615@umn.edu>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 7a5bb5a3456a..0ec8051cdfb4 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -8030,6 +8030,9 @@ static void amdgpu_dm_connector_add_common_modes(struct drm_encoder *encoder,
 		mode = amdgpu_dm_create_common_mode(encoder,
 				common_modes[i].name, common_modes[i].w,
 				common_modes[i].h);
+		if (!mode)
+			continue;
+
 		drm_mode_probed_add(connector, mode);
 		amdgpu_dm_connector->num_modes++;
 	}
-- 
2.34.1



