Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C684F450E76
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:12:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240240AbhKOSPa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:15:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:48394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237872AbhKOSHk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:07:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CFF27633A4;
        Mon, 15 Nov 2021 17:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998317;
        bh=hez5oQVPSFGPapGDxet0O58mPzjLjxoOuyDKA05VivY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tu6OxPrg05+QqVGb9iNK0dHH2zL53V5L73sHLQ7yRFV9gHACOHQVKwnqOtW0rSLVt
         mBG3JGHx+XT0Im7qmpSX/YR1Mm3N5klOZjnm0W9WTBHnc1+utunJKyz/EdRrSzGmIw
         PM6a0IjEpHuAxRXYXw9Lq8bIiN2na1KQGqzomTSE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 433/575] staging: ks7010: select CRYPTO_HASH/CRYPTO_MICHAEL_MIC
Date:   Mon, 15 Nov 2021 18:02:38 +0100
Message-Id: <20211115165358.753813293@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vegard Nossum <vegard.nossum@oracle.com>

[ Upstream commit 9ca0e55e52c7b2a99f3c2051fc4bd1c63a061519 ]

Fix the following build/link errors:

  ld: drivers/staging/ks7010/ks_hostif.o: in function `michael_mic.constprop.0':
  ks_hostif.c:(.text+0x95b): undefined reference to `crypto_alloc_shash'
  ld: ks_hostif.c:(.text+0x97a): undefined reference to `crypto_shash_setkey'
  ld: ks_hostif.c:(.text+0xa13): undefined reference to `crypto_shash_update'
  ld: ks_hostif.c:(.text+0xa28): undefined reference to `crypto_shash_update'
  ld: ks_hostif.c:(.text+0xa48): undefined reference to `crypto_shash_finup'
  ld: ks_hostif.c:(.text+0xa6d): undefined reference to `crypto_destroy_tfm'

Fixes: 8b523f20417d ("staging: ks7010: removed custom Michael MIC implementation.")
Fixes: 3e5bc68fa5968 ("staging: ks7010: Fix build error")
Fixes: a4961427e7494 ("Revert "staging: ks7010: Fix build error"")
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
Link: https://lore.kernel.org/r/20211011152941.12847-1-vegard.nossum@oracle.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/ks7010/Kconfig | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/ks7010/Kconfig b/drivers/staging/ks7010/Kconfig
index 0987fdc2f70db..8ea6c09286798 100644
--- a/drivers/staging/ks7010/Kconfig
+++ b/drivers/staging/ks7010/Kconfig
@@ -5,6 +5,9 @@ config KS7010
 	select WIRELESS_EXT
 	select WEXT_PRIV
 	select FW_LOADER
+	select CRYPTO
+	select CRYPTO_HASH
+	select CRYPTO_MICHAEL_MIC
 	help
 	  This is a driver for KeyStream KS7010 based SDIO WIFI cards. It is
 	  found on at least later Spectec SDW-821 (FCC-ID "S2Y-WLAN-11G-K" only,
-- 
2.33.0



