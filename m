Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88F0E33E393
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 01:57:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbhCQA5I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 20:57:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:33386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229699AbhCQA4W (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 20:56:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5664A64FA5;
        Wed, 17 Mar 2021 00:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942581;
        bh=zAtzDfQAXaeOAB0+XE+qy9KzeC4/LjIy8j9dzfmTH9g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pSBAg+BpA5lMeHWF59kn3bYEY/XgfPhgxI4jvZfRPvAioN0wRa723hQFZRXrvHrrK
         +XDYuCV08z7C+Pea4Uy4V3+/++RsAe2ykQ8coZ+RxXIp+VsC2z3+JkPNZVGBkD4KzB
         WKvTSsINcOva0oKJ26EDVnv/il5/vhtLQ6vLvsLKgY65c1edhc+MIPz3QeyVEdTrZS
         DfeX7glj76fa/pmUu8DLIC6Hx0bSv2Frrcji8GsxWuEuWJkfXzx8BD1pAg887wRy9v
         eURtl8gchF+QCHhCEltUTpulVA9sGPRKL+TROL1eNnnzXkvjYKTMyJBkD1ipsmTynx
         VhPQgKu4jWkuQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Julian Braha <julianbraha@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 5.11 37/61] staging: rtl8192e: fix kconfig dependency on CRYPTO
Date:   Tue, 16 Mar 2021 20:55:11 -0400
Message-Id: <20210317005536.724046-37-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005536.724046-1-sashal@kernel.org>
References: <20210317005536.724046-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julian Braha <julianbraha@gmail.com>

[ Upstream commit 7c36194558cf49a86a53b5f60db8046c5e3013ae ]

When RTLLIB_CRYPTO_TKIP is enabled and CRYPTO is disabled,
Kbuild gives the following warning:

WARNING: unmet direct dependencies detected for CRYPTO_MICHAEL_MIC
  Depends on [n]: CRYPTO [=n]
  Selected by [m]:
  - RTLLIB_CRYPTO_TKIP [=m] && STAGING [=y] && RTLLIB [=m]

WARNING: unmet direct dependencies detected for CRYPTO_LIB_ARC4
  Depends on [n]: CRYPTO [=n]
  Selected by [m]:
  - RTLLIB_CRYPTO_TKIP [=m] && STAGING [=y] && RTLLIB [=m]
  - RTLLIB_CRYPTO_WEP [=m] && STAGING [=y] && RTLLIB [=m]

This is because RTLLIB_CRYPTO_TKIP selects CRYPTO_MICHAEL_MIC and
CRYPTO_LIB_ARC4, without depending on or selecting CRYPTO,
despite those config options being subordinate to CRYPTO.

Acked-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Julian Braha <julianbraha@gmail.com>
Link: https://lore.kernel.org/r/20210222180607.399753-1-julianbraha@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8192e/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/rtl8192e/Kconfig b/drivers/staging/rtl8192e/Kconfig
index 03fcc23516fd..6e7d84ac06f5 100644
--- a/drivers/staging/rtl8192e/Kconfig
+++ b/drivers/staging/rtl8192e/Kconfig
@@ -26,6 +26,7 @@ config RTLLIB_CRYPTO_CCMP
 config RTLLIB_CRYPTO_TKIP
 	tristate "Support for rtllib TKIP crypto"
 	depends on RTLLIB
+	select CRYPTO
 	select CRYPTO_LIB_ARC4
 	select CRYPTO_MICHAEL_MIC
 	default y
-- 
2.30.1

