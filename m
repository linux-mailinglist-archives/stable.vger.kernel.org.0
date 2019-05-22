Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E811926C69
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 21:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730451AbfEVTeo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 15:34:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:54834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731761AbfEVTbV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 15:31:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7116120879;
        Wed, 22 May 2019 19:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553481;
        bh=sWItnj+hTefFXAPdAyenA+me0RtZsmF2pBQmxx3wXk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BtJ61EpNl+Va3Nh48oovHFSs6U+DADWDAYZxjqwLssAafxqk/fVv/be+K+iRyW/8Q
         FhX1RIulu9P87ukU7CV2xDedg4//sApO264kvSiQP2gNbbERBOQg9/juaXIpiTFU1C
         xoit/oiXfRCISfVg0gHh9DRc3U63hqGACvclTwi8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 040/114] media: coda: clear error return value before picture run
Date:   Wed, 22 May 2019 15:29:03 -0400
Message-Id: <20190522193017.26567-40-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522193017.26567-1-sashal@kernel.org>
References: <20190522193017.26567-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Philipp Zabel <p.zabel@pengutronix.de>

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

