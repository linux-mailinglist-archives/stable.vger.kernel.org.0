Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2F5D697AC
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 17:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731960AbfGONwi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 09:52:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:46878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732222AbfGONwh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 09:52:37 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18FFC20651;
        Mon, 15 Jul 2019 13:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563198756;
        bh=hOnzkvj9JBoJAX9b2Kpm3FhvJ+yQPuvI4+b0Ggxgo8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s3CHFOfCyDBYpLPjhBmnrQPiJ2NRhsCsOa9y4Zh1h3RLBmK1VtTiMfckUYE5iB6yK
         KPzH/WWAIXBI5aoecHQD0KSTIE1rD7RPCYpTpHeIXz4EBk5xCWQPipVdizvKiIZojq
         M6HbfhMV0bYH98jFORPhyWMu3ibmiCiTGOCkINIU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 096/249] media: s5p-mfc: fix reading min scratch buffer size on MFC v6/v7
Date:   Mon, 15 Jul 2019 09:44:21 -0400
Message-Id: <20190715134655.4076-96-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715134655.4076-1-sashal@kernel.org>
References: <20190715134655.4076-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit be22203aec440c1761ce8542c2636ac6c8951e3a ]

MFC v6 and v7 has no register to read min scratch buffer size, so it has
to be read conditionally only if hardware supports it. This fixes following
NULL pointer exception on SoCs with MFC v6/v7:

8<--- cut here ---
Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = f25837f9
[00000000] *pgd=bd93d835
Internal error: Oops: 17 [#1] PREEMPT SMP ARM
Modules linked in: btmrvl_sdio btmrvl bluetooth mwifiex_sdio mwifiex ecdh_generic ecc
Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
PC is at s5p_mfc_get_min_scratch_buf_size+0x30/0x3c
LR is at s5p_mfc_get_min_scratch_buf_size+0x28/0x3c
...
[<c074f998>] (s5p_mfc_get_min_scratch_buf_size) from [<c0745bc0>] (s5p_mfc_irq+0x814/0xa5c)
[<c0745bc0>] (s5p_mfc_irq) from [<c019a218>] (__handle_irq_event_percpu+0x64/0x3f8)
[<c019a218>] (__handle_irq_event_percpu) from [<c019a5d8>] (handle_irq_event_percpu+0x2c/0x7c)
[<c019a5d8>] (handle_irq_event_percpu) from [<c019a660>] (handle_irq_event+0x38/0x5c)
[<c019a660>] (handle_irq_event) from [<c019ebc4>] (handle_fasteoi_irq+0xc4/0x180)
[<c019ebc4>] (handle_fasteoi_irq) from [<c0199270>] (generic_handle_irq+0x24/0x34)
[<c0199270>] (generic_handle_irq) from [<c0199888>] (__handle_domain_irq+0x7c/0xec)
[<c0199888>] (__handle_domain_irq) from [<c04ac298>] (gic_handle_irq+0x58/0x9c)
[<c04ac298>] (gic_handle_irq) from [<c0101ab0>] (__irq_svc+0x70/0xb0)
Exception stack(0xe73ddc60 to 0xe73ddca8)
...
[<c0101ab0>] (__irq_svc) from [<c01967d8>] (console_unlock+0x5a8/0x6a8)
[<c01967d8>] (console_unlock) from [<c01981d0>] (vprintk_emit+0x118/0x2d8)
[<c01981d0>] (vprintk_emit) from [<c01983b0>] (vprintk_default+0x20/0x28)
[<c01983b0>] (vprintk_default) from [<c01989b4>] (printk+0x30/0x54)
[<c01989b4>] (printk) from [<c07500b8>] (s5p_mfc_init_decode_v6+0x1d4/0x284)
[<c07500b8>] (s5p_mfc_init_decode_v6) from [<c07230d0>] (vb2_start_streaming+0x24/0x150)
[<c07230d0>] (vb2_start_streaming) from [<c0724e4c>] (vb2_core_streamon+0x11c/0x15c)
[<c0724e4c>] (vb2_core_streamon) from [<c07478b8>] (vidioc_streamon+0x64/0xa0)
[<c07478b8>] (vidioc_streamon) from [<c0709640>] (__video_do_ioctl+0x28c/0x45c)
[<c0709640>] (__video_do_ioctl) from [<c0709bc8>] (video_usercopy+0x260/0x8a4)
[<c0709bc8>] (video_usercopy) from [<c02b3820>] (do_vfs_ioctl+0xb0/0x9fc)
[<c02b3820>] (do_vfs_ioctl) from [<c02b41a0>] (ksys_ioctl+0x34/0x58)
[<c02b41a0>] (ksys_ioctl) from [<c0101000>] (ret_fast_syscall+0x0/0x28)
Exception stack(0xe73ddfa8 to 0xe73ddff0)
...
---[ end trace 376cf5ba6e0bee93 ]---

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 4e936b95018a..481088a83212 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -523,7 +523,8 @@ static void s5p_mfc_handle_seq_done(struct s5p_mfc_ctx *ctx,
 				dev);
 		ctx->mv_count = s5p_mfc_hw_call(dev->mfc_ops, get_mv_count,
 				dev);
-		ctx->scratch_buf_size = s5p_mfc_hw_call(dev->mfc_ops,
+		if (FW_HAS_E_MIN_SCRATCH_BUF(dev))
+			ctx->scratch_buf_size = s5p_mfc_hw_call(dev->mfc_ops,
 						get_min_scratch_buf_size, dev);
 		if (ctx->img_width == 0 || ctx->img_height == 0)
 			ctx->state = MFCINST_ERROR;
-- 
2.20.1

