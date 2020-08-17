Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD0024723B
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731408AbgHQSkO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:40:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:44596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388095AbgHQP6C (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:58:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7535A206FA;
        Mon, 17 Aug 2020 15:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679882;
        bh=j9meu59QtJZfpbeCevjf8a7s2tMKlBJtUzDL50SHWjI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uVuZnDgcYHg4lNMyK7ykG3NBldI27dmtGL6lKISEzrxcBN28M1WqGAHDAdDOlDU8Z
         pzQbZ3tnEZqJz5Y2hvtHZFZrJJM3Y3fyP2/W+ZsU8thUmPY8+EpyQT5p02wS5tF/MQ
         ABVsYMwVZiXh+MsDETBLZPLdW19igewzzbhSmdpY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Sverdlin <alexander.sverdlin@nokia.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH 5.7 367/393] mtd: spi-nor: intel-spi: Simulate WRDI command
Date:   Mon, 17 Aug 2020 17:16:57 +0200
Message-Id: <20200817143837.405589316@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Sverdlin <alexander.sverdlin@nokia.com>

commit 44a80df4bfce02f5d51fe5040bdbdf10d0d78f4e upstream.

After spi_nor_write_disable() return code checks were introduced in the
spi-nor front end intel-spi backend stopped to work because WRDI was never
supported and always failed.

Just pretend it was sucessful and ignore the command itself. HW sequencer
shall do the right thing automatically, while with SW sequencer we cannot
do it anyway, because the only tool we had was preopcode and it makes no
sense for WRDI.

Fixes: bce679e5ae3a ("mtd: spi-nor: Check for errors after each Register Operation")
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/282e1305-fd08-e446-1a22-eb4dff78cfb4@nokia.com
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/spi-nor/controllers/intel-spi.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/mtd/spi-nor/controllers/intel-spi.c
+++ b/drivers/mtd/spi-nor/controllers/intel-spi.c
@@ -612,6 +612,15 @@ static int intel_spi_write_reg(struct sp
 		return 0;
 	}
 
+	/*
+	 * We hope that HW sequencer will do the right thing automatically and
+	 * with the SW sequencer we cannot use preopcode anyway, so just ignore
+	 * the Write Disable operation and pretend it was completed
+	 * successfully.
+	 */
+	if (opcode == SPINOR_OP_WRDI)
+		return 0;
+
 	writel(0, ispi->base + FADDR);
 
 	/* Write the value beforehand */


