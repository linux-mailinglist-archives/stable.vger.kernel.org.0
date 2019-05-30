Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEF962F1BF
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727261AbfE3EPb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:15:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:40912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729553AbfE3DQA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:16:00 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E32DD2458C;
        Thu, 30 May 2019 03:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186160;
        bh=TYEXwey+GGV3MRpFcJH6spduaDj96IktnHJR5rZj4G4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=if9KBDSrcK+ls0goEu1qhQkXf9Y6Hr4dwLqLCymN6DkjsyPMkSTIPvLL4k041jQwb
         iEhXG0zyLIu7jAza67vEob+maOklWxIOJ2/XEFxEt78wPmBXqhnVT0wlazlFzTIV1J
         ajF4kq+MNb+dCQ9hDa6rLZD+fx1PM7r9ejB32lzg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jernej Skrabec <jernej.skrabec@siol.net>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 310/346] media: cedrus: Add a quirk for not setting DMA offset
Date:   Wed, 29 May 2019 20:06:23 -0700
Message-Id: <20190530030556.534980417@linuxfoundation.org>
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

[ Upstream commit 70a4f5cda82f7197c350099b66fd23506620810e ]

H6 VPU doesn't work if DMA offset is set.

Add a quirk for it.

Signed-off-by: Jernej Skrabec <jernej.skrabec@siol.net>
Acked-by: Maxime Ripard <maxime.ripard@bootlin.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/sunxi/cedrus/cedrus.h    | 3 +++
 drivers/staging/media/sunxi/cedrus/cedrus_hw.c | 3 ++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/sunxi/cedrus/cedrus.h b/drivers/staging/media/sunxi/cedrus/cedrus.h
index 3acfdcf836912..726bef649ba6e 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus.h
+++ b/drivers/staging/media/sunxi/cedrus/cedrus.h
@@ -28,6 +28,8 @@
 
 #define CEDRUS_CAPABILITY_UNTILED	BIT(0)
 
+#define CEDRUS_QUIRK_NO_DMA_OFFSET	BIT(0)
+
 enum cedrus_codec {
 	CEDRUS_CODEC_MPEG2,
 
@@ -91,6 +93,7 @@ struct cedrus_dec_ops {
 
 struct cedrus_variant {
 	unsigned int	capabilities;
+	unsigned int	quirks;
 };
 
 struct cedrus_dev {
diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_hw.c b/drivers/staging/media/sunxi/cedrus/cedrus_hw.c
index 300339fee1bc6..24a06a1260f0a 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus_hw.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_hw.c
@@ -177,7 +177,8 @@ int cedrus_hw_probe(struct cedrus_dev *dev)
 	 */
 
 #ifdef PHYS_PFN_OFFSET
-	dev->dev->dma_pfn_offset = PHYS_PFN_OFFSET;
+	if (!(variant->quirks & CEDRUS_QUIRK_NO_DMA_OFFSET))
+		dev->dev->dma_pfn_offset = PHYS_PFN_OFFSET;
 #endif
 
 	ret = of_reserved_mem_device_init(dev->dev);
-- 
2.20.1



