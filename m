Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1FF23BB34C
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbhGDXRu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:17:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:57074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234374AbhGDXPF (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:15:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8FC2C613FB;
        Sun,  4 Jul 2021 23:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440345;
        bh=GKouUk8aDWduzqzmTINVVQTIzZrxjfxi9+MXQT7MVCY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fXO8uIyy7TGy7/TIV7uInk//VuOhTf47wcYUSwlS3hR/T/OCAi+k4PRye7AXLdvXF
         a0z/773+CjvnYQlEgjz66+NoOjG+2x1hi691JptGPNpYjfFkQpb3UhKLZKQiFeHxWo
         rUkgPat4lRL/1twbxsKj5iQhk4sWWhlrv1VHZpqEAcdAd54RLUf8987U716tkur5d5
         NoP8I0iNXcFXzkFs9I5dhffdxPegbip1DQlYMgM3jESGlJ6rJcVYhswJIavPv9dXxI
         3p12D48fj07E8QgJ8FCE831OJfEvCJNzI4Fkdx5uLdeBmKdvfCNZdsPFQ1y7nalrBi
         ibxjOwLqWdQBg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tian Tao <tiantao6@hisilicon.com>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 02/15] spi: omap-100k: Fix the length judgment problem
Date:   Sun,  4 Jul 2021 19:12:08 -0400
Message-Id: <20210704231222.1492037-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704231222.1492037-1-sashal@kernel.org>
References: <20210704231222.1492037-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

