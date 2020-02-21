Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3F27167108
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 08:50:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728844AbgBUHum (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:50:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:47666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729400AbgBUHum (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:50:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 970A8208C4;
        Fri, 21 Feb 2020 07:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271441;
        bh=42j6HsxEV+mB9OekVp/npQB8mx27Un5zy3jqLhdFvWc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tykWB9ltnx5ycJ8QEstYmjrAnPidIZHOmR6uVu+oCJJcAkpXfn3mhBMfwmoZ91MZP
         VmGSZXwBb/EsF73tsD0sdWlaSNufXdiYH4RIkj3rKMyQu5Zyly28rKQmX1r8eUT5n9
         Ly4dkg7eWmG2I8lVYuNKnv4GdCfQHU+jH6UcVdG4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Brendan Higgins <brendanhiggins@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 168/399] crypto: inside-secure - add unspecified HAS_IOMEM dependency
Date:   Fri, 21 Feb 2020 08:38:13 +0100
Message-Id: <20200221072418.968722224@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brendan Higgins <brendanhiggins@google.com>

[ Upstream commit 6dc0e310623fdcb27a1486eb436f0118c45e95a5 ]

Currently CONFIG_CRYPTO_DEV_SAFEXCEL=y implicitly depends on
CONFIG_HAS_IOMEM=y; consequently, on architectures without IOMEM we get
the following build error:

ld: drivers/crypto/inside-secure/safexcel.o: in function `safexcel_probe':
drivers/crypto/inside-secure/safexcel.c:1692: undefined reference to `devm_platform_ioremap_resource'

Fix the build error by adding the unspecified dependency.

Reported-by: Brendan Higgins <brendanhiggins@google.com>
Signed-off-by: Brendan Higgins <brendanhiggins@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 91eb768d4221a..0a73bebd04e5d 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -716,7 +716,7 @@ source "drivers/crypto/stm32/Kconfig"
 
 config CRYPTO_DEV_SAFEXCEL
 	tristate "Inside Secure's SafeXcel cryptographic engine driver"
-	depends on OF || PCI || COMPILE_TEST
+	depends on (OF || PCI || COMPILE_TEST) && HAS_IOMEM
 	select CRYPTO_LIB_AES
 	select CRYPTO_AUTHENC
 	select CRYPTO_SKCIPHER
-- 
2.20.1



