Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E94935904C3
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 18:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236472AbiHKQaI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 12:30:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238424AbiHKQ3W (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 12:29:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5ECAA0255;
        Thu, 11 Aug 2022 09:09:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 53B356144B;
        Thu, 11 Aug 2022 16:09:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AAB6C433C1;
        Thu, 11 Aug 2022 16:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660234143;
        bh=BlKBMOH6o2j7WE88oomjY+BnlOaiVoPJIpUyChZ8a3s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vwj5zc422+HgIR24zlz4AZyx1A0EbgOnosyvilDO8C+YeU12B3DlutDDj8nTLAt8C
         9W1E0cMyrXJR2i73DpjPI1fR4hh8G/9RbXrhbmH2x4WXxPuNbRc/oLbf+dhXSjIele
         IFlbJe3EgAM3pD8/Ml1boqTRxTCVc7jFqIJoUDvZuR+YbYHKam6VgQC6WjvNJpZ+gZ
         Lh+kpMpvEXIb2jxAKBMvgJmyYPmmwhC2BehKuB7n1/8WV9+63Q3L9TWt5uF8GcmUDi
         QwnF0vnQWtKLDrH1yGY0g92yooy2oWNzkNXiHPNclaUy2Vy2Pxegddb9ZZP2eUf17n
         LXr7M3G+BPM5w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ben Skeggs <bskeggs@redhat.com>, Dave Airlie <airlied@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kherbst@redhat.com,
        lyude@redhat.com, airlied@linux.ie, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 16/25] drm/nouveau/nvkm: use list_add_tail() when building object tree
Date:   Thu, 11 Aug 2022 12:08:11 -0400
Message-Id: <20220811160826.1541971-16-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811160826.1541971-1-sashal@kernel.org>
References: <20220811160826.1541971-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Skeggs <bskeggs@redhat.com>

[ Upstream commit 61c1f340bc809a1ca1e3c8794207a91cde1a7c78 ]

Fixes resume from hibernate failing on (at least) TU102, where cursor
channel init failed due to being performed before the core channel.

Not solid idea why suspend-to-ram worked, but, presumably HW being in
an entirely clean state has something to do with it.

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Reviewed-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nvkm/core/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/core/ioctl.c b/drivers/gpu/drm/nouveau/nvkm/core/ioctl.c
index d777df5a64e6..2aa0d6fed580 100644
--- a/drivers/gpu/drm/nouveau/nvkm/core/ioctl.c
+++ b/drivers/gpu/drm/nouveau/nvkm/core/ioctl.c
@@ -128,7 +128,7 @@ nvkm_ioctl_new(struct nvkm_client *client,
 	if (ret == 0) {
 		ret = nvkm_object_init(object);
 		if (ret == 0) {
-			list_add(&object->head, &parent->tree);
+			list_add_tail(&object->head, &parent->tree);
 			if (nvkm_object_insert(object)) {
 				client->data = object;
 				return 0;
-- 
2.35.1

