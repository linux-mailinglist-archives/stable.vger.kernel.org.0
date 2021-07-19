Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2C5F3CDAD6
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245429AbhGSOii (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:38:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:56024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244819AbhGSOgr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:36:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6583D61242;
        Mon, 19 Jul 2021 15:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707828;
        bh=GKouUk8aDWduzqzmTINVVQTIzZrxjfxi9+MXQT7MVCY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nPaq5NiYuN9nB7qefW9JOE3vq4pteNWj4xx0BiAa+SvJ0gYiqLkOscwxRL3kFp4Rl
         4ti350LiMtdTnhqJDCxIswSxbY59IOuftWuMkk88XPqqq1k1ErF54oyIX2jOis9cfa
         o4CBzWs7kd0aModyzkH9NhGlX56aDP/T3ZP8nws4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tian Tao <tiantao6@hisilicon.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 040/315] spi: omap-100k: Fix the length judgment problem
Date:   Mon, 19 Jul 2021 16:48:49 +0200
Message-Id: <20210719144944.187726701@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.861561397@linuxfoundation.org>
References: <20210719144942.861561397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tian Tao <tiantao6@hisilicon.com>

[ Upstream commit e7a1a3abea373e41ba7dfe0fbc93cb79b6a3a529 ]

word_len should be checked in the omap1_spi100k_setup_transfer
function to see if it exceeds 32.

Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
Link: https://lore.kernel.org/r/1619695248-39045-1-git-send-email-tiantao6@hisilicon.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-omap-100k.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-omap-100k.c b/drivers/spi/spi-omap-100k.c
index 1eccdc4a4581..2eeb0fe2eed2 100644
--- a/drivers/spi/spi-omap-100k.c
+++ b/drivers/spi/spi-omap-100k.c
@@ -251,7 +251,7 @@ static int omap1_spi100k_setup_transfer(struct spi_device *spi,
 	else
 		word_len = spi->bits_per_word;
 
-	if (spi->bits_per_word > 32)
+	if (word_len > 32)
 		return -EINVAL;
 	cs->word_len = word_len;
 
-- 
2.30.2



