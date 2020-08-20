Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26E3624ABED
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 02:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728073AbgHTAO2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 20:14:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:57470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726835AbgHTABX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Aug 2020 20:01:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 704A320FC3;
        Thu, 20 Aug 2020 00:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597881683;
        bh=XKiBK1pvhNbm8ah/eTtSInepqCDR2PVbsXnfd+G6pDA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XAyeh0ELGZUGhi+FLstXy2E4e5kGH6PEYGmOzb9zXupOXffwKMQ/Z3QrxV3qVuoeV
         aCY4azBhVUSIHvlV4rg2xtcdLM1twzXSEUghfv+glMudL2ogYtUWUcQfExOxKR0qe9
         D5JBJuwigirqjIKXZhyupqfeRyTnu5gnNaGMZ2V4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chen Zhou <chenzhou10@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 04/27] media: coda: jpeg: add NULL check after kmalloc
Date:   Wed, 19 Aug 2020 20:00:53 -0400
Message-Id: <20200820000116.214821-4-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200820000116.214821-1-sashal@kernel.org>
References: <20200820000116.214821-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

