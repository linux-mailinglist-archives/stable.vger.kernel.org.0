Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9979137C548
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234120AbhELPjN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:39:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:46626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233925AbhELPbv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:31:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 73F266194C;
        Wed, 12 May 2021 15:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832584;
        bh=CPQHsJ5C8ZacX4f7DbLJ/TAPTK6DTW61Q7UWat2tAKo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2YuwHhaNZnmk6cF6r30V6BgtsnKE3y9LmSP4ML3K6ljvCGApuhbp/HokqH4DTbWc9
         1Piuxy5pVaFMioyMdztFlBO1NwL4oQXo92snNDsNx2sg6/s7FqnMyLyiADLGIFB7OR
         6kvsQ3bQw96Ta8IoyYLycJunwyAv70O6FHc6vmEA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jernej Skrabec <jernej.skrabec@siol.net>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 340/530] media: cedrus: Fix H265 status definitions
Date:   Wed, 12 May 2021 16:47:30 +0200
Message-Id: <20210512144830.968114836@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jernej Skrabec <jernej.skrabec@siol.net>

[ Upstream commit 147d211cc9b4d753148d1640a1758b25edfbf437 ]

Some of the H265 status flags are wrong. Redefine them to corespond to
Allwinner CedarC open source userspace library. Only one of these flags
is actually used and new value also matches value used in libvdpau-sunxi
library, which is proven to be working.

Note that wrong (old) value in right circumstances (in combination with
another H265 decoding bug) causes driver lock up. With this fix decoding
is still broken (green output) but at least driver doesn't lock up.

Fixes: 86caab29da78 ("media: cedrus: Add HEVC/H.265 decoding support")
Signed-off-by: Jernej Skrabec <jernej.skrabec@siol.net>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../staging/media/sunxi/cedrus/cedrus_regs.h    | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_regs.h b/drivers/staging/media/sunxi/cedrus/cedrus_regs.h
index 66b152f18d17..426387cf16ac 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus_regs.h
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_regs.h
@@ -443,16 +443,17 @@
 #define VE_DEC_H265_STATUS_STCD_BUSY		BIT(21)
 #define VE_DEC_H265_STATUS_WB_BUSY		BIT(20)
 #define VE_DEC_H265_STATUS_BS_DMA_BUSY		BIT(19)
-#define VE_DEC_H265_STATUS_IQIT_BUSY		BIT(18)
+#define VE_DEC_H265_STATUS_IT_BUSY		BIT(18)
 #define VE_DEC_H265_STATUS_INTER_BUSY		BIT(17)
 #define VE_DEC_H265_STATUS_MORE_DATA		BIT(16)
-#define VE_DEC_H265_STATUS_VLD_BUSY		BIT(14)
-#define VE_DEC_H265_STATUS_DEBLOCKING_BUSY	BIT(13)
-#define VE_DEC_H265_STATUS_DEBLOCKING_DRAM_BUSY	BIT(12)
-#define VE_DEC_H265_STATUS_INTRA_BUSY		BIT(11)
-#define VE_DEC_H265_STATUS_SAO_BUSY		BIT(10)
-#define VE_DEC_H265_STATUS_MVP_BUSY		BIT(9)
-#define VE_DEC_H265_STATUS_SWDEC_BUSY		BIT(8)
+#define VE_DEC_H265_STATUS_DBLK_BUSY		BIT(15)
+#define VE_DEC_H265_STATUS_IREC_BUSY		BIT(14)
+#define VE_DEC_H265_STATUS_INTRA_BUSY		BIT(13)
+#define VE_DEC_H265_STATUS_MCRI_BUSY		BIT(12)
+#define VE_DEC_H265_STATUS_IQIT_BUSY		BIT(11)
+#define VE_DEC_H265_STATUS_MVP_BUSY		BIT(10)
+#define VE_DEC_H265_STATUS_IS_BUSY		BIT(9)
+#define VE_DEC_H265_STATUS_VLD_BUSY		BIT(8)
 #define VE_DEC_H265_STATUS_OVER_TIME		BIT(3)
 #define VE_DEC_H265_STATUS_VLD_DATA_REQ		BIT(2)
 #define VE_DEC_H265_STATUS_ERROR		BIT(1)
-- 
2.30.2



