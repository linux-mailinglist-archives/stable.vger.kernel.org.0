Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84FF7450AB9
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:11:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236762AbhKOROP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:14:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:43424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236758AbhKORMd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:12:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9561961B73;
        Mon, 15 Nov 2021 17:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996178;
        bh=1LNNbp0bQpyy90ymqT4QRLi+zEFF/d1ZjvZ8jE+GpmM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S3XYa4NPcNL55OaILwPZ7rwT9bd7rPMQsX6NKDvN0XC3XIFoIqWMuh1nHS/d6wmGe
         HfQj2CZ9W6gyqjhk1PANrpG22H5Z/w1FhD3BJtexyiDM/z26Oc60jtQ3iMoo7cm6gC
         HDf7Gv6jQo81IXGDR3ZLteI/qSObBsgR13txRMuU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Pierre Ossman <pierre@ossman.eu>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 045/355] mmc: winbond: dont build on M68K
Date:   Mon, 15 Nov 2021 17:59:29 +0100
Message-Id: <20211115165315.006074946@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 162079f2dccd02cb4b6654defd32ca387dd6d4d4 ]

The Winbond MMC driver fails to build on ARCH=m68k so prevent
that build config. Silences these build errors:

../drivers/mmc/host/wbsd.c: In function 'wbsd_request_end':
../drivers/mmc/host/wbsd.c:212:28: error: implicit declaration of function 'claim_dma_lock' [-Werror=implicit-function-declaration]
  212 |                 dmaflags = claim_dma_lock();
../drivers/mmc/host/wbsd.c:215:17: error: implicit declaration of function 'release_dma_lock'; did you mean 'release_task'? [-Werror=implicit-function-declaration]
  215 |                 release_dma_lock(dmaflags);

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Pierre Ossman <pierre@ossman.eu>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20211017175949.23838-1-rdunlap@infradead.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index 49ea02c467bf1..1b4a40d910cfb 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -449,7 +449,7 @@ config MMC_OMAP_HS
 
 config MMC_WBSD
 	tristate "Winbond W83L51xD SD/MMC Card Interface support"
-	depends on ISA_DMA_API
+	depends on ISA_DMA_API && !M68K
 	help
 	  This selects the Winbond(R) W83L51xD Secure digital and
 	  Multimedia card Interface.
-- 
2.33.0



