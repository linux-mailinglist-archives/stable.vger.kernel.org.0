Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B06B5F960D
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 02:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232795AbiJJA0g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 20:26:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233011AbiJJAYD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 20:24:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14FF56260;
        Sun,  9 Oct 2022 16:58:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A525260D3D;
        Sun,  9 Oct 2022 23:58:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2C6FC433C1;
        Sun,  9 Oct 2022 23:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665359911;
        bh=dkDStA/N5coBfdpr+Nbz6hKHmobdpXDdiQ3lUfUMJpY=;
        h=From:To:Cc:Subject:Date:From;
        b=RbPKkINe4M09wMT3/4LedDo4Vd6YH9v13Zo2DtEcY/Bmok1rpcjaVj+U8KV29Dl2A
         7OBe7udlf0hSgBS+eH7zsknzKR7KrQ1dPsyu3fiYXuSX1oQ25HqYt8v54040ljuuUN
         ew5yAVUDkJ/j70c8xqEHpmH/DCxOXU1vpdxfGoY5QEkyCvl07qvbcPCo0rLiyF5iii
         0Z/2rjg3zwx44H2bAadRy5xdh4np3DK00UGBxcJZ4pNxvA9ynsrHHq4d7g7XZ7bvOT
         TPGy0CgKHkOy3h9WE7OofPSgGxU+LfdoAwm0p15j4siCbJ8j2YO6eD3ZzGwEKhFInu
         XgKt+lB69zSPw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Javier Martinez Canillas <javierm@redhat.com>,
        Peter Robinson <pbrobinson@gmail.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Sasha Levin <sashal@kernel.org>,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        airlied@gmail.com, daniel@ffwll.ch, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.14 1/6] drm: Use size_t type for len variable in drm_copy_field()
Date:   Sun,  9 Oct 2022 19:58:03 -0400
Message-Id: <20221009235808.1232269-1-sashal@kernel.org>
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

From: Javier Martinez Canillas <javierm@redhat.com>

[ Upstream commit 94dc3471d1b2b58b3728558d0e3f264e9ce6ff59 ]

The strlen() function returns a size_t which is an unsigned int on 32-bit
arches and an unsigned long on 64-bit arches. But in the drm_copy_field()
function, the strlen() return value is assigned to an 'int len' variable.

Later, the len variable is passed as copy_from_user() third argument that
is an unsigned long parameter as well.

In theory, this can lead to an integer overflow via type conversion. Since
the assignment happens to a signed int lvalue instead of a size_t lvalue.

In practice though, that's unlikely since the values copied are set by DRM
drivers and not controlled by userspace. But using a size_t for len is the
correct thing to do anyways.

Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Tested-by: Peter Robinson <pbrobinson@gmail.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20220705100215.572498-2-javierm@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_ioctl.c b/drivers/gpu/drm/drm_ioctl.c
index ce26e8fea9c2..335fad8b209a 100644
--- a/drivers/gpu/drm/drm_ioctl.c
+++ b/drivers/gpu/drm/drm_ioctl.c
@@ -437,7 +437,7 @@ EXPORT_SYMBOL(drm_invalid_op);
  */
 static int drm_copy_field(char __user *buf, size_t *buf_len, const char *value)
 {
-	int len;
+	size_t len;
 
 	/* don't overflow userbuf */
 	len = strlen(value);
-- 
2.35.1

