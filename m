Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0EF929C1A6
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:28:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1819040AbgJ0R0x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:26:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:53716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1775590AbgJ0OxS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:53:18 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90FCC207DE;
        Tue, 27 Oct 2020 14:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810397;
        bh=JTw+OZECR89UPHKNKWzF0xdqQv+MFgn4N9oUhzti3y4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ai48gxD7z9miM/nflU9b7+ORA4ZX35S7CasdV3F2NnCskPumHQCTp/oc/FO1W9L/U
         KJeQNnVn0w7usk6nfhzDZ7qeN/Je35/QACxI2BOqODkn8gxUEqnFxth6Lvv53VgxTE
         ynExSn8Ywq4zUi0jEv71dwkwf3MHsQBX0kmyzLU8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brad Bishop <bradleyb@fuzziesquirrel.com>,
        Eddie James <eajames@linux.ibm.com>,
        Joel Stanley <joel@jms.id.au>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 125/633] spi: fsi: Handle 9 to 15 byte transfers lengths
Date:   Tue, 27 Oct 2020 14:47:48 +0100
Message-Id: <20201027135528.570866146@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brad Bishop <bradleyb@fuzziesquirrel.com>

[ Upstream commit 2b3cef0fc757bd06ed9b83bd4c436bfa55f47370 ]

The trailing <len> - 8 bytes of transfer data in this size range is no
longer ignored.

Fixes: bbb6b2f9865b ("spi: Add FSI-attached SPI controller driver")
Signed-off-by: Brad Bishop <bradleyb@fuzziesquirrel.com>
Signed-off-by: Eddie James <eajames@linux.ibm.com>
Reviewed-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Joel Stanley <joel@jms.id.au>
Link: https://lore.kernel.org/r/20200909222857.28653-2-eajames@linux.ibm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-fsi.c b/drivers/spi/spi-fsi.c
index 37a3e0f8e7526..8f64af0140e09 100644
--- a/drivers/spi/spi-fsi.c
+++ b/drivers/spi/spi-fsi.c
@@ -258,15 +258,15 @@ static int fsi_spi_sequence_transfer(struct fsi_spi *ctx,
 	if (loops > 1) {
 		fsi_spi_sequence_add(seq, SPI_FSI_SEQUENCE_BRANCH(idx));
 
-		if (rem)
-			fsi_spi_sequence_add(seq, rem);
-
 		rc = fsi_spi_write_reg(ctx, SPI_FSI_COUNTER_CFG,
 				       SPI_FSI_COUNTER_CFG_LOOPS(loops - 1));
 		if (rc)
 			return rc;
 	}
 
+	if (rem)
+		fsi_spi_sequence_add(seq, rem);
+
 	return 0;
 }
 
-- 
2.25.1



