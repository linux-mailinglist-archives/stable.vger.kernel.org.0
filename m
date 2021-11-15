Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55E2E451478
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344377AbhKOUHp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:07:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:45386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344615AbhKOTZH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 044F66369F;
        Mon, 15 Nov 2021 19:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002861;
        bh=QqjWLStjKij775g6O1xDPIQFqTFFc+WLiwX0eXPoLWI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xsohuuPRazc8OsBQaPjTGss95JralFMJJMxV6Ww2zLe60Fqk4rfYAPKAqqAv6YGKL
         kCE7rEPkYexTyiSeTqWGRHQfE5UP6SHjXxocpu/FFb71IKRq+hZLC9Jtyq7hQLDsm7
         OR7vR7wxJlAtNopQmqWvqkRn1Zv+TRVpLq6977CQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 723/917] mtd: rawnand: arasan: Prevent an unsupported configuration
Date:   Mon, 15 Nov 2021 18:03:38 +0100
Message-Id: <20211115165453.423204488@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit fc9e18f9e987ad46722dad53adab1c12148c213c ]

Under the following conditions:
* after rounding up by 4 the number of bytes to transfer (this is
  related to the controller's internal constraints),
* if this (rounded) amount of data is situated beyond the end of the
  device,
* and only in NV-DDR mode,
the Arasan NAND controller timeouts.

This currently can happen in a particular helper used when picking
software ECC algorithms. Let's prevent this situation by refusing to use
the NV-DDR interface with software engines.

Fixes: 4edde6031458 ("mtd: rawnand: arasan: Support NV-DDR interface")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20211008163640.1753821-1-miquel.raynal@bootlin.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/arasan-nand-controller.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/mtd/nand/raw/arasan-nand-controller.c b/drivers/mtd/nand/raw/arasan-nand-controller.c
index 9cbcc698c64d8..53bd10738418b 100644
--- a/drivers/mtd/nand/raw/arasan-nand-controller.c
+++ b/drivers/mtd/nand/raw/arasan-nand-controller.c
@@ -973,6 +973,21 @@ static int anfc_setup_interface(struct nand_chip *chip, int target,
 		nvddr = nand_get_nvddr_timings(conf);
 		if (IS_ERR(nvddr))
 			return PTR_ERR(nvddr);
+
+		/*
+		 * The controller only supports data payload requests which are
+		 * a multiple of 4. In practice, most data accesses are 4-byte
+		 * aligned and this is not an issue. However, rounding up will
+		 * simply be refused by the controller if we reached the end of
+		 * the device *and* we are using the NV-DDR interface(!). In
+		 * this situation, unaligned data requests ending at the device
+		 * boundary will confuse the controller and cannot be performed.
+		 *
+		 * This is something that happens in nand_read_subpage() when
+		 * selecting software ECC support and must be avoided.
+		 */
+		if (chip->ecc.engine_type == NAND_ECC_ENGINE_TYPE_SOFT)
+			return -ENOTSUPP;
 	} else {
 		sdr = nand_get_sdr_timings(conf);
 		if (IS_ERR(sdr))
-- 
2.33.0



