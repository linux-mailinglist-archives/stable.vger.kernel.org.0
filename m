Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6961BA9BE
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390391AbfIVTSw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 15:18:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:55944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436852AbfIVSzC (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:55:02 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16D7C208C2;
        Sun, 22 Sep 2019 18:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178501;
        bh=DM6CKKGHX4IgKpzSLPPrNa7vM4k4yCQtzVToryn8A5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ofPyH09IqC1+a8Bb5wyuAq7PgBtmvjjHFBWyNdbvhCH6KTH46cZPo1Ilhn4LfdcVs
         HL1KQEe50tFkfgnzGU9kF8cY2q3Ps0T99mAEV01Zd6kf/uKk6k0eE9KQOKhp7Q9L+1
         VBp3PS+UnN74qM/MWicD7wD7bqLZ3QDGeC/PNF5Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 034/128] media: media/platform: fsl-viu.c: fix build for MICROBLAZE
Date:   Sun, 22 Sep 2019 14:52:44 -0400
Message-Id: <20190922185418.2158-34-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922185418.2158-1-sashal@kernel.org>
References: <20190922185418.2158-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 6898dd580a045341f844862ceb775144156ec1af ]

arch/microblaze/ defines out_be32() and in_be32(), so don't do that
again in the driver source.

Fixes these build warnings:

../drivers/media/platform/fsl-viu.c:36: warning: "out_be32" redefined
../arch/microblaze/include/asm/io.h:50: note: this is the location of the previous definition
../drivers/media/platform/fsl-viu.c:37: warning: "in_be32" redefined
../arch/microblaze/include/asm/io.h:53: note: this is the location of the previous definition

Fixes: 29d750686331 ("media: fsl-viu: allow building it with COMPILE_TEST")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/fsl-viu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/fsl-viu.c b/drivers/media/platform/fsl-viu.c
index 0273302aa7412..83086eea14500 100644
--- a/drivers/media/platform/fsl-viu.c
+++ b/drivers/media/platform/fsl-viu.c
@@ -37,7 +37,7 @@
 #define VIU_VERSION		"0.5.1"
 
 /* Allow building this driver with COMPILE_TEST */
-#ifndef CONFIG_PPC
+#if !defined(CONFIG_PPC) && !defined(CONFIG_MICROBLAZE)
 #define out_be32(v, a)	iowrite32be(a, (void __iomem *)v)
 #define in_be32(a)	ioread32be((void __iomem *)a)
 #endif
-- 
2.20.1

