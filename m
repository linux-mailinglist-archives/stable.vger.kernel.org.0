Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A625B3D6195
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233417AbhGZPcU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:32:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:45300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231924AbhGZPaJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:30:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C231260C40;
        Mon, 26 Jul 2021 16:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315837;
        bh=Y3bM3GTuZNYz9q2tHbFG4CKXGoYbMRHhx0x9LQPAyMo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=URfNzv4vzQH8qJL19YQte3Qru7IahG7l8Ct5BbTaHYvPAtoPM2L77egMU9zA4JvJ/
         b18YfDgi0AbFybqdWcJdmtHhGKsW5+lOWMSnkI4pD8vYK0Z8cN/08bC5KDZha6bKQ7
         PWgPDdcg5lcfvvjrWn3yEp1Tzt3ZMOtdzW+0b4wY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yoshitaka Ikeda <ikeda@nskint.co.jp>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 087/223] spi: spi-cadence-quadspi: Fix division by zero warning
Date:   Mon, 26 Jul 2021 17:37:59 +0200
Message-Id: <20210726153849.092335444@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yoshitaka Ikeda <ikeda@nskint.co.jp>

[ Upstream commit 55cef88bbf12f3bfbe5c2379a8868a034707e755 ]

Fix below division by zero warning:
- Added an if statement because buswidth can be zero, resulting in division by zero.
- The modified code was based on another driver (atmel-quadspi).

[    0.795337] Division by zero in kernel.
   :
[    0.834051] [<807fd40c>] (__div0) from [<804e1acc>] (Ldiv0+0x8/0x10)
[    0.839097] [<805f0710>] (cqspi_exec_mem_op) from [<805edb4c>] (spi_mem_exec_op+0x3b0/0x3f8)

Fixes: 7512eaf54190 ("spi: cadence-quadspi: Fix dummy cycle calculation when buswidth > 1")
Signed-off-by: Yoshitaka Ikeda <ikeda@nskint.co.jp>
Link: https://lore.kernel.org/r/ed989af6-da88-4e0b-9ed8-126db6cad2e4@nskint.co.jp
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-cadence-quadspi.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-cadence-quadspi.c b/drivers/spi/spi-cadence-quadspi.c
index 7a00346ff9b9..13d1f0ce618e 100644
--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -307,11 +307,13 @@ static unsigned int cqspi_calc_rdreg(struct cqspi_flash_pdata *f_pdata)
 
 static unsigned int cqspi_calc_dummy(const struct spi_mem_op *op, bool dtr)
 {
-	unsigned int dummy_clk;
+	unsigned int dummy_clk = 0;
 
-	dummy_clk = op->dummy.nbytes * (8 / op->dummy.buswidth);
-	if (dtr)
-		dummy_clk /= 2;
+	if (op->dummy.buswidth && op->dummy.nbytes) {
+		dummy_clk = op->dummy.nbytes * (8 / op->dummy.buswidth);
+		if (dtr)
+			dummy_clk /= 2;
+	}
 
 	return dummy_clk;
 }
-- 
2.30.2



