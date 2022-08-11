Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE0AF590069
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 17:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236194AbiHKPlr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 11:41:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236647AbiHKPlN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 11:41:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30ADAA220F;
        Thu, 11 Aug 2022 08:36:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F296B82157;
        Thu, 11 Aug 2022 15:36:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B72B7C433C1;
        Thu, 11 Aug 2022 15:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660232199;
        bh=rzdAzLrpMW9Jg5EEs7PVdTHeceWVECVmu/G0Pm4ZQys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NHCdKlaLZDol8+/Og7id1JN2+Nrq3fQWV2QSh90hYUwwRxtUIcNoJ9t0gypgBMfwa
         N8ibRl6ItyGtauQCB9J67nD5axUrrmGkB26RXTtxStc/Oonv4RFhVDKtWKRDxBuFwL
         D0g3ZeXbS+SDL987jvgCwI/exV6zG4MHVlZzYODGTFUwSAciwir5u5v3+xB4QlGkQi
         oCzXEGG/MRX4wr0wkUIkO/+OvXyI0W5zW+XbBsn7KvCCeBjavgYTacska0w9Pm8LJ7
         qs1WPNTBw5KLrm3k9U0tnciZ1Jo8I9YFx5T0+8a+WWDB4lytYPtkXcyo6twl5Gfa3U
         cAmkTihPbB8TA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ben Skeggs <bskeggs@redhat.com>, Dave Airlie <airlied@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kherbst@redhat.com,
        lyude@redhat.com, airlied@linux.ie, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.19 069/105] drm/nouveau/nvkm: use list_add_tail() when building object tree
Date:   Thu, 11 Aug 2022 11:27:53 -0400
Message-Id: <20220811152851.1520029-69-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811152851.1520029-1-sashal@kernel.org>
References: <20220811152851.1520029-1-sashal@kernel.org>
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
index 735cb6816f10..06b2f675f5da 100644
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

