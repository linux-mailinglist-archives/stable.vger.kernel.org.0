Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B573417509
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346690AbhIXNOR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:14:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:39694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346529AbhIXNL0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 09:11:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6FA00615E0;
        Fri, 24 Sep 2021 12:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632488314;
        bh=P9bRC8f1tsf6jsKr1tI1yd/K3m0zoT+8nwCUf2kETI8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ew4bji1sRc1cikiMfQY7pJMkE/7+5BMR82SdVogwdwKzrRbOGaNkYnJohAuiCGBff
         F+19YGyjnUv5wWk7jhrWPKfw0TTFWjfLpOwRdktGwhiE5MYySusV2iuXf+l8zfSBg2
         vT0lIWe8J9wUOvZnwWPNI+Lu8tMbGTdfJn+HLBPg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 37/63] dma-buf: DMABUF_MOVE_NOTIFY should depend on DMA_SHARED_BUFFER
Date:   Fri, 24 Sep 2021 14:44:37 +0200
Message-Id: <20210924124335.550394825@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124334.228235870@linuxfoundation.org>
References: <20210924124334.228235870@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

[ Upstream commit c4f3a3460a5daebc772d9263500e4099b11e7300 ]

Move notify between drivers is an option of DMA-BUF.  Enabling
DMABUF_MOVE_NOTIFY without DMA_SHARED_BUFFER does not have any impact,
as drivers/dma-buf/ is not entered during the build when
DMA_SHARED_BUFFER is disabled.

Fixes: bb42df4662a44765 ("dma-buf: add dynamic DMA-buf handling v15")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20210902124913.2698760-2-geert@linux-m68k.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma-buf/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma-buf/Kconfig b/drivers/dma-buf/Kconfig
index 4f8224a6ac95..3ca7de37dd8f 100644
--- a/drivers/dma-buf/Kconfig
+++ b/drivers/dma-buf/Kconfig
@@ -42,6 +42,7 @@ config UDMABUF
 config DMABUF_MOVE_NOTIFY
 	bool "Move notify between drivers (EXPERIMENTAL)"
 	default n
+	depends on DMA_SHARED_BUFFER
 	help
 	  Don't pin buffers if the dynamic DMA-buf interface is available on
 	  both the exporter as well as the importer. This fixes a security
-- 
2.33.0



