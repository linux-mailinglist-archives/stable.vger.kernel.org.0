Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD743411F36
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346731AbhITRi4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:38:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:43462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348468AbhITRga (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:36:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 829C96136F;
        Mon, 20 Sep 2021 17:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157592;
        bh=1vBuY/Mix2N6KkBaigQwQ3X+ulXE4j4QBpvGSMe505M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A8FktrAqBbfzXz3y2hfd1Arr21SIagfPiWvgyDOBgDJiMZJmE9rOolVmiJLg4aB/8
         Mjz/OejTAlYbJClROxrn6aBxDhxPUBd/Wp8fQQe1WIJeQdRyxss3M1fVDzfiONqvWK
         QMDfEiJhFfeuFKIzfHgK+ncPbCLVz/PlhEWRRpwA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chunyan Zhang <chunyan.zhang@unisoc.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 061/293] spi: sprd: Fix the wrong WDG_LOAD_VAL
Date:   Mon, 20 Sep 2021 18:40:23 +0200
Message-Id: <20210920163935.350748875@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chunyan Zhang <chunyan.zhang@unisoc.com>

[ Upstream commit 245ca2cc212bb2a078332ec99afbfbb202f44c2d ]

Use 50ms as default timeout value and the time clock is 32768HZ.
The original value of WDG_LOAD_VAL is not correct, so this patch
fixes it.

Fixes: ac1775012058 ("spi: sprd: Add the support of restarting the system")
Signed-off-by: Chunyan Zhang <chunyan.zhang@unisoc.com>
Link: https://lore.kernel.org/r/20210826091549.2138125-2-zhang.lyra@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-sprd-adi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-sprd-adi.c b/drivers/spi/spi-sprd-adi.c
index e41976010dc4..97f44458ee7b 100644
--- a/drivers/spi/spi-sprd-adi.c
+++ b/drivers/spi/spi-sprd-adi.c
@@ -99,7 +99,7 @@
 #define HWRST_STATUS_SPRDISK		0xc0
 
 /* Use default timeout 50 ms that converts to watchdog values */
-#define WDG_LOAD_VAL			((50 * 1000) / 32768)
+#define WDG_LOAD_VAL			((50 * 32768) / 1000)
 #define WDG_LOAD_MASK			GENMASK(15, 0)
 #define WDG_UNLOCK_KEY			0xe551
 
-- 
2.30.2



