Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE2792EBF2
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730918AbfE3DRH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:17:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:45024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730915AbfE3DRG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:17:06 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83BB424667;
        Thu, 30 May 2019 03:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186225;
        bh=IszB0OOQeLjmgoIzz1bL/59sa6EgoYvgOFPYwjoubSg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Iq95Njrullp0gRFwafxRL+cuQRoK8jlytBpueQiw9cn4Ijn2+kLTlLOsQbqo+l8th
         Jc+ouKU/MMsJvrjAkPxBeiHMiHcLow8qDhLNxnvaOZuzWBUlomxb2WN9XUIEskH6Yp
         sCEQr9bNJ/S5GYucPzUkCuUL0/tjkdzH57sXpAzY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 121/276] media: coda: clear error return value before picture run
Date:   Wed, 29 May 2019 20:04:39 -0700
Message-Id: <20190530030533.435208596@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030523.133519668@linuxfoundation.org>
References: <20190530030523.133519668@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit bbeefa7357a648afe70e7183914c87c3878d528d ]

The error return value is not written by some firmware codecs, such as
MPEG-2 decode on CodaHx4. Clear the error return value before starting
the picture run to avoid misinterpreting unrelated values returned by
sequence initialization as error return value.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/coda/coda-bit.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index d20d3df5778bc..a3cfefdbee127 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -1999,6 +1999,9 @@ static int coda_prepare_decode(struct coda_ctx *ctx)
 	/* Clear decode success flag */
 	coda_write(dev, 0, CODA_RET_DEC_PIC_SUCCESS);
 
+	/* Clear error return value */
+	coda_write(dev, 0, CODA_RET_DEC_PIC_ERR_MB);
+
 	trace_coda_dec_pic_run(ctx, meta);
 
 	coda_command_async(ctx, CODA_COMMAND_PIC_RUN);
-- 
2.20.1



