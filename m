Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD906DECA
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731254AbfGSEEs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:04:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:37056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729485AbfGSEEs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:04:48 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B94D7218B8;
        Fri, 19 Jul 2019 04:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509087;
        bh=8tBagpOAOpprCs4uYU53NVUBKsHIAknXM1XHCt4N8L0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ojeAN3frEeYJ78CwA+VewqJRBg8iEDSHciGcBU5N9eRfll/yFYawOfMoFpDya1BUG
         FbqVV9C6B84/jeQbhyjMCCzfd/VKIisWJBomqNHynNNWIGw+bwuygww2yZWkc6ZoZB
         Yph6MTkWBFJuprSXMOHy7pJh7jKDFhPqFW30JHNU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 5.1 061/141] staging: ks7010: Fix build error
Date:   Fri, 19 Jul 2019 00:01:26 -0400
Message-Id: <20190719040246.15945-61-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719040246.15945-1-sashal@kernel.org>
References: <20190719040246.15945-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 3e5bc68fa596874500e8c718605aa44d5e42a34c ]

when CRYPTO is m and KS7010 is y, building fails:

drivers/staging/ks7010/ks_hostif.o: In function `michael_mic.constprop.13':
ks_hostif.c:(.text+0x560): undefined reference to `crypto_alloc_shash'
ks_hostif.c:(.text+0x580): undefined reference to `crypto_shash_setkey'
ks_hostif.c:(.text+0x5e0): undefined reference to `crypto_destroy_tfm'
ks_hostif.c:(.text+0x614): undefined reference to `crypto_shash_update'
ks_hostif.c:(.text+0x62c): undefined reference to `crypto_shash_update'
ks_hostif.c:(.text+0x648): undefined reference to `crypto_shash_finup'

Add CRYPTO and CRYPTO_HASH dependencies to fix this.

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: 8b523f20417d ("staging: ks7010: removed custom Michael MIC implementation.")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/ks7010/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/ks7010/Kconfig b/drivers/staging/ks7010/Kconfig
index 0b9217674d5b..8a303ce114d8 100644
--- a/drivers/staging/ks7010/Kconfig
+++ b/drivers/staging/ks7010/Kconfig
@@ -4,6 +4,7 @@ config KS7010
 	select WIRELESS_EXT
 	select WEXT_PRIV
 	select FW_LOADER
+	depends on CRYPTO && CRYPTO_HASH
 	help
 	  This is a driver for KeyStream KS7010 based SDIO WIFI cards. It is
 	  found on at least later Spectec SDW-821 (FCC-ID "S2Y-WLAN-11G-K" only,
-- 
2.20.1

