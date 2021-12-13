Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D946E47253B
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:43:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235069AbhLMJnE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:43:04 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53686 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234589AbhLMJkZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:40:25 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C77FDB80E1B;
        Mon, 13 Dec 2021 09:40:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3374C00446;
        Mon, 13 Dec 2021 09:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388422;
        bh=T3+PggkFjKXrWjxOXBvaketOY1gg4qvy6x+IMl/gL+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sx6X8EzhqNRXws2orKOeX9+rOI7uidkCBoQPiNTTHS657zEKuEb9WH3j6gGR9XSB1
         v0J0TDZxH6WRHFKDaZH1rRPAgAqspXhDsTS50sUbAUrdx+EDtL7vHzlSSEgeKOv/cv
         5mcFQo1Hj0WN5adpr8bT53BtPwlKMlJ2M8a50Adk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Herve Codina <herve.codina@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 4.19 44/74] mtd: rawnand: fsmc: Take instruction delay into account
Date:   Mon, 13 Dec 2021 10:30:15 +0100
Message-Id: <20211213092932.289311083@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092930.763200615@linuxfoundation.org>
References: <20211213092930.763200615@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Herve Codina <herve.codina@bootlin.com>

commit a4ca0c439f2d5ce9a3dc118d882f9f03449864c8 upstream.

The FSMC NAND controller should apply a delay after the
instruction has been issued on the bus.
The FSMC NAND controller driver did not handle this delay.

Add this waiting delay in the FSMC NAND controller driver.

Fixes: 4da712e70294 ("mtd: nand: fsmc: use ->exec_op()")
Signed-off-by: Herve Codina <herve.codina@bootlin.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20211119150316.43080-4-herve.codina@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/fsmc_nand.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/mtd/nand/raw/fsmc_nand.c
+++ b/drivers/mtd/nand/raw/fsmc_nand.c
@@ -18,6 +18,7 @@
 
 #include <linux/clk.h>
 #include <linux/completion.h>
+#include <linux/delay.h>
 #include <linux/dmaengine.h>
 #include <linux/dma-direction.h>
 #include <linux/dma-mapping.h>
@@ -700,6 +701,9 @@ static int fsmc_exec_op(struct nand_chip
 						instr->ctx.waitrdy.timeout_ms);
 			break;
 		}
+
+		if (instr->delay_ns)
+			ndelay(instr->delay_ns);
 	}
 
 	return ret;


