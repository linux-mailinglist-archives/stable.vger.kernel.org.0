Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 648097387C
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbfGXT36 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:29:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:49606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387710AbfGXT34 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:29:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF7EA218EA;
        Wed, 24 Jul 2019 19:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563996595;
        bh=I0o8rgjdf/CKbZPEcGONjiJMIlSNADY6jq0VB+sJe5I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mjfPA3N+vpBlA1WZPo2J+/Dlipih1Ai3ubfTICDBQZsa73MjtxWLzRIU7pVNovk3D
         WQiJzg9CY/dYsYiX5M5LLmw4mD260K0WOZUQPbwiP+0NBiKbpWX5RUKsQFuICef+l+
         yvSoN1SPpgeJkYRi2K1hWa1AQ7eSDolScyrhpzHc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 150/413] media: coda: increment sequence offset for the last returned frame
Date:   Wed, 24 Jul 2019 21:17:21 +0200
Message-Id: <20190724191745.685642935@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit b3b7d96817cdb8b6fc353867705275dce8f41ccc ]

If no more frames are decoded in bitstream end mode, and a previously
decoded frame has been returned, the firmware still increments the frame
number. To avoid a sequence number mismatch after decoder restart,
increment the sequence_offset correction parameter.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/coda/coda-bit.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 1eeed34f300d..8c9743e067cf 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -2147,6 +2147,9 @@ static void coda_finish_decode(struct coda_ctx *ctx)
 		else if (ctx->display_idx < 0)
 			ctx->hold = true;
 	} else if (decoded_idx == -2) {
+		if (ctx->display_idx >= 0 &&
+		    ctx->display_idx < ctx->num_internal_frames)
+			ctx->sequence_offset++;
 		/* no frame was decoded, we still return remaining buffers */
 	} else if (decoded_idx < 0 || decoded_idx >= ctx->num_internal_frames) {
 		v4l2_err(&dev->v4l2_dev,
-- 
2.20.1



