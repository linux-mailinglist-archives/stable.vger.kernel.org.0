Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB84498BB1
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:15:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343864AbiAXTPs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:15:48 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37484 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346476AbiAXTN1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:13:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 503D2B81239;
        Mon, 24 Jan 2022 19:13:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C8CEC340EA;
        Mon, 24 Jan 2022 19:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051605;
        bh=u3hqC005zgAfTeEBbqJI6R/01xzTbGJA4szGvz28xBg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TCdPrq/T5vHawUcLRoHMXr4o2aPD1e8izrfcibjtbnmCDhWqTTZDO8s3nxvYLRIZe
         R6LKhqSns+asEa6MDrtEJle6GfA7FwlZOsg7gg0/f3d6TC93C38G/3lItnWduFSbvm
         5459k7klm4c9gcGVLwQkRej+0gtFc0wNvKbMbwiY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stefan Riedmueller <s.riedmueller@phytec.de>,
        Han Xu <han.xu@nxp.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 4.19 028/239] mtd: rawnand: gpmi: Remove explicit default gpmi clock setting for i.MX6
Date:   Mon, 24 Jan 2022 19:41:06 +0100
Message-Id: <20220124183944.021761016@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183943.102762895@linuxfoundation.org>
References: <20220124183943.102762895@linuxfoundation.org>
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
@@ -612,15 +612,6 @@ static int gpmi_get_clks(struct gpmi_nan
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


