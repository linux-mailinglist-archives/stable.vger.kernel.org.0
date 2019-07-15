Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF5296965B
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 17:04:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387620AbfGOOId (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 10:08:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:58878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388527AbfGOOIb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 10:08:31 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42B832083D;
        Mon, 15 Jul 2019 14:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563199710;
        bh=y67MCmEZOFF6iYrH+LgL1a56DjFrmHHGgg0RpfphSqU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iIqmTNyTE/cB+yIdDWwttOn9VKgAeL5xspfFEjvCzI479dmq163tijEAnJTLPpB70
         SulUvln+pME/ZOVzWILwbwrjdJziUY2vzPcKu7JTduerU22f5Cr3g9R5pIGqY3NHfe
         ZxxCHKhnu4HAkho+hyvhWSKQtbhHWQy+GB01dCzc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.1 080/219] regmap: fix bulk writes on paged registers
Date:   Mon, 15 Jul 2019 10:01:21 -0400
Message-Id: <20190715140341.6443-80-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715140341.6443-1-sashal@kernel.org>
References: <20190715140341.6443-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit db057679de3e9e6a03c1bcd5aee09b0d25fd9f5b ]

On buses like SlimBus and SoundWire which does not support
gather_writes yet in regmap, A bulk write on paged register
would be silently ignored after programming page.
This is because local variable 'ret' value in regmap_raw_write_impl()
gets reset to 0 once page register is written successfully and the
code below checks for 'ret' value to be -ENOTSUPP before linearising
the write buffer to send to bus->write().

Fix this by resetting the 'ret' value to -ENOTSUPP in cases where
gather_writes() is not supported or single register write is
not possible.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/regmap/regmap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 4f822e087def..61d1a0864dea 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1642,6 +1642,8 @@ static int _regmap_raw_write_impl(struct regmap *map, unsigned int reg,
 					     map->format.reg_bytes +
 					     map->format.pad_bytes,
 					     val, val_len);
+	else
+		ret = -ENOTSUPP;
 
 	/* If that didn't work fall back on linearising by hand. */
 	if (ret == -ENOTSUPP) {
-- 
2.20.1

