Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1721C450FEC
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:36:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237801AbhKOShm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:37:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:42082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242349AbhKOSfM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:35:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC1BF632DA;
        Mon, 15 Nov 2021 18:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999302;
        bh=5TaTadUUlRIm99JBWT3Hg8pPrx4O+pzJ82CGst/LFJc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g8D+4BegRGzH5LddK1uj5TrnXD43rq68NFKD7ErSSHQgPv6Gdb0adHbCCV3LPCeB+
         wfVyD4VUFI6Z+jPJQaEjti25BewfOexh/hKS8+2hdKhw62QXEm2m6E2XZ8SoQUGzN4
         Ehkjygnu5fL84nqAuHF+IjPEycevv7SHxMtY4iCg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aleksander Jan Bajkowski <olek2@wp.pl>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 214/849] MIPS: lantiq: dma: add small delay after reset
Date:   Mon, 15 Nov 2021 17:54:57 +0100
Message-Id: <20211115165427.451655199@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aleksander Jan Bajkowski <olek2@wp.pl>

[ Upstream commit c12aa581f6d5e80c3c3675ab26a52c2b3b62f76e ]

Reading the DMA registers immediately after the reset causes
Data Bus Error. Adding a small delay fixes this issue.

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/lantiq/xway/dma.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/mips/lantiq/xway/dma.c b/arch/mips/lantiq/xway/dma.c
index 63dccb2ed08b2..2784715933d13 100644
--- a/arch/mips/lantiq/xway/dma.c
+++ b/arch/mips/lantiq/xway/dma.c
@@ -11,6 +11,7 @@
 #include <linux/export.h>
 #include <linux/spinlock.h>
 #include <linux/clk.h>
+#include <linux/delay.h>
 #include <linux/err.h>
 #include <linux/of.h>
 
@@ -222,6 +223,8 @@ ltq_dma_init(struct platform_device *pdev)
 	clk_enable(clk);
 	ltq_dma_w32_mask(0, DMA_RESET, LTQ_DMA_CTRL);
 
+	usleep_range(1, 10);
+
 	/* disable all interrupts */
 	ltq_dma_w32(0, LTQ_DMA_IRNEN);
 
-- 
2.33.0



