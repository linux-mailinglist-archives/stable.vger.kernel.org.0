Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6C9A5F958D
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 02:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbiJJAVO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 20:21:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232417AbiJJAT7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 20:19:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E16C211157;
        Sun,  9 Oct 2022 16:54:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7014260D17;
        Sun,  9 Oct 2022 23:54:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0723C43470;
        Sun,  9 Oct 2022 23:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665359668;
        bh=c0nZxzjfGYuNMGZcJm+WxdQoa6sRFvDG8OlRqmeQcp8=;
        h=From:To:Cc:Subject:Date:From;
        b=bpKXRlEwu+80tbfJY86Xl/6YL4vIdrXNn6ZzLa9rbD5jlY11kzW47u0GG64BhHE0y
         4LJ18VxGoJdX56p9v/k/H0V6XzI6sorb4MlUBBUFRne4hPqHZ34R71ZSe+yA/TKvS+
         EYkTr+QKcjhtVOtfcOWxD1PIfVckVPhMItCO4fc03JZxxEw/yct3Ddq1S/BTAW3fHy
         WW2InOMvXmeU4ZYXfGEb2WRc2kbJ/f1aIaecH3i1Tzd16XZ6NmpLj9Lq2GH4VoGnmM
         JiQvUFOdz+CIrFV3F8y323TTGj5B0GlCUmmCe3Sv3Q2ivAnOlreMXP8Icz6/1lXFgx
         Yq9KncqbgZCpA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jianglei Nie <niejianglei2021@163.com>,
        Lyude Paul <lyude@redhat.com>, Sasha Levin <sashal@kernel.org>,
        bskeggs@redhat.com, kherbst@redhat.com, airlied@gmail.com,
        daniel@ffwll.ch, dri-devel@lists.freedesktop.org,
        nouveau@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 01/25] drm/nouveau/nouveau_bo: fix potential memory leak in nouveau_bo_alloc()
Date:   Sun,  9 Oct 2022 19:54:01 -0400
Message-Id: <20221009235426.1231313-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jianglei Nie <niejianglei2021@163.com>

[ Upstream commit 6dc548745d5b5102e3c53dc5097296ac270b6c69 ]

nouveau_bo_alloc() allocates a memory chunk for "nvbo" with kzalloc().
When some error occurs, "nvbo" should be released. But when
WARN_ON(pi < 0)) equals true, the function return ERR_PTR without
releasing the "nvbo", which will lead to a memory leak.

We should release the "nvbo" with kfree() if WARN_ON(pi < 0)) equals true.

Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220705094306.2244103-1-niejianglei2021@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nouveau_bo.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.c b/drivers/gpu/drm/nouveau/nouveau_bo.c
index 511fb8dfb4c4..da58230bcb1f 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bo.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
@@ -281,8 +281,10 @@ nouveau_bo_alloc(struct nouveau_cli *cli, u64 *size, int *align, u32 domain,
 			break;
 	}
 
-	if (WARN_ON(pi < 0))
+	if (WARN_ON(pi < 0)) {
+		kfree(nvbo);
 		return ERR_PTR(-EINVAL);
+	}
 
 	/* Disable compression if suitable settings couldn't be found. */
 	if (nvbo->comp && !vmm->page[pi].comp) {
-- 
2.35.1

