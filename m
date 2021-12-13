Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEC584727A3
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:06:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236008AbhLMKEQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:04:16 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40690 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234926AbhLMJ6s (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:58:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED63DB80E2E;
        Mon, 13 Dec 2021 09:58:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CCE2C34600;
        Mon, 13 Dec 2021 09:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389525;
        bh=3gnD6d7lN1enafBU5IvsDbkhbJlmzWiS6gjM4NQMUH8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Os56eTXvUsUiDycnNwEbpi36AxqwNmrwSCWWn1R6pKZV2sYWpkjG6o07srVJfl8GV
         rbZLfyC50gChHvBIgc5vosag51iFNUWK4oC5SAULIwj3ogWSSFn8FOb235H77FEDHv
         OlSvydGUeWZ12bGvNsMK087CpD2RzGb1On3MnQEc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Herve Codina <herve.codina@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.15 120/171] mtd: rawnand: fsmc: Take instruction delay into account
Date:   Mon, 13 Dec 2021 10:30:35 +0100
Message-Id: <20211213092949.093777539@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
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
@@ -15,6 +15,7 @@
 
 #include <linux/clk.h>
 #include <linux/completion.h>
+#include <linux/delay.h>
 #include <linux/dmaengine.h>
 #include <linux/dma-direction.h>
 #include <linux/dma-mapping.h>
@@ -664,6 +665,9 @@ static int fsmc_exec_op(struct nand_chip
 						instr->ctx.waitrdy.timeout_ms);
 			break;
 		}
+
+		if (instr->delay_ns)
+			ndelay(instr->delay_ns);
 	}
 
 	return ret;


