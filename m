Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7E3F409401
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345777AbhIMO04 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:26:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:46956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346423AbhIMOY2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:24:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83DAE610F7;
        Mon, 13 Sep 2021 13:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540900;
        bh=G0zZKwnJTKyNsjBadEeQ+JAr9fyN0JUr2UF6VXJ677o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ur0dlqxytvTRyixLVDPioNH5nnMxSsnbb38yNIKT8kdTqt2toP833KxVW8pM0c8WI
         w29+t04TW8KF1+yeEZVUGNkaHRkEx1eSOXEl2SAxQ1gUuBkGC03/QPYnF0ICxePWsT
         jELOSQKJJyXVKPtLZdwSzGUnDk+CINdSCGgmj0uw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chunyan Zhang <chunyan.zhang@unisoc.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 080/334] spi: sprd: Fix the wrong WDG_LOAD_VAL
Date:   Mon, 13 Sep 2021 15:12:14 +0200
Message-Id: <20210913131116.102633675@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
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
index ab19068be867..98ef17389952 100644
--- a/drivers/spi/spi-sprd-adi.c
+++ b/drivers/spi/spi-sprd-adi.c
@@ -103,7 +103,7 @@
 #define HWRST_STATUS_WATCHDOG		0xf0
 
 /* Use default timeout 50 ms that converts to watchdog values */
-#define WDG_LOAD_VAL			((50 * 1000) / 32768)
+#define WDG_LOAD_VAL			((50 * 32768) / 1000)
 #define WDG_LOAD_MASK			GENMASK(15, 0)
 #define WDG_UNLOCK_KEY			0xe551
 
-- 
2.30.2



