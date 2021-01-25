Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C692302AE4
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 19:56:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731402AbhAYSz7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 13:55:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:41724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731388AbhAYSzl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:55:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF8EC20E65;
        Mon, 25 Jan 2021 18:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600901;
        bh=bWV1q/vlPePa8LOU1u+HIReIsNMq//s48XHaFX7Nheg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FndgaJLsnK651S/nuVFG04b6eVBiZ+8GMUDoz7s6YE+eQ2/DAXoKCKPXH1uP7GaDI
         jXCES85pQ2t+PDJXwCB0OuK6PqmWZ4oneBL0tDFz02lu/iPOw34f+T6yAw/GDxSUMP
         x6/IOH7sYbKyBXHma9e4Wc6Pduq2/kYyr278DNfQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Necip Fazil Yildiran <fazilyildiran@gmail.com>,
        Rich Felker <dalias@libc.org>
Subject: [PATCH 5.10 154/199] sh: dma: fix kconfig dependency for G2_DMA
Date:   Mon, 25 Jan 2021 19:39:36 +0100
Message-Id: <20210125183222.706885648@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Necip Fazil Yildiran <fazilyildiran@gmail.com>

commit f477a538c14d07f8c45e554c8c5208d588514e98 upstream.

When G2_DMA is enabled and SH_DMA is disabled, it results in the following
Kbuild warning:

WARNING: unmet direct dependencies detected for SH_DMA_API
  Depends on [n]: SH_DMA [=n]
  Selected by [y]:
  - G2_DMA [=y] && SH_DREAMCAST [=y]

The reason is that G2_DMA selects SH_DMA_API without depending on or
selecting SH_DMA while SH_DMA_API depends on SH_DMA.

When G2_DMA was first introduced with commit 40f49e7ed77f
("sh: dma: Make G2 DMA configurable."), this wasn't an issue since
SH_DMA_API didn't have such dependency, and this way was the only way to
enable it since SH_DMA_API was non-visible. However, later SH_DMA_API was
made visible and dependent on SH_DMA with commit d8902adcc1a9
("dmaengine: sh: Add Support SuperH DMA Engine driver").

Let G2_DMA depend on SH_DMA_API instead to avoid Kbuild issues.

Fixes: d8902adcc1a9 ("dmaengine: sh: Add Support SuperH DMA Engine driver")
Signed-off-by: Necip Fazil Yildiran <fazilyildiran@gmail.com>
Signed-off-by: Rich Felker <dalias@libc.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/sh/drivers/dma/Kconfig |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/sh/drivers/dma/Kconfig
+++ b/arch/sh/drivers/dma/Kconfig
@@ -63,8 +63,7 @@ config PVR2_DMA
 
 config G2_DMA
 	tristate "G2 Bus DMA support"
-	depends on SH_DREAMCAST
-	select SH_DMA_API
+	depends on SH_DREAMCAST && SH_DMA_API
 	help
 	  This enables support for the DMA controller for the Dreamcast's
 	  G2 bus. Drivers that want this will generally enable this on


