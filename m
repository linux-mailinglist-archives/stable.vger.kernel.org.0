Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A0EF5F94CF
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 02:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbiJJAMx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 20:12:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230355AbiJJAMh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 20:12:37 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64164F1C;
        Sun,  9 Oct 2022 16:49:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2FED6CE0E90;
        Sun,  9 Oct 2022 23:49:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37FD0C433D6;
        Sun,  9 Oct 2022 23:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665359375;
        bh=Pn90kuPbeK/qdV/mITnz331Ur07Ew6mzmpWUpHOoTiM=;
        h=From:To:Cc:Subject:Date:From;
        b=iqbkVpUBW4ChtfrNACIjriJwpHTJBgxN6AhpWbmKJLK6L822/hsQdSJCyVpsI51nv
         d5GtXsFmd4wdTi6C4uvU795+BryM6UaGpImvxt1yYLF5vYHApjFPb71sX6MaMytzKg
         jd7kGzjMj+ud7biKwf7MzC9j/nVRWaZObqZzL8m/JRAWSGgjIqERYjxTHfEf/7q9Kx
         E4+YFm7mfacryG7EzRT4+bGe63JfCk+ebj4os53KBnvSQDXu+efDIH9/i8+6XUOSiD
         BogCyQMHj3slQVdtQb5CoioNFYIKciqTIDVAOnAikDLIpXZ9yW3s73OianGvuiaA7R
         RYPE37i32rMog==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jianglei Nie <niejianglei2021@163.com>,
        Lyude Paul <lyude@redhat.com>, Sasha Levin <sashal@kernel.org>,
        bskeggs@redhat.com, kherbst@redhat.com, airlied@gmail.com,
        daniel@ffwll.ch, dri-devel@lists.freedesktop.org,
        nouveau@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.0 01/44] drm/nouveau/nouveau_bo: fix potential memory leak in nouveau_bo_alloc()
Date:   Sun,  9 Oct 2022 19:48:49 -0400
Message-Id: <20221009234932.1230196-1-sashal@kernel.org>
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
index e29175e4b44c..07a327ad5e2a 100644
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

