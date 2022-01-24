Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A134499A0E
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:48:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1456631AbiAXVjk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:39:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390829AbiAXVM6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:12:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBA0BC06E000;
        Mon, 24 Jan 2022 12:10:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69219611CD;
        Mon, 24 Jan 2022 20:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A4FFC340E7;
        Mon, 24 Jan 2022 20:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055015;
        bh=fdw1b/O5jRA9uMPseswenIy2CXbtFeNmPjVBedmsMlQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=td2SgnJ0OWxhx+8fUUPIAPGyb5LD4SNc7IKWJdA1sL4PWqrYo+yjVY3Si+edSz/Sf
         2SAFl7DqKF1SP484HOjBxAN7P/KrOAdgqHRotzEWeZrc8pkwbAUBhobPa09/U5oUjT
         eZ8EC+9VM51IIwg6kFOaHEJYPgh7147y0XgS+JI4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stefan Riedmueller <s.riedmueller@phytec.de>,
        Han Xu <han.xu@nxp.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.15 014/846] mtd: rawnand: gpmi: Remove explicit default gpmi clock setting for i.MX6
Date:   Mon, 24 Jan 2022 19:32:11 +0100
Message-Id: <20220124184101.407137179@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Riedmueller <s.riedmueller@phytec.de>

commit aa1baa0e6c1aa4872e481dce4fc7fd6f3dd8496b upstream.

There is no need to explicitly set the default gpmi clock rate during
boot for the i.MX 6 since this is done during nand_detect anyway.

Signed-off-by: Stefan Riedmueller <s.riedmueller@phytec.de>
Cc: stable@vger.kernel.org
Acked-by: Han Xu <han.xu@nxp.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20211102202022.15551-1-ceggers@arri.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c |    9 ---------
 1 file changed, 9 deletions(-)

--- a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
+++ b/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
@@ -1054,15 +1054,6 @@ static int gpmi_get_clks(struct gpmi_nan
 		r->clock[i] = clk;
 	}
 
-	if (GPMI_IS_MX6(this))
-		/*
-		 * Set the default value for the gpmi clock.
-		 *
-		 * If you want to use the ONFI nand which is in the
-		 * Synchronous Mode, you should change the clock as you need.
-		 */
-		clk_set_rate(r->clock[0], 22000000);
-
 	return 0;
 
 err_clock:


