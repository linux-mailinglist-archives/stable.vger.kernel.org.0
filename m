Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65E7924F435
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 10:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727792AbgHXIdw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:33:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:41762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727098AbgHXIdv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:33:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CC872074D;
        Mon, 24 Aug 2020 08:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258031;
        bh=XKiBK1pvhNbm8ah/eTtSInepqCDR2PVbsXnfd+G6pDA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QIhwzKfuPDgdqPO2mgDiWJSoCtBvbVLGzTcyHyTFb4Idz3FBRsxCoEiY7K3C6l6Oj
         fm7mmZStjwTLceJkxrf9gLhHLRdaXp+G98AF7HMMKMjI0CAw03qGUXrlTE1tnEusxa
         U+TUTWd5cKAUbBUsIXo9poVaBqSadBz/TmJ7hV+o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen Zhou <chenzhou10@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 048/148] media: coda: jpeg: add NULL check after kmalloc
Date:   Mon, 24 Aug 2020 10:29:06 +0200
Message-Id: <20200824082416.372417740@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082413.900489417@linuxfoundation.org>
References: <20200824082413.900489417@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen Zhou <chenzhou10@huawei.com>

[ Upstream commit 20171723144ca0d057b72e852536992fd371369a ]

Fixes coccicheck warning:

./drivers/media/platform/coda/coda-jpeg.c:331:3-31:
	alloc with no test, possible model on line 354

Add NULL check after kmalloc.

Signed-off-by: Chen Zhou <chenzhou10@huawei.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/coda/coda-jpeg.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda/coda-jpeg.c b/drivers/media/platform/coda/coda-jpeg.c
index 00d19859db500..b11cfbe166dd3 100644
--- a/drivers/media/platform/coda/coda-jpeg.c
+++ b/drivers/media/platform/coda/coda-jpeg.c
@@ -327,8 +327,11 @@ int coda_jpeg_decode_header(struct coda_ctx *ctx, struct vb2_buffer *vb)
 				 "only 8-bit quantization tables supported\n");
 			continue;
 		}
-		if (!ctx->params.jpeg_qmat_tab[i])
+		if (!ctx->params.jpeg_qmat_tab[i]) {
 			ctx->params.jpeg_qmat_tab[i] = kmalloc(64, GFP_KERNEL);
+			if (!ctx->params.jpeg_qmat_tab[i])
+				return -ENOMEM;
+		}
 		memcpy(ctx->params.jpeg_qmat_tab[i],
 		       quantization_tables[i].start, 64);
 	}
-- 
2.25.1



