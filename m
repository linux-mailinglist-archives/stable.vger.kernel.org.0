Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB78C60AFF3
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 18:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbiJXP7c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 11:59:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231911AbiJXP6Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 11:58:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60439AB80F;
        Mon, 24 Oct 2022 07:53:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1A08FB816A0;
        Mon, 24 Oct 2022 12:30:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73C8AC433C1;
        Mon, 24 Oct 2022 12:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614607;
        bh=UgTu8csKsVfByuJaIAwUtmNsQx8OeEppTNvLnEVGaeY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cqbx1NdaksUjfD4iQDNqCX7TZvaaYX7kX+x6MHYRpr+N7pq8J5Oja8qbzfji3FEI2
         Ue4W8AFtWnvGemDFZO0PBdP2+OWTg20d0dCqhbn0/5W26WzB+Upp/2YQs+66xX0+Uy
         0C01G1cuMRGc3G6XuJU150VdNFlfMlVuNWQ6GLkk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Javier Martinez Canillas <javierm@redhat.com>,
        Peter Robinson <pbrobinson@gmail.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 326/390] drm: Use size_t type for len variable in drm_copy_field()
Date:   Mon, 24 Oct 2022 13:32:03 +0200
Message-Id: <20221024113036.888486566@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



