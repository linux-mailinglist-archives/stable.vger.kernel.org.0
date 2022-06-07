Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECD1E540B6F
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:29:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351311AbiFGS2z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:28:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351355AbiFGSXO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:23:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAE8DC6E46;
        Tue,  7 Jun 2022 10:54:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F3F3617B4;
        Tue,  7 Jun 2022 17:54:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E38CC341C0;
        Tue,  7 Jun 2022 17:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624440;
        bh=LjIQQHdcsPNJjZ0Z2E4ildPKtZJSSNuzjswYamyI6tw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=We51GThjV+oLwsCqJzCIdpQY8/ahvCJmW/3dtheRvLNJl7K1P/VFMRTalSlHCx1QY
         jzXDfE8l468EsHfxM1XANC5tMRYtlpr6Xmzx5of/UJPDgE11gfOuR8sYYV19vT5r+8
         JeX0MBwLjVfA1Dy3r/1ROfpEWn4qTVU/ZDP1ESpA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 328/667] media: hantro: HEVC: Fix tile info buffer value computation
Date:   Tue,  7 Jun 2022 18:59:53 +0200
Message-Id: <20220607164944.605760477@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Gaignard <benjamin.gaignard@collabora.com>

[ Upstream commit d7f4149df818463c1d7094b35db6ebd79f46c7bd ]

Use pps->column_width_minus1[j] + 1 as value for the tile info buffer
instead of pps->column_width_minus1[j + 1].
The patch fixes DBLK_E_VIXS_2, DBLK_F_VIXS_2, DBLK_G_VIXS_2,
SAO_B_MediaTek_5, TILES_A_Cisco_2 and TILES_B_Cisco_1 tests in fluster.

Fixes: cb5dd5a0fa51 ("media: hantro: Introduce G2/HEVC decoder")
Signed-off-by: Benjamin Gaignard <benjamin.gaignard@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/hantro/hantro_g2_hevc_dec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/hantro/hantro_g2_hevc_dec.c b/drivers/staging/media/hantro/hantro_g2_hevc_dec.c
index ee069564205a..e63b777d4266 100644
--- a/drivers/staging/media/hantro/hantro_g2_hevc_dec.c
+++ b/drivers/staging/media/hantro/hantro_g2_hevc_dec.c
@@ -74,7 +74,7 @@ static void prepare_tile_info_buffer(struct hantro_ctx *ctx)
 					no_chroma = 1;
 				for (j = 0, tmp_w = 0; j < num_tile_cols - 1; j++) {
 					tmp_w += pps->column_width_minus1[j] + 1;
-					*p++ = pps->column_width_minus1[j + 1];
+					*p++ = pps->column_width_minus1[j] + 1;
 					*p++ = h;
 					if (i == 0 && h == 1 && ctb_size == 16)
 						no_chroma = 1;
-- 
2.35.1



