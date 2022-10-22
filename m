Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE73D608756
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232168AbiJVIAu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:00:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232439AbiJVH7A (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:59:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CC8A173FE8;
        Sat, 22 Oct 2022 00:49:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 314D460AC7;
        Sat, 22 Oct 2022 07:49:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4879BC433C1;
        Sat, 22 Oct 2022 07:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424941;
        bh=xvO8OBdejBy1K8qqYfbWb8o0/2MXHQoNgGR1UEb5JqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EQYwhsGGjLj3UMBFgDAZZHSx24aCMm9iORVKTQ+RVS/6AjwhQW8Fr054abjsegjFQ
         a2w7Z/F8R6EV/f6gpUT4jsLr87XnCf6al/umTxty/gXreuCWAusCzkDMdbUg63s3ms
         TAHejG+6Juv+BaDjLQKyNezZufrQuTWWJry+7s90=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rafael Mendonca <rafaelmendsr@gmail.com>,
        Martin Krastev <krastevm@vmware.com>,
        Zack Rusin <zackr@vmware.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 334/717] drm/vmwgfx: Fix memory leak in vmw_mksstat_add_ioctl()
Date:   Sat, 22 Oct 2022 09:23:33 +0200
Message-Id: <20221022072509.880642724@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael Mendonca <rafaelmendsr@gmail.com>

[ Upstream commit a40c7f61d12fbd1e785e59140b9efd57127c0c33 ]

If the copy of the description string from userspace fails, then the page
for the instance descriptor doesn't get freed before returning -EFAULT,
which leads to a memleak.

Fixes: 7a7a933edd6c ("drm/vmwgfx: Introduce VMware mks-guest-stats")
Signed-off-by: Rafael Mendonca <rafaelmendsr@gmail.com>
Reviewed-by: Martin Krastev <krastevm@vmware.com>
Signed-off-by: Zack Rusin <zackr@vmware.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220916204751.720716-1-rafaelmendsr@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_msg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_msg.c b/drivers/gpu/drm/vmwgfx/vmwgfx_msg.c
index 2aceac7856e2..089046fa21be 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_msg.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_msg.c
@@ -1076,6 +1076,7 @@ int vmw_mksstat_add_ioctl(struct drm_device *dev, void *data,
 
 	if (desc_len < 0) {
 		atomic_set(&dev_priv->mksstat_user_pids[slot], 0);
+		__free_page(page);
 		return -EFAULT;
 	}
 
-- 
2.35.1



