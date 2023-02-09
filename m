Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7061690701
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 12:23:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbjBILW7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 06:22:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230392AbjBILWH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 06:22:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A7605FB7A;
        Thu,  9 Feb 2023 03:18:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3959CB81FFE;
        Thu,  9 Feb 2023 11:18:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0CB1C433D2;
        Thu,  9 Feb 2023 11:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675941499;
        bh=fmwrvlSnzYMpOU6Bb/kbeD5NAHZC6hAf1LWtjxppyh8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aEGrR/WctjNNwsAnEovCEFcZYJ+HI0vj8fVRy8H3bDpB9z9vWiz/li+bkonSzMWN9
         R+VSd9jTM1KH1MEiPCLuNse0OwdxYBXdotRI+G3nAuRaBmQpRPC2rv5AoZuJYcpmTm
         XEv5vj6Ii7+3WlMbct5xhGsx+nZ0avdxCkAM3YpTENvR97tZ7YqLu+UCwJk2xpw/3L
         THVelHKwC5cnXFmy9EOHXJM6YYKhCndYb4+UiS2q1rhvMSEcBSvxryOdQHmp+6TRo7
         0WeQIKef24rXOvqEEiSbi/YRYBPzJG8qPIS05OCkwz2LOxh29LaJx81dJtV4rlb1bc
         vjlwfaE4vp0og==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ben Skeggs <bskeggs@redhat.com>, Lyude Paul <lyude@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kherbst@redhat.com,
        airlied@gmail.com, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 12/17] drm/nouveau/devinit/tu102-: wait for GFW_BOOT_PROGRESS == COMPLETED
Date:   Thu,  9 Feb 2023 06:17:24 -0500
Message-Id: <20230209111731.1892569-12-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209111731.1892569-1-sashal@kernel.org>
References: <20230209111731.1892569-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Skeggs <bskeggs@redhat.com>

[ Upstream commit d22915d22ded21fd5b24b60d174775789f173997 ]

Starting from Turing, the driver is no longer responsible for initiating
DEVINIT when required as the GPU started loading a FW image from ROM and
executing DEVINIT itself after power-on.

However - we apparently still need to wait for it to complete.

This should correct some issues with runpm on some systems, where we get
control of the HW before it's been fully reinitialised after resume from
suspend.

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230130223715.1831509-1-bskeggs@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/nouveau/nvkm/subdev/devinit/tu102.c   | 23 +++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/devinit/tu102.c b/drivers/gpu/drm/nouveau/nvkm/subdev/devinit/tu102.c
index 634f64f88fc8b..81a1ad2c88a7e 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/devinit/tu102.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/devinit/tu102.c
@@ -65,10 +65,33 @@ tu102_devinit_pll_set(struct nvkm_devinit *init, u32 type, u32 freq)
 	return ret;
 }
 
+static int
+tu102_devinit_wait(struct nvkm_device *device)
+{
+	unsigned timeout = 50 + 2000;
+
+	do {
+		if (nvkm_rd32(device, 0x118128) & 0x00000001) {
+			if ((nvkm_rd32(device, 0x118234) & 0x000000ff) == 0xff)
+				return 0;
+		}
+
+		usleep_range(1000, 2000);
+	} while (timeout--);
+
+	return -ETIMEDOUT;
+}
+
 int
 tu102_devinit_post(struct nvkm_devinit *base, bool post)
 {
 	struct nv50_devinit *init = nv50_devinit(base);
+	int ret;
+
+	ret = tu102_devinit_wait(init->base.subdev.device);
+	if (ret)
+		return ret;
+
 	gm200_devinit_preos(init, post);
 	return 0;
 }
-- 
2.39.0

