Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAE7D4F3746
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352673AbiDELML (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:12:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348844AbiDEJsk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:48:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E2BCB7C4A;
        Tue,  5 Apr 2022 02:36:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EEE6261368;
        Tue,  5 Apr 2022 09:36:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AE61C385A3;
        Tue,  5 Apr 2022 09:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151399;
        bh=0C40SgLp/lwFglandYY9iJGkhMxzFWz9IyNwKsYpjig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yQ8+9YrmkdoKF/h4gDx7if8imBk0NBJ0ohQvvyNmSYFafrNHfwubbGzcXb6F7lHnO
         8guKz3N0b27KF09CmJxkPyW4mvqtWnr4EXWiYzqIIDX+AxU3Rh2r8hdyvNEHTdroRM
         H7R9eK0ON56PqrnLKvbWujBiLwwie1/D4VGEAOxA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhou Qingyang <zhou1615@umn.edu>,
        Lyude Paul <lyude@redhat.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 400/913] drm/nouveau/acr: Fix undefined behavior in nvkm_acr_hsfw_load_bl()
Date:   Tue,  5 Apr 2022 09:24:22 +0200
Message-Id: <20220405070351.837442012@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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

[ Upstream commit 2343bcdb4747d4f418a4daf2e898b94f86c24a59 ]

In nvkm_acr_hsfw_load_bl(), the return value of kmalloc() is directly
passed to memcpy(), which could lead to undefined behavior on failure
of kmalloc().

Fix this bug by using kmemdup() instead of kmalloc()+memcpy().

This bug was found by a static analyzer.

Builds with 'make allyesconfig' show no new warnings,
and our static analyzer no longer warns about this code.

Fixes: 22dcda45a3d1 ("drm/nouveau/acr: implement new subdev to replace "secure boot"")
Signed-off-by: Zhou Qingyang <zhou1615@umn.edu>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220124165856.57022-1-zhou1615@umn.edu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nvkm/subdev/acr/hsfw.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/acr/hsfw.c b/drivers/gpu/drm/nouveau/nvkm/subdev/acr/hsfw.c
index 667fa016496e..a6ea89a5d51a 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/acr/hsfw.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/acr/hsfw.c
@@ -142,11 +142,12 @@ nvkm_acr_hsfw_load_bl(struct nvkm_acr *acr, const char *name, int ver,
 
 	hsfw->imem_size = desc->code_size;
 	hsfw->imem_tag = desc->start_tag;
-	hsfw->imem = kmalloc(desc->code_size, GFP_KERNEL);
-	memcpy(hsfw->imem, data + desc->code_off, desc->code_size);
-
+	hsfw->imem = kmemdup(data + desc->code_off, desc->code_size, GFP_KERNEL);
 	nvkm_firmware_put(fw);
-	return 0;
+	if (!hsfw->imem)
+		return -ENOMEM;
+	else
+		return 0;
 }
 
 int
-- 
2.34.1



