Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25F4049994F
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:44:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1453974AbiAXVbU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:31:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1450888AbiAXVVn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:21:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92C9FC0604E3;
        Mon, 24 Jan 2022 12:16:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 30AF661480;
        Mon, 24 Jan 2022 20:16:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00002C340E7;
        Mon, 24 Jan 2022 20:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055386;
        bh=bTwDCjyp1FfNlpPdJ01CRAf9JzQtnnaDyzG6MorJD20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZSClZUqWt9E7f8FSzceuWeLcdtj+yBgojGyXR7K/p5CvfPHlvknw1LXuyBEdvR+Rp
         2QWWkZYq5z8Ntg1PpojVk9ahlP2VSitS0ksTo7FUu7LPnQkBxKhEwE96hHeC1s6GYg
         MpIUj/Y2497KHD4Ps7VQMmQztP8vhMaljZpKdSdU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 134/846] drm/vboxvideo: fix a NULL vs IS_ERR() check
Date:   Mon, 24 Jan 2022 19:34:11 +0100
Message-Id: <20220124184105.613729259@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit cebbb5c46d0cb0615fd0c62dea9b44273d0a9780 ]

The devm_gen_pool_create() function never returns NULL, it returns
error pointers.

Fixes: 4cc9b565454b ("drm/vboxvideo: Use devm_gen_pool_create")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20211118111233.GA1147@kili
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vboxvideo/vbox_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/vboxvideo/vbox_main.c b/drivers/gpu/drm/vboxvideo/vbox_main.c
index f28779715ccda..c9e8b3a63c621 100644
--- a/drivers/gpu/drm/vboxvideo/vbox_main.c
+++ b/drivers/gpu/drm/vboxvideo/vbox_main.c
@@ -127,8 +127,8 @@ int vbox_hw_init(struct vbox_private *vbox)
 	/* Create guest-heap mem-pool use 2^4 = 16 byte chunks */
 	vbox->guest_pool = devm_gen_pool_create(vbox->ddev.dev, 4, -1,
 						"vboxvideo-accel");
-	if (!vbox->guest_pool)
-		return -ENOMEM;
+	if (IS_ERR(vbox->guest_pool))
+		return PTR_ERR(vbox->guest_pool);
 
 	ret = gen_pool_add_virt(vbox->guest_pool,
 				(unsigned long)vbox->guest_heap,
-- 
2.34.1



