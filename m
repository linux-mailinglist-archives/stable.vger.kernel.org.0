Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 781E934C99E
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232313AbhC2Ia2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:30:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:47460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231653AbhC2I3E (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:29:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92942614A7;
        Mon, 29 Mar 2021 08:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006544;
        bh=zAtzDfQAXaeOAB0+XE+qy9KzeC4/LjIy8j9dzfmTH9g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oQX8y3n7Z43JC/rGUan2EIaB2akm72Q0FjxMAyY9+qV47H6GaSnbd4r4C4q0ddna9
         Ypwg/4A8AS68wb07PddhjIkf2baXM1Gs/Be291GyEcVH7hDyUpkaK1Y7fIJUT+PUVl
         o89JFzxeP/xgux6KeKA5jRgGHTEi7pfbVfiduAmk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Julian Braha <julianbraha@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 037/254] staging: rtl8192e: fix kconfig dependency on CRYPTO
Date:   Mon, 29 Mar 2021 09:55:53 +0200
Message-Id: <20210329075634.368710522@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



