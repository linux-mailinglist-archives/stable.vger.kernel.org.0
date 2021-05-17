Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EF2E383054
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239141AbhEQO0N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:26:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:53288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239477AbhEQOYN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:24:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94E8F613CA;
        Mon, 17 May 2021 14:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260763;
        bh=eEX47t8Blvdc1dzKaJqVTN5AcqJFqloXWtPtdTGvwYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k0nqCq8SSASl7+G1vq1wJwQQvNdJFpA9RJ2ne1IW72SJrt/OZ1x01Mk8ZqnxvWLME
         m9SNnxN8JZ6MMrcsKNk3Vu4/hIeQVNfouSfhLW8xVokihSnEQaaRUQ2ji3ILOyA+/H
         usrBJXq785HA4zXv2fwdivCuhjhBCUnk+oMVIbvo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 230/363] can: mcp251xfd: mcp251xfd_probe(): fix an error pointer dereference in probe
Date:   Mon, 17 May 2021 16:01:36 +0200
Message-Id: <20210517140310.357568462@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 4cc7faa406975b460aa674606291dea197c1210c ]

When we converted this code to use dev_err_probe() we accidentally
removed a return. It means that if devm_clk_get() it will lead to an
Oops when we call clk_get_rate() on the next line.

Fixes: cf8ee6de2543 ("can: mcp251xfd: mcp251xfd_probe(): use dev_err_probe() to simplify error handling")
Link: https://lore.kernel.org/r/YJANZf13Qxd5Mhr1@mwanda
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
index 799e9d5d3481..15b04db6ed9c 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -2856,8 +2856,8 @@ static int mcp251xfd_probe(struct spi_device *spi)
 
 	clk = devm_clk_get(&spi->dev, NULL);
 	if (IS_ERR(clk))
-		dev_err_probe(&spi->dev, PTR_ERR(clk),
-			      "Failed to get Oscillator (clock)!\n");
+		return dev_err_probe(&spi->dev, PTR_ERR(clk),
+				     "Failed to get Oscillator (clock)!\n");
 	freq = clk_get_rate(clk);
 
 	/* Sanity check */
-- 
2.30.2



