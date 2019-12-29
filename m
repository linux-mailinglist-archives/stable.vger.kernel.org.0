Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94FFE12CA2F
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:20:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727480AbfL2RXI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:23:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:40326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727054AbfL2RXG (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:23:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2DCEB21744;
        Sun, 29 Dec 2019 17:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640185;
        bh=fvMLFG8yuBkK7nSBE8ksWzysVA3V9rPrBM/VglFIglE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0bYr43MBr61yMUM3+p4JP0gDdHj/4y4nJdgu5SuIWyypc8BMlJCd36gRoXViKz2zj
         9lHd5RmNOEQ6Rls+eBjRqvekykDEZ+FZH4plhLOXW6SmQ2aj59FeEhIMNwklPBkIOa
         L9wpmkH866adrJkViosZ+sg/n0n+uWmAHriFeJLI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Benoit Parrot <bparrot@ti.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 054/161] media: ti-vpe: vpe: fix a v4l2-compliance failure causing a kernel panic
Date:   Sun, 29 Dec 2019 18:18:22 +0100
Message-Id: <20191229162415.602142716@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162355.500086350@linuxfoundation.org>
References: <20191229162355.500086350@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benoit Parrot <bparrot@ti.com>

[ Upstream commit a37980ac5be29b83da67bf7d571c6bd9f90f8e45 ]

v4l2-compliance fails with this message:

   warn: v4l2-test-formats.cpp(717): \
   	TRY_FMT cannot handle an invalid pixelformat.
   test VIDIOC_TRY_FMT: FAIL

This causes the following kernel panic:

Unable to handle kernel paging request at virtual address 56595561
pgd = ecd80e00
*pgd=00000000
Internal error: Oops: 205 [#1] PREEMPT SMP ARM
...
CPU: 0 PID: 930 Comm: v4l2-compliance Not tainted \
	4.14.62-01715-gc8cd67f49a19 #1
Hardware name: Generic DRA72X (Flattened Device Tree)
task: ece44d80 task.stack: ecc6e000
PC is at __vpe_try_fmt+0x18c/0x2a8 [ti_vpe]
LR is at 0x8

Because the driver fails to properly check the 'num_planes' values for
proper ranges it ends up accessing out of bound data causing the kernel
panic.

Since this driver only handle single or dual plane pixel format, make
sure the provided value does not exceed 2 planes.

Signed-off-by: Benoit Parrot <bparrot@ti.com>
Reviewed-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/ti-vpe/vpe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index a136fb14bf1a..5adafee98e4c 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -1663,7 +1663,7 @@ static int __vpe_try_fmt(struct vpe_ctx *ctx, struct v4l2_format *f,
 			      &pix->height, MIN_H, MAX_H, H_ALIGN,
 			      S_ALIGN);
 
-	if (!pix->num_planes)
+	if (!pix->num_planes || pix->num_planes > 2)
 		pix->num_planes = fmt->coplanar ? 2 : 1;
 	else if (pix->num_planes > 1 && !fmt->coplanar)
 		pix->num_planes = 1;
-- 
2.20.1



