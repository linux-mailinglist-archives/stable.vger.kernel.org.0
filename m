Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81D0250159B
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245217AbiDNNsH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:48:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343928AbiDNNja (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:39:30 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 420C195A28;
        Thu, 14 Apr 2022 06:35:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AED52CE296C;
        Thu, 14 Apr 2022 13:35:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4016C385A5;
        Thu, 14 Apr 2022 13:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943326;
        bh=i20hMlwUrKYD3765QCI98YqipXHd9k85Jzwc+oQE5hA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CVTdLxcV1/rNRtIIGtdYM9HLUKcsbxim8REa8W+eeIDgKZQn3woiaXHZyeuH4BEq/
         XIDk40+EVoV/Tcj3MgjvgjUZA2txaLzxtkLcTwgC8gx+zPwRPkgyRDSDnpY6gWsx1i
         i1V5LTWH9SgHTYvEtPLP1Zgw3Uzs1Y9LA7huEkPc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wenst@chromium.org>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 115/475] media: hantro: Fix overfill bottom register field name
Date:   Thu, 14 Apr 2022 15:08:20 +0200
Message-Id: <20220414110858.370629779@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit 89d78e0133e71ba324fb67ca776223fba4353418 ]

The Hantro H1 hardware can crop off pixels from the right and bottom of
the source frame. These are controlled with the H1_REG_IN_IMG_CTRL_OVRFLB
and H1_REG_IN_IMG_CTRL_OVRFLR in the H1_REG_IN_IMG_CTRL register.

The ChromeOS kernel driver that this was based on incorrectly added the
_D4 suffix H1_REG_IN_IMG_CTRL_OVRFLB. This field crops the bottom of the
input frame, and the number is _not_ divided by 4. [1]

Correct the name to avoid confusion when crop support with the selection
API is added.

[1] https://chromium.googlesource.com/chromiumos/third_party/kernel/+/refs/ \
	heads/chromeos-4.19/drivers/staging/media/hantro/hantro_h1_vp8_enc.c#377

Fixes: 775fec69008d ("media: add Rockchip VPU JPEG encoder driver")
Fixes: a29add8c9bb2 ("media: rockchip/vpu: rename from rockchip to hantro")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/hantro/hantro_h1_jpeg_enc.c | 2 +-
 drivers/staging/media/hantro/hantro_h1_regs.h     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/hantro/hantro_h1_jpeg_enc.c b/drivers/staging/media/hantro/hantro_h1_jpeg_enc.c
index 8b76f1f13b06..e81a354b8872 100644
--- a/drivers/staging/media/hantro/hantro_h1_jpeg_enc.c
+++ b/drivers/staging/media/hantro/hantro_h1_jpeg_enc.c
@@ -23,7 +23,7 @@ static void hantro_h1_set_src_img_ctrl(struct hantro_dev *vpu,
 
 	reg = H1_REG_IN_IMG_CTRL_ROW_LEN(pix_fmt->width)
 		| H1_REG_IN_IMG_CTRL_OVRFLR_D4(0)
-		| H1_REG_IN_IMG_CTRL_OVRFLB_D4(0)
+		| H1_REG_IN_IMG_CTRL_OVRFLB(0)
 		| H1_REG_IN_IMG_CTRL_FMT(ctx->vpu_src_fmt->enc_fmt);
 	vepu_write_relaxed(vpu, reg, H1_REG_IN_IMG_CTRL);
 }
diff --git a/drivers/staging/media/hantro/hantro_h1_regs.h b/drivers/staging/media/hantro/hantro_h1_regs.h
index d6e9825bb5c7..30e7e7b920b5 100644
--- a/drivers/staging/media/hantro/hantro_h1_regs.h
+++ b/drivers/staging/media/hantro/hantro_h1_regs.h
@@ -47,7 +47,7 @@
 #define H1_REG_IN_IMG_CTRL				0x03c
 #define     H1_REG_IN_IMG_CTRL_ROW_LEN(x)		((x) << 12)
 #define     H1_REG_IN_IMG_CTRL_OVRFLR_D4(x)		((x) << 10)
-#define     H1_REG_IN_IMG_CTRL_OVRFLB_D4(x)		((x) << 6)
+#define     H1_REG_IN_IMG_CTRL_OVRFLB(x)		((x) << 6)
 #define     H1_REG_IN_IMG_CTRL_FMT(x)			((x) << 2)
 #define H1_REG_ENC_CTRL0				0x040
 #define    H1_REG_ENC_CTRL0_INIT_QP(x)			((x) << 26)
-- 
2.34.1



