Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C48AC15F253
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:09:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731446AbgBNPyO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:54:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:33992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731435AbgBNPyL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:54:11 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FE8024685;
        Fri, 14 Feb 2020 15:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695650;
        bh=jVYpPF/XTTCfs3ewKAAQahe25GceYAwTatt+NUdKAOw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hGm368M/BR+nWloL+ZuV+RjwzKCXMgsKiw57ZoEalCZyuZOl3cN2h0uqJEikT4lDu
         jrUMUmxDp+E8T7U8J2Nzqnocz2viSRa+TQxBuXyY42eY0XmPSFcasdk/tOlRZ0IhO6
         x0f/UpYpfeoKgMQfj6Bk0XFzCe9dLSVJce9SUR4k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Brendan Higgins <brendanhiggins@google.com>,
        Corentin Labbe <clabbe@baylibre.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org,
        linux-amlogic@lists.infradead.org
Subject: [PATCH AUTOSEL 5.5 243/542] crypto: amlogic - add unspecified HAS_IOMEM dependency
Date:   Fri, 14 Feb 2020 10:43:55 -0500
Message-Id: <20200214154854.6746-243-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brendan Higgins <brendanhiggins@google.com>

[ Upstream commit 7d07de2c18abd95f72efb28f78a4825e0fc1aa6a ]

Currently CONFIG_CRYPTO_DEV_AMLOGIC_GXL=y implicitly depends on
CONFIG_HAS_IOMEM=y; consequently, on architectures without IOMEM we get
the following build error:

ld: drivers/crypto/amlogic/amlogic-gxl-core.o: in function `meson_crypto_probe':
drivers/crypto/amlogic/amlogic-gxl-core.c:240: undefined reference to `devm_platform_ioremap_resource'

Fix the build error by adding the unspecified dependency.

Reported-by: Brendan Higgins <brendanhiggins@google.com>
Signed-off-by: Brendan Higgins <brendanhiggins@google.com>
Acked-by: Corentin Labbe <clabbe@baylibre.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/amlogic/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/amlogic/Kconfig b/drivers/crypto/amlogic/Kconfig
index b90850d18965f..cf95476026708 100644
--- a/drivers/crypto/amlogic/Kconfig
+++ b/drivers/crypto/amlogic/Kconfig
@@ -1,5 +1,6 @@
 config CRYPTO_DEV_AMLOGIC_GXL
 	tristate "Support for amlogic cryptographic offloader"
+	depends on HAS_IOMEM
 	default y if ARCH_MESON
 	select CRYPTO_SKCIPHER
 	select CRYPTO_ENGINE
-- 
2.20.1

