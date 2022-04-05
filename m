Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44DF84F3BAB
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236594AbiDEMA5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357601AbiDEK0h (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:26:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9974231517;
        Tue,  5 Apr 2022 03:10:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2BFC7617A4;
        Tue,  5 Apr 2022 10:10:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 331D7C385A0;
        Tue,  5 Apr 2022 10:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153427;
        bh=Qa3RGJUb/13qAmle082Sl0DJGE+PN6Kzlk1E+pmBBJQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iF2+jJufP/I5bR4H4PQvTzLJ24GM2aO2CzMAuxzGuGJdH1iShE00SoFN0ZIZZ4/Zm
         wtd88viFb/mpm5XB/JiQ/bT6UcqxuCQdAMVoyPHixthxslfsKMEv7XB7PkEsI79Y+0
         3kzuCqYhlOL951lFTTEr8mrQ9YLieVnUeOv1yH9Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jernej Skrabec <jernej.skrabec@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 219/599] media: cedrus: h264: Fix neighbour info buffer size
Date:   Tue,  5 Apr 2022 09:28:33 +0200
Message-Id: <20220405070305.361043377@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
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

From: Jernej Skrabec <jernej.skrabec@gmail.com>

[ Upstream commit fecd363ae2d5042553370b0adf60c47e35c34a83 ]

According to BSP library source, H264 neighbour info buffer size needs
to be 32 kiB for H6. This is similar to H265 decoding, which also needs
double buffer size in comparison to older Cedrus core generations.

Increase buffer size to cover H6 needs. Since increase is not that big
in absolute numbers, it doesn't make sense to complicate logic for older
generations.

Issue was discovered using iommu and cross checked with BSP library
source.

Fixes: 6eb9b758e307 ("media: cedrus: Add H264 decoding support")
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/sunxi/cedrus/cedrus_h264.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_h264.c b/drivers/staging/media/sunxi/cedrus/cedrus_h264.c
index de7442d4834d..d3e26bfe6c90 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus_h264.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_h264.c
@@ -38,7 +38,7 @@ struct cedrus_h264_sram_ref_pic {
 
 #define CEDRUS_H264_FRAME_NUM		18
 
-#define CEDRUS_NEIGHBOR_INFO_BUF_SIZE	(16 * SZ_1K)
+#define CEDRUS_NEIGHBOR_INFO_BUF_SIZE	(32 * SZ_1K)
 #define CEDRUS_MIN_PIC_INFO_BUF_SIZE       (130 * SZ_1K)
 
 static void cedrus_h264_write_sram(struct cedrus_dev *dev,
-- 
2.34.1



