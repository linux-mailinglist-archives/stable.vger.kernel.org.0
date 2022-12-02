Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB7686400F9
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 08:19:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231386AbiLBHTf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Dec 2022 02:19:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbiLBHTf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Dec 2022 02:19:35 -0500
Received: from smtp-out-05.comm2000.it (smtp-out-05.comm2000.it [212.97.32.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C271B71F6
        for <stable@vger.kernel.org>; Thu,  1 Dec 2022 23:19:32 -0800 (PST)
Received: from francesco-nb.pivistrello.it (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: francesco@dolcini.it)
        by smtp-out-05.comm2000.it (Postfix) with ESMTPSA id 07047825DE0;
        Fri,  2 Dec 2022 08:19:14 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mailserver.it;
        s=mailsrv; t=1669965568;
        bh=LSHnCcahHVzqYgtzt/K/qrr5ftQL6iCGOHe3Sqd3nR0=;
        h=From:To:Cc:Subject:Date;
        b=OxRCz0XuoBOqMQi6+yGGhr8siDQgBbd+v/Tn7QnOndp/GqYZxSIDlHL9skA8oDdYW
         /7SlrIYdL+lRbHcQK6PzCbPGmoP3WYLtMmrKIaBpqqnPDge9472aKFnFDGpjr9LwK/
         d5Hq/BI+NyRj33kNilwSKwDKLbisBIGp9JXgYM2N6sSW2TQbTZkyAPZymM7bgQpV9A
         8RqJk0C2/PbHBWdU2Mr0cZDFBuILShBfe7USRAYwH51FbJgS+T/14AvMI2Xo0TkMZc
         9ZGfdcutymA/XtjoiddXZuer4wAJNj3m+6FH70MMWJDCxd0NP1HVoBS26KEHyqq0ZK
         SCXAWFlVPVpRA==
From:   Francesco Dolcini <francesco@dolcini.it>
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-mtd@lists.infradead.org, Marek Vasut <marex@denx.de>
Cc:     Francesco Dolcini <francesco.dolcini@toradex.com>,
        Shawn Guo <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
Subject: [PATCH v1] mtd: parsers: ofpart: Fix parsing when size-cells is 0
Date:   Fri,  2 Dec 2022 08:19:00 +0100
Message-Id: <20221202071900.1143950-1-francesco@dolcini.it>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Francesco Dolcini <francesco.dolcini@toradex.com>

Add a fallback mechanism to handle the case in which #size-cells is set
to <0>. According to the DT binding the nand controller node should have
set it to 0 and this is not compatible with the legacy way of
specifying partitions directly as child nodes of the nand-controller node.

This fixes a boot failure on colibri-imx7 and potentially other boards.

Cc: stable@vger.kernel.org
Fixes: 753395ea1e45 ("ARM: dts: imx7: Fix NAND controller size-cells")
Link: https://lore.kernel.org/all/Y4dgBTGNWpM6SQXI@francesco-nb.int.toradex.com/
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
---
 drivers/mtd/parsers/ofpart_core.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/mtd/parsers/ofpart_core.c b/drivers/mtd/parsers/ofpart_core.c
index 192190c42fc8..aa3b7fa61e50 100644
--- a/drivers/mtd/parsers/ofpart_core.c
+++ b/drivers/mtd/parsers/ofpart_core.c
@@ -122,6 +122,17 @@ static int parse_fixed_partitions(struct mtd_info *master,
 
 		a_cells = of_n_addr_cells(pp);
 		s_cells = of_n_size_cells(pp);
+		if (s_cells == 0) {
+			/*
+			 * Use #size-cells = <1> for backward compatibility
+			 * in case #size-cells is set to <0> and firmware adds
+			 * OF partitions without setting it.
+			 */
+			pr_warn_once("%s: ofpart partition %pOF (%pOF) #size-cells is <0>, using <1> for backward compatibility.\n",
+				     master->name, pp,
+				     mtd_node);
+			s_cells = 1;
+		}
 		if (len / 4 != a_cells + s_cells) {
 			pr_debug("%s: ofpart partition %pOF (%pOF) error parsing reg property.\n",
 				 master->name, pp,
-- 
2.25.1

