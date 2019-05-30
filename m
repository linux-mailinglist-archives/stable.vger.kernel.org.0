Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE0FF2F36D
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729913AbfE3E3Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:29:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:33104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729713AbfE3DOG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:14:06 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 923AC24585;
        Thu, 30 May 2019 03:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186045;
        bh=bCSBNI+1S7B7dSnJsRoEDeMmOdKmudhE0T9x3Vhvr3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PipCvb6ihNsTr0H4MiKKeTXN/GBBrQyJvnVd69RTMJBqCTe/tkEdruSzuy6011tpE
         q7BkAKuH43UOTSVduAQf+DrJd9S9Ig3FRFS1hT/J6lYXSxu4VVgW55Rcj8tZmqpVxO
         GsL0EDfRbhVVL0lNQn5PS/Dr1ZO8sEirGfXMIl7A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 138/346] media: coda: clear error return value before picture run
Date:   Wed, 29 May 2019 20:03:31 -0700
Message-Id: <20190530030548.137886746@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
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
index 8e0194993a52e..b9fc589161108 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -2006,6 +2006,9 @@ static int coda_prepare_decode(struct coda_ctx *ctx)
 	/* Clear decode success flag */
 	coda_write(dev, 0, CODA_RET_DEC_PIC_SUCCESS);
 
+	/* Clear error return value */
+	coda_write(dev, 0, CODA_RET_DEC_PIC_ERR_MB);
+
 	trace_coda_dec_pic_run(ctx, meta);
 
 	coda_command_async(ctx, CODA_COMMAND_PIC_RUN);
-- 
2.20.1



