Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA85D7F492
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 12:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391035AbfHBJbS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:31:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:57296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390003AbfHBJbS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:31:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7AE521783;
        Fri,  2 Aug 2019 09:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564738277;
        bh=pciexHLHPTKBQ0bRSuZ1KyLA+O7ZNfCng+qeCHSWRRI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qlv7/N36s4gfmeZAs0s00hhieCXb2UTQJJd1osEhUIqsWqwSinkp5pbK3Hl47yiH2
         abaQOi9JN7MaUmqDgZuAQBstIOOrRipH5nE/xbDQcrp5JDEq7Ff4ns9zO1H+S2xfn8
         xxbTBoAEQY1HzNXi7NeW/lM1HGmxJ8w2aSzSuEgE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 041/158] media: coda: increment sequence offset for the last returned frame
Date:   Fri,  2 Aug 2019 11:27:42 +0200
Message-Id: <20190802092212.391913782@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092203.671944552@linuxfoundation.org>
References: <20190802092203.671944552@linuxfoundation.org>
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
index a7ed2dba7a0e..b19e70b83f4a 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -1967,6 +1967,9 @@ static void coda_finish_decode(struct coda_ctx *ctx)
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



