Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9BED1018CB
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:11:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728499AbfKSFaO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:30:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:48940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728011AbfKSFaO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:30:14 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 692FC21939;
        Tue, 19 Nov 2019 05:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141412;
        bh=Ze+zPj9F92/cxye0P++w2Oo8cvHRn+ZLD1meN+16LYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CAUiBhfxehrX3EHHzBOmWMPYQ9DEx5P30JY5yP/1pk4biIwCeqVdi9nfcLuVRU9nA
         4YIYyEOEAIKqvFygkP7fN4mMkOofMjPlVmmqcGEk1eTPBeF2xhUVsMp0BGDGxu81yY
         MO5uoLLnmdlTKNucf85hqb1HvbvPY+B5IfBk0WuM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 153/422] dmaengine: dma-jz4780: Dont depend on MACH_JZ4780
Date:   Tue, 19 Nov 2019 06:15:50 +0100
Message-Id: <20191119051408.513339279@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Cercueil <paul@crapouillou.net>

[ Upstream commit c558ecd21c852c97ff98dc6c61f715ba420ec251 ]

If we make this driver depend on MACH_JZ4780, that means it can be
enabled only if we're building a kernel specially crafted for a
JZ4780-based board, while most GNU/Linux distributions will want one
generic MIPS kernel that works on multiple boards.

Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index dacf3f42426de..a4f95574eb9ad 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -143,7 +143,7 @@ config DMA_JZ4740
 
 config DMA_JZ4780
 	tristate "JZ4780 DMA support"
-	depends on MACH_JZ4780 || COMPILE_TEST
+	depends on MIPS || COMPILE_TEST
 	select DMA_ENGINE
 	select DMA_VIRTUAL_CHANNELS
 	help
-- 
2.20.1



