Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 404EF2F30FE
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 14:16:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731312AbhALNOZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 08:14:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:54632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404086AbhALM5o (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 07:57:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 054432313A;
        Tue, 12 Jan 2021 12:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456172;
        bh=byiYvvTnmGUoUR8k/HrJGd3sxguP1G+iK44YQb320ig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W8EiMvW3Vhho/DRULq45qK43uOrofv7veSw7jDklsFM3nK46UR4KIZywrWNUeAd+k
         88nZUNsw93JG5kpU5qqMtdb13XP4L2WK+8KMJ4mcKVsw9RMDGsVYHhgUslk2RkSi6G
         bOOuYdwepU6Bi7wV7BYVg6ncrlgkFQcjhYmQTKjiTOXM1r4tGMzFcr/6o8CP7I4ATc
         UqyCG16HVUkh4mrABMUmnK/6Z5wvRzu8it89+XRmY+I/mxGNJIwo+6A7xjmf2oaNWD
         x8gHnO9WXXE+uzlRh/DKHYjMX8NIRGMCnlhyUOO0R0cZOoO7c60hAQMuqsIG4rIDZB
         buSS2EaDucaoA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xu Yilun <yilun.xu@intel.com>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 29/51] spi: fix the divide by 0 error when calculating xfer waiting time
Date:   Tue, 12 Jan 2021 07:55:11 -0500
Message-Id: <20210112125534.70280-29-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210112125534.70280-1-sashal@kernel.org>
References: <20210112125534.70280-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xu Yilun <yilun.xu@intel.com>

[ Upstream commit 6170d077bf92c5b3dfbe1021688d3c0404f7c9e9 ]

The xfer waiting time is the result of xfer->len / xfer->speed_hz. This
patch makes the assumption of 100khz xfer speed if the xfer->speed_hz is
not assigned and stays 0. This avoids the divide by 0 issue and ensures
a reasonable tolerant waiting time.

Signed-off-by: Xu Yilun <yilun.xu@intel.com>
Link: https://lore.kernel.org/r/1609723749-3557-1-git-send-email-yilun.xu@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 2eaa7dbb70108..7694e1ae5b0b2 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -1100,6 +1100,7 @@ static int spi_transfer_wait(struct spi_controller *ctlr,
 {
 	struct spi_statistics *statm = &ctlr->statistics;
 	struct spi_statistics *stats = &msg->spi->statistics;
+	u32 speed_hz = xfer->speed_hz;
 	unsigned long long ms;
 
 	if (spi_controller_is_slave(ctlr)) {
@@ -1108,8 +1109,11 @@ static int spi_transfer_wait(struct spi_controller *ctlr,
 			return -EINTR;
 		}
 	} else {
+		if (!speed_hz)
+			speed_hz = 100000;
+
 		ms = 8LL * 1000LL * xfer->len;
-		do_div(ms, xfer->speed_hz);
+		do_div(ms, speed_hz);
 		ms += ms + 200; /* some tolerance */
 
 		if (ms > UINT_MAX)
-- 
2.27.0

