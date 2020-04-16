Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFE971ACB0E
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395472AbgDPPnR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:43:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:47912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897217AbgDPNfv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:35:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87CE2221F4;
        Thu, 16 Apr 2020 13:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044151;
        bh=W2NX7RUrjeSGIxVbUNcuOSZnXLYhBIfIG0GMm8GFxD4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CA3YU1ROTMzSRFyWYgmhts0fxlJBr5pMZT4lSv8CLqA/AS9xEcXLsa4HPnkeXErQr
         W/EPtslVcyZGB/dUnHB3IHIvgCFASGfzn0uQPQ2KUGxR/MpoD24B/dEzKC/U9ZE35M
         SSXE7At9I5GbKysL6v+haUvU/wqPszGspsX9A1nM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.5 101/257] media: hantro: Read be32 words starting at every fourth byte
Date:   Thu, 16 Apr 2020 15:22:32 +0200
Message-Id: <20200416131338.718932179@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.891903893@linuxfoundation.org>
References: <20200416131325.891903893@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrzej Pietrasiewicz <andrzej.p@collabora.com>

commit e34bca49e4953e5c2afc0425303199a5fd515f82 upstream.

Since (luma/chroma)_qtable is an array of unsigned char, indexing it
returns consecutive byte locations, but we are supposed to read the arrays
in four-byte words. Consequently, we should be pointing
get_unaligned_be32() at consecutive word locations instead.

Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Reviewed-by: Ezequiel Garcia <ezequiel@collabora.com>
Tested-by: Ezequiel Garcia <ezequiel@collabora.com>
Cc: stable@vger.kernel.org
Fixes: 00c30f42c7595f "media: rockchip vpu: remove some unused vars"
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/media/hantro/hantro_h1_jpeg_enc.c     |    9 +++++++--
 drivers/staging/media/hantro/rk3399_vpu_hw_jpeg_enc.c |    9 +++++++--
 2 files changed, 14 insertions(+), 4 deletions(-)

--- a/drivers/staging/media/hantro/hantro_h1_jpeg_enc.c
+++ b/drivers/staging/media/hantro/hantro_h1_jpeg_enc.c
@@ -67,12 +67,17 @@ hantro_h1_jpeg_enc_set_qtable(struct han
 			      unsigned char *chroma_qtable)
 {
 	u32 reg, i;
+	__be32 *luma_qtable_p;
+	__be32 *chroma_qtable_p;
+
+	luma_qtable_p = (__be32 *)luma_qtable;
+	chroma_qtable_p = (__be32 *)chroma_qtable;
 
 	for (i = 0; i < H1_JPEG_QUANT_TABLE_COUNT; i++) {
-		reg = get_unaligned_be32(&luma_qtable[i]);
+		reg = get_unaligned_be32(&luma_qtable_p[i]);
 		vepu_write_relaxed(vpu, reg, H1_REG_JPEG_LUMA_QUAT(i));
 
-		reg = get_unaligned_be32(&chroma_qtable[i]);
+		reg = get_unaligned_be32(&chroma_qtable_p[i]);
 		vepu_write_relaxed(vpu, reg, H1_REG_JPEG_CHROMA_QUAT(i));
 	}
 }
--- a/drivers/staging/media/hantro/rk3399_vpu_hw_jpeg_enc.c
+++ b/drivers/staging/media/hantro/rk3399_vpu_hw_jpeg_enc.c
@@ -98,12 +98,17 @@ rk3399_vpu_jpeg_enc_set_qtable(struct ha
 			       unsigned char *chroma_qtable)
 {
 	u32 reg, i;
+	__be32 *luma_qtable_p;
+	__be32 *chroma_qtable_p;
+
+	luma_qtable_p = (__be32 *)luma_qtable;
+	chroma_qtable_p = (__be32 *)chroma_qtable;
 
 	for (i = 0; i < VEPU_JPEG_QUANT_TABLE_COUNT; i++) {
-		reg = get_unaligned_be32(&luma_qtable[i]);
+		reg = get_unaligned_be32(&luma_qtable_p[i]);
 		vepu_write_relaxed(vpu, reg, VEPU_REG_JPEG_LUMA_QUAT(i));
 
-		reg = get_unaligned_be32(&chroma_qtable[i]);
+		reg = get_unaligned_be32(&chroma_qtable_p[i]);
 		vepu_write_relaxed(vpu, reg, VEPU_REG_JPEG_CHROMA_QUAT(i));
 	}
 }


