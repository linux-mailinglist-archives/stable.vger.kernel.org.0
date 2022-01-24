Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24204499683
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:19:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445684AbiAXVEj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:04:39 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:50964 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444177AbiAXVAM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:00:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8690660916;
        Mon, 24 Jan 2022 21:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A4FBC340E5;
        Mon, 24 Jan 2022 21:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058012;
        bh=bTwDCjyp1FfNlpPdJ01CRAf9JzQtnnaDyzG6MorJD20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XXQIHGeLBZkm7hOdrbkTwjs0R/nYoBsOz1m65fFkyiELlgecuYFYjCmJy89nKcH2j
         ob7odbtOAdsK9i5FsgaIQ2u0l/tOAUXIMoNfxLhyYufvsPrNZgr6AjlYPgDgoy1M6p
         juLOGvfQq9H5fQGw2Mghi7QSNaPvI+TurUtRN/Jo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0151/1039] drm/vboxvideo: fix a NULL vs IS_ERR() check
Date:   Mon, 24 Jan 2022 19:32:20 +0100
Message-Id: <20220124184130.236313729@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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



