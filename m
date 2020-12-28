Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3412E67EB
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:30:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633682AbgL1Qah (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:30:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:34254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729637AbgL1NGc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:06:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3228207C9;
        Mon, 28 Dec 2020 13:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160751;
        bh=UAFTBRjOWayQArKHk2ibWenA7R1IHmPQWIiHUJtUm0M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GJwjK+Olzo8cvEng+RE3MSYMwq3LJROE0oU9MlkzSTpEiLiBqU8+BAdtrpBe/amnk
         sk+RjojDW25m61kqHPapH7C1nQZSELZClxIal3nhWQOwmWZvNh341fcMQqfygXcrBY
         wkoBOC/AKdFcvH9qUGY+zufkaAT0gS1xqogHK3vw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 118/175] powerpc/ps3: use dma_mapping_error()
Date:   Mon, 28 Dec 2020 13:49:31 +0100
Message-Id: <20201228124858.973482136@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124853.216621466@linuxfoundation.org>
References: <20201228124853.216621466@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Stehlé <vincent.stehle@laposte.net>

[ Upstream commit d0edaa28a1f7830997131cbce87b6c52472825d1 ]

The DMA address returned by dma_map_single() should be checked with
dma_mapping_error(). Fix the ps3stor_setup() function accordingly.

Fixes: 80071802cb9c ("[POWERPC] PS3: Storage Driver Core")
Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20201213182622.23047-1-vincent.stehle@laposte.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ps3/ps3stor_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ps3/ps3stor_lib.c b/drivers/ps3/ps3stor_lib.c
index 8c3f5adf1bc65..2d76183756626 100644
--- a/drivers/ps3/ps3stor_lib.c
+++ b/drivers/ps3/ps3stor_lib.c
@@ -201,7 +201,7 @@ int ps3stor_setup(struct ps3_storage_device *dev, irq_handler_t handler)
 	dev->bounce_lpar = ps3_mm_phys_to_lpar(__pa(dev->bounce_buf));
 	dev->bounce_dma = dma_map_single(&dev->sbd.core, dev->bounce_buf,
 					 dev->bounce_size, DMA_BIDIRECTIONAL);
-	if (!dev->bounce_dma) {
+	if (dma_mapping_error(&dev->sbd.core, dev->bounce_dma)) {
 		dev_err(&dev->sbd.core, "%s:%u: map DMA region failed\n",
 			__func__, __LINE__);
 		error = -ENODEV;
-- 
2.27.0



