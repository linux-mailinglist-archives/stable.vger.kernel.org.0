Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99E7D2EE36
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:45:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732356AbfE3DpX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:45:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:60102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732344AbfE3DUt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:20:49 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C34212497C;
        Thu, 30 May 2019 03:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186448;
        bh=ZCsxXdpu8EEZLeV/iQOFEU/H1o4X1Ff8AUSV1hp8S+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eCoj6KAhiPqhqat+bxIJiULZrKuL0Ua3SkO24/t6e5rIhuzOveA2T150eSQxAMrUe
         SayAgUOG0RRvXHYbInBHmdQC+l5kTcE78C+nVPB6kno4SzDfCVPkMNIwmEb/Cio4pM
         yxvm8AUOg9j5p/qcJIN+LycKV2x0PljnzCBEcMYs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 057/128] media: coda: clear error return value before picture run
Date:   Wed, 29 May 2019 20:06:29 -0700
Message-Id: <20190530030445.134089589@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030432.977908967@linuxfoundation.org>
References: <20190530030432.977908967@linuxfoundation.org>
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
index b6625047250d6..717ee9a6a80ef 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -1829,6 +1829,9 @@ static int coda_prepare_decode(struct coda_ctx *ctx)
 	/* Clear decode success flag */
 	coda_write(dev, 0, CODA_RET_DEC_PIC_SUCCESS);
 
+	/* Clear error return value */
+	coda_write(dev, 0, CODA_RET_DEC_PIC_ERR_MB);
+
 	trace_coda_dec_pic_run(ctx, meta);
 
 	coda_command_async(ctx, CODA_COMMAND_PIC_RUN);
-- 
2.20.1



