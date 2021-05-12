Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1291337C5D3
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235258AbhELPn1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:43:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:55348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231859AbhELPi5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:38:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 324AB61C6F;
        Wed, 12 May 2021 15:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832829;
        bh=79vaprTFR/PzptlH6sudeyUml2L5WIkbLadWPXgQaec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zSeGW0lmEpPEAuEdmW13481QpfgKvIXpw93/MlJqXssHjRXTO0hPY2UKpYXSYTl1w
         TtJcA7zg4F8HclbXLF1GnqWE/BUi8Ag2GbcHliVmORWi+qMBzf0g6lBzzrxqIyS6ts
         qgFfudhHKlc1bodRR3vg5FPKMzCPRZnoAHFWrgng=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 439/530] i2c: mlxbf: add IRQ check
Date:   Wed, 12 May 2021 16:49:09 +0200
Message-Id: <20210512144834.201242070@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Shtylyov <s.shtylyov@omprussia.ru>

[ Upstream commit 0d3bf53e897dce943b98d975bbde77156af6cd81 ]

The driver neglects to check the result of platform_get_irq()'s call and
blithely passes the negative error codes to devm_request_irq() (which
takes *unsigned* IRQ #), causing it to fail with -EINVAL, overriding
an original error code.  Stop calling devm_request_irq() with invalid
IRQ #s.

Fixes: b5b5b32081cd ("i2c: mlxbf: I2C SMBus driver for Mellanox BlueField SoC")
Signed-off-by: Sergey Shtylyov <s.shtylyov@omprussia.ru>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-mlxbf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/i2c/busses/i2c-mlxbf.c b/drivers/i2c/busses/i2c-mlxbf.c
index 2fb0532d8a16..ab261d762dea 100644
--- a/drivers/i2c/busses/i2c-mlxbf.c
+++ b/drivers/i2c/busses/i2c-mlxbf.c
@@ -2376,6 +2376,8 @@ static int mlxbf_i2c_probe(struct platform_device *pdev)
 	mlxbf_i2c_init_slave(pdev, priv);
 
 	irq = platform_get_irq(pdev, 0);
+	if (irq < 0)
+		return irq;
 	ret = devm_request_irq(dev, irq, mlxbf_smbus_irq,
 			       IRQF_ONESHOT | IRQF_SHARED | IRQF_PROBE_SHARED,
 			       dev_name(dev), priv);
-- 
2.30.2



