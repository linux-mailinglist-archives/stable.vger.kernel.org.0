Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62E7E69CE47
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:58:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232634AbjBTN6M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:58:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232642AbjBTN6L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:58:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15E931EBE2
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:57:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90B25B80D4F
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:57:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2301C433EF;
        Mon, 20 Feb 2023 13:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901463;
        bh=fmwrvlSnzYMpOU6Bb/kbeD5NAHZC6hAf1LWtjxppyh8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JE64hPm2QuZW7y5s3DMkzWgkV0K5LO6nbRiPFLFZq9ApCj2FUYhpysPXrEd0rH5ak
         vsGMkjb9a8uBZDuqgCx8WrbWEcCL0m7U7eht9zFw0MfYjGP7ffvtr5eWP3d74Du/UA
         64Mb277FT2CIdjyH+cb/KR1CzLTV6AmJDvmCak84=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ben Skeggs <bskeggs@redhat.com>,
        Lyude Paul <lyude@redhat.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 026/118] drm/nouveau/devinit/tu102-: wait for GFW_BOOT_PROGRESS == COMPLETED
Date:   Mon, 20 Feb 2023 14:35:42 +0100
Message-Id: <20230220133601.471618553@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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



