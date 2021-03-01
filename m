Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 110A9328E09
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:24:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241440AbhCATWu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:22:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:43776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241328AbhCATRl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:17:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B51E65222;
        Mon,  1 Mar 2021 17:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619441;
        bh=tG5n0v8kSpXoRba8KdZn1CKcy/6jB4QU66qD7/qMDGQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jGa8qtMyxGM69pLQ8ljqWulISi5jyzh91DgtEwMw241gXNShuw9HbD3Th+l5S+zLO
         rqYsiQ/INyeIrAFl87ucSeUMMEClD9Jrli5R95stlRIknLejcAc0HQj7n9YR4fZPtr
         yX17KxAgtaM1LDX6BPUXLlWqYOhI2TblkbMgp3+Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 454/663] wireguard: kconfig: use arm chacha even with no neon
Date:   Mon,  1 Mar 2021 17:11:42 +0100
Message-Id: <20210301161204.353584836@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason A. Donenfeld <Jason@zx2c4.com>

[ Upstream commit bce2473927af8de12ad131a743f55d69d358c0b9 ]

The condition here was incorrect: a non-neon fallback implementation is
available on arm32 when NEON is not supported.

Reported-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index c3dbe64e628ea..13e0a8caf3b6f 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -87,7 +87,7 @@ config WIREGUARD
 	select CRYPTO_CURVE25519_X86 if X86 && 64BIT
 	select ARM_CRYPTO if ARM
 	select ARM64_CRYPTO if ARM64
-	select CRYPTO_CHACHA20_NEON if (ARM || ARM64) && KERNEL_MODE_NEON
+	select CRYPTO_CHACHA20_NEON if ARM || (ARM64 && KERNEL_MODE_NEON)
 	select CRYPTO_POLY1305_NEON if ARM64 && KERNEL_MODE_NEON
 	select CRYPTO_POLY1305_ARM if ARM
 	select CRYPTO_CURVE25519_NEON if ARM && KERNEL_MODE_NEON
-- 
2.27.0



