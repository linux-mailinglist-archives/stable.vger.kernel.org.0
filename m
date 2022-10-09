Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 294AB5F95DB
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 02:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232344AbiJJAZm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 20:25:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232700AbiJJAWH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 20:22:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65D1FDE97;
        Sun,  9 Oct 2022 16:56:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA26F60DCC;
        Sun,  9 Oct 2022 23:56:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D642C4347C;
        Sun,  9 Oct 2022 23:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665359770;
        bh=UgTu8csKsVfByuJaIAwUtmNsQx8OeEppTNvLnEVGaeY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ybnoph3zomPCV3e6VY0euemqCYKbCRfeYrL3FZVeNMv8FQDY13YHs47VSHWW3MivS
         0AA5hqaqKol4TLRDb11y4I7jBMh6A/GrosAvhv+TkgTYHcG8Smv5bP0X/MwsGfVxc9
         Pphbbp9ux8og8oLGXllwR+7TI1hn8KeafP8k6E1kTFe8ItiF4mGOlsGaAwrHrf44Ss
         RJLKRQN5NsB8n67rn/tb9HbVXbfCMcp1Wtegb86F0W3g/9IMXagOSftmNtGL3MhMUb
         Igcaa4V3w4d88W3JdiBHItKPWD/avr49gHe5bqPuT2fcXWJsy7isYiz5hb/SBG/Sa3
         8SnwLTQfYcLNA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Javier Martinez Canillas <javierm@redhat.com>,
        Peter Robinson <pbrobinson@gmail.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Sasha Levin <sashal@kernel.org>,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        airlied@gmail.com, daniel@ffwll.ch, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 02/22] drm: Use size_t type for len variable in drm_copy_field()
Date:   Sun,  9 Oct 2022 19:55:20 -0400
Message-Id: <20221009235540.1231640-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009235540.1231640-1-sashal@kernel.org>
References: <20221009235540.1231640-1-sashal@kernel.org>
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
index 4606cc938b36..a15d55d06510 100644
--- a/drivers/gpu/drm/drm_ioctl.c
+++ b/drivers/gpu/drm/drm_ioctl.c
@@ -473,7 +473,7 @@ EXPORT_SYMBOL(drm_invalid_op);
  */
 static int drm_copy_field(char __user *buf, size_t *buf_len, const char *value)
 {
-	int len;
+	size_t len;
 
 	/* don't overflow userbuf */
 	len = strlen(value);
-- 
2.35.1

