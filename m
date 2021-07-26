Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8CA3D6286
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237059AbhGZPgG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:36:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:53486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233961AbhGZPfg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:35:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B61F60F6D;
        Mon, 26 Jul 2021 16:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627316164;
        bh=/3g+hFKJcHA2ntKHG671N08u4mIbnLqOHN6Fql0Efo4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YsGURxAIKFEmuke9QeQkUuRgS4+YzZI41Y/nG9E/SaBab27vQlATWfg8tEYZDicJr
         em81EUE7EFrU0cPR/N0Dv78w9G1uaIT1fqBJEvJTbz1Xq6mQcRyWP1uYJm8gcounEP
         KStkBfgZC9NjFFqxXVj3SH9t4PEP8q5rh6jSalcc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yoshitaka Ikeda <ikeda@nskint.co.jp>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.13 213/223] spi: spi-cadence-quadspi: Revert "Fix division by zero warning"
Date:   Mon, 26 Jul 2021 17:40:05 +0200
Message-Id: <20210726153853.151421379@linuxfoundation.org>
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

commit 0ccfd1ba84a4503b509250941af149e9ebd605ca upstream.

Revert to change to a better code.

This reverts commit 55cef88bbf12f3bfbe5c2379a8868a034707e755.

Signed-off-by: Yoshitaka Ikeda <ikeda@nskint.co.jp>
Link: https://lore.kernel.org/r/bd30bdb4-07c4-f713-5648-01c898d51f1b@nskint.co.jp
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-cadence-quadspi.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -307,13 +307,11 @@ static unsigned int cqspi_calc_rdreg(str
 
 static unsigned int cqspi_calc_dummy(const struct spi_mem_op *op, bool dtr)
 {
-	unsigned int dummy_clk = 0;
+	unsigned int dummy_clk;
 
-	if (op->dummy.buswidth && op->dummy.nbytes) {
-		dummy_clk = op->dummy.nbytes * (8 / op->dummy.buswidth);
-		if (dtr)
-			dummy_clk /= 2;
-	}
+	dummy_clk = op->dummy.nbytes * (8 / op->dummy.buswidth);
+	if (dtr)
+		dummy_clk /= 2;
 
 	return dummy_clk;
 }


