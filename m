Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1E2931BCEE
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:38:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231432AbhBOPhl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:37:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:46646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230391AbhBOPfT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:35:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C55464E7F;
        Mon, 15 Feb 2021 15:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403107;
        bh=9E/WlQXpgKisqumLhGG5ioMPGEsn1P7Mk0vkeVOvBhE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dlllooDqMkSPh3gRJz4hpWMBobxtax4iXuuPhQkZT5Z0Vu7w7ZstS7uuYlHx9XTHv
         pBRRDSe1eyLyF5diiO3/ajiw5WB2VTDFekS4jmKG5+JQ2Z0SVI09iFWlr4M28UgKXj
         KeydIJ39j50LyBbaAjVZ83DU5VUpNv2n3D0EHaKQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 5.10 003/104] gpio: mxs: GPIO_MXS should not default to y unconditionally
Date:   Mon, 15 Feb 2021 16:26:16 +0100
Message-Id: <20210215152719.574207748@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152719.459796636@linuxfoundation.org>
References: <20210215152719.459796636@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit 97c6e28d388a5000d780d2a63c32f422827f5aa3 upstream.

Merely enabling CONFIG_COMPILE_TEST should not enable additional code.
To fix this, restrict the automatic enabling of GPIO_MXS to ARCH_MXS,
and ask the user in case of compile-testing.

Fixes: 6876ca311bfca5d7 ("gpio: mxs: add COMPILE_TEST support for GPIO_MXS")
Cc: <stable@vger.kernel.org>
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -428,8 +428,9 @@ config GPIO_MXC
 	select GENERIC_IRQ_CHIP
 
 config GPIO_MXS
-	def_bool y
+	bool "Freescale MXS GPIO support" if COMPILE_TEST
 	depends on ARCH_MXS || COMPILE_TEST
+	default y if ARCH_MXS
 	select GPIO_GENERIC
 	select GENERIC_IRQ_CHIP
 


