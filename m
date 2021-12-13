Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79719472604
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:51:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235629AbhLMJsn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:48:43 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:38634 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236096AbhLMJqD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:46:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6D467CE0AE2;
        Mon, 13 Dec 2021 09:46:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1923DC341C5;
        Mon, 13 Dec 2021 09:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388758;
        bh=agXYGWcwPEAsrO1o53XHEHFx2axEpc30MbfPaN2kDjM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EWsBzAm27Z6nAHDMin7EGtRzO1s4HGt61kXmSShBctLCQjp7ga+1ZhzKLst6xVI3f
         boz5dK3bikWbAhGC7c2OkADMXeSwD4n9zYB2iPjTxY40sAF0DC1lKz3n82Tfle6vyA
         Q8ss0fgq1WqL07zj+7SsQvhxcfX/tGc/GGclN0tE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Herve Codina <herve.codina@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.4 54/88] mtd: rawnand: fsmc: Take instruction delay into account
Date:   Mon, 13 Dec 2021 10:30:24 +0100
Message-Id: <20211213092935.130636806@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092933.250314515@linuxfoundation.org>
References: <20211213092933.250314515@linuxfoundation.org>
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
@@ -650,6 +651,9 @@ static int fsmc_exec_op(struct nand_chip
 						instr->ctx.waitrdy.timeout_ms);
 			break;
 		}
+
+		if (instr->delay_ns)
+			ndelay(instr->delay_ns);
 	}
 
 	return ret;


