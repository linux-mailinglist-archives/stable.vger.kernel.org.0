Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3DA779968
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729059AbfG2T0u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:26:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:39268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727100AbfG2T0t (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:26:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 356CD2070B;
        Mon, 29 Jul 2019 19:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564428408;
        bh=/Awqggy1rrV2zfN1OOcYs6XMNfo1uQguhLsPUXJXf84=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sB/nFHA3TKviFBVhotigrUNqgSt99ZODyDRgz291beA7doZ/BCon27Z+1Frxl+wUb
         1+rmk+NLZkap4nc/C9XVQaQ1DzJ4GHBfzsxYHT39x3B7827bgN3LnEHXXBQAkygATw
         TOloy13d4n1hpN3/Wp6pgs5TxPdnmO1pXZ1xG5GQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 067/293] media: coda: fix mpeg2 sequence number handling
Date:   Mon, 29 Jul 2019 21:19:18 +0200
Message-Id: <20190729190829.791135972@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190820.321094988@linuxfoundation.org>
References: <20190729190820.321094988@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 56d159a4ec6d8da7313aac6fcbb95d8fffe689ba ]

Sequence number handling assumed that the BIT processor frame number
starts counting at 1, but this is not true for the MPEG-2 decoder,
which starts at 0. Fix the sequence counter offset detection to handle
this.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/coda/coda-bit.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 6eee55430d46..43eb5d51cf23 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -1679,6 +1679,7 @@ static int __coda_start_decoding(struct coda_ctx *ctx)
 		v4l2_err(&dev->v4l2_dev, "CODA_COMMAND_SEQ_INIT timeout\n");
 		return ret;
 	}
+	ctx->sequence_offset = ~0U;
 	ctx->initialized = 1;
 
 	/* Update kfifo out pointer from coda bitstream read pointer */
@@ -2095,7 +2096,9 @@ static void coda_finish_decode(struct coda_ctx *ctx)
 		v4l2_err(&dev->v4l2_dev,
 			 "decoded frame index out of range: %d\n", decoded_idx);
 	} else {
-		val = coda_read(dev, CODA_RET_DEC_PIC_FRAME_NUM) - 1;
+		val = coda_read(dev, CODA_RET_DEC_PIC_FRAME_NUM);
+		if (ctx->sequence_offset == -1)
+			ctx->sequence_offset = val;
 		val -= ctx->sequence_offset;
 		spin_lock_irqsave(&ctx->buffer_meta_lock, flags);
 		if (!list_empty(&ctx->buffer_meta_list)) {
-- 
2.20.1



