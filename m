Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65B6C304AA8
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 21:52:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725828AbhAZFAl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 00:00:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:38344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726440AbhAYSvF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:51:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3AA3820679;
        Mon, 25 Jan 2021 18:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600624;
        bh=fuZVrm3xwsK1zeULItyFEkIFrNYiS8oJi4OUrjGLd/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MU6Gf+u2dMdmMerVCzcDJO2vf4n2x6O1ui8DD7WUAcyHd5Iuh/S9MN2biWWRDjKRl
         symrXxxRQOhYfkoUJfL/JNLK+bvWafF9Qcjb8rvE7j+QHg+qyOXXoiwaJ4HIhgWugW
         dDQF3U6QO/Jm9Kw1aa/zNKTjZOYOxuGiLHvJlF4M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 086/199] crypto: omap-sham - Fix link error without crypto-engine
Date:   Mon, 25 Jan 2021 19:38:28 +0100
Message-Id: <20210125183219.900263500@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 382811940303f7cd01d0f3dcdf432dfd89c5a98e ]

The driver was converted to use the crypto engine helper
but is missing the corresponding Kconfig statement to ensure
it is available:

arm-linux-gnueabi-ld: drivers/crypto/omap-sham.o: in function `omap_sham_probe':
omap-sham.c:(.text+0x374): undefined reference to `crypto_engine_alloc_init'
arm-linux-gnueabi-ld: omap-sham.c:(.text+0x384): undefined reference to `crypto_engine_start'
arm-linux-gnueabi-ld: omap-sham.c:(.text+0x510): undefined reference to `crypto_engine_exit'
arm-linux-gnueabi-ld: drivers/crypto/omap-sham.o: in function `omap_sham_finish_req':
omap-sham.c:(.text+0x98c): undefined reference to `crypto_finalize_hash_request'
arm-linux-gnueabi-ld: omap-sham.c:(.text+0x9a0): undefined reference to `crypto_transfer_hash_request_to_engine'
arm-linux-gnueabi-ld: drivers/crypto/omap-sham.o: in function `omap_sham_update':
omap-sham.c:(.text+0xf24): undefined reference to `crypto_transfer_hash_request_to_engine'
arm-linux-gnueabi-ld: drivers/crypto/omap-sham.o: in function `omap_sham_final':
omap-sham.c:(.text+0x1020): undefined reference to `crypto_transfer_hash_request_to_engine'

Fixes: 133c3d434d91 ("crypto: omap-sham - convert to use crypto engine")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 9d6645b1f0abe..ff5e85eefbf69 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -366,6 +366,7 @@ if CRYPTO_DEV_OMAP
 config CRYPTO_DEV_OMAP_SHAM
 	tristate "Support for OMAP MD5/SHA1/SHA2 hw accelerator"
 	depends on ARCH_OMAP2PLUS
+	select CRYPTO_ENGINE
 	select CRYPTO_SHA1
 	select CRYPTO_MD5
 	select CRYPTO_SHA256
-- 
2.27.0



