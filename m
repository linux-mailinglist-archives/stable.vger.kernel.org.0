Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CBB0CAAD8
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389131AbfJCQQ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:16:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:42356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387779AbfJCQQ6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:16:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5EC1B20865;
        Thu,  3 Oct 2019 16:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119417;
        bh=DM6CKKGHX4IgKpzSLPPrNa7vM4k4yCQtzVToryn8A5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IptwCjO6Qcst30Pq22wK9R6Fhk81zY2yTOgULJ7RdR+qlzqMCVWuIbhkBO49BTAEk
         3QGukHvt6gotAGR01sNoQ3djBBlApLPuSr2fxUJIn8KBQYU8TP/ccLVeAv3+ehuerJ
         r7h1d4FyZPR/TzJV9OOicJdnUBfkL71alOWD0ncw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 057/211] media: media/platform: fsl-viu.c: fix build for MICROBLAZE
Date:   Thu,  3 Oct 2019 17:52:03 +0200
Message-Id: <20191003154501.340506559@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154447.010950442@linuxfoundation.org>
References: <20191003154447.010950442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



