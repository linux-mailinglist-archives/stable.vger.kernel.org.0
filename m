Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 973FC5263E2
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 16:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358449AbiEMOYw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 10:24:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356878AbiEMOYj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 10:24:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ADCE50B24;
        Fri, 13 May 2022 07:24:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B9B0B83066;
        Fri, 13 May 2022 14:24:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF9B3C34100;
        Fri, 13 May 2022 14:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652451870;
        bh=fHimoKp/mXL+UxFA5uk5tI0L5eJ2S8lPXohgxQuYI1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LA2tCaDDc27LI0fL/D/FqiHVrC1jjwQhSyyQ6+sGfEaRS2bwTvGnX9+NPT5rWufDL
         KzxvMY8OG6oOXhkzJ1Nd9qoVWPucC2XobL12u+BDUesWB15vTqZSxB9glHHxlx2Ag+
         97ISMop1FPc6XOpUH4+2lHRY5nEBfFOJOxBaAeNM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Larsson <andreas@gaisler.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 4.9 3/7] can: grcan: grcan_probe(): fix broken system id check for errata workaround needs
Date:   Fri, 13 May 2022 16:23:18 +0200
Message-Id: <20220513142226.012724219@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220513142225.909697091@linuxfoundation.org>
References: <20220513142225.909697091@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Larsson <andreas@gaisler.com>

commit 1e93ed26acf03fe6c97c6d573a10178596aadd43 upstream.

The systemid property was checked for in the wrong place of the device
tree and compared to the wrong value.

Fixes: 6cec9b07fe6a ("can: grcan: Add device driver for GRCAN and GRHCAN cores")
Link: https://lore.kernel.org/all/20220429084656.29788-3-andreas@gaisler.com
Cc: stable@vger.kernel.org
Signed-off-by: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/grcan.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/drivers/net/can/grcan.c
+++ b/drivers/net/can/grcan.c
@@ -245,7 +245,7 @@ struct grcan_device_config {
 		.rxsize		= GRCAN_DEFAULT_BUFFER_SIZE,	\
 		}
 
-#define GRCAN_TXBUG_SAFE_GRLIB_VERSION	0x4100
+#define GRCAN_TXBUG_SAFE_GRLIB_VERSION	4100
 #define GRLIB_VERSION_MASK		0xffff
 
 /* GRCAN private data structure */
@@ -1665,6 +1665,7 @@ exit_free_candev:
 static int grcan_probe(struct platform_device *ofdev)
 {
 	struct device_node *np = ofdev->dev.of_node;
+	struct device_node *sysid_parent;
 	struct resource *res;
 	u32 sysid, ambafreq;
 	int irq, err;
@@ -1674,10 +1675,15 @@ static int grcan_probe(struct platform_d
 	/* Compare GRLIB version number with the first that does not
 	 * have the tx bug (see start_xmit)
 	 */
-	err = of_property_read_u32(np, "systemid", &sysid);
-	if (!err && ((sysid & GRLIB_VERSION_MASK)
-		     >= GRCAN_TXBUG_SAFE_GRLIB_VERSION))
-		txbug = false;
+	sysid_parent = of_find_node_by_path("/ambapp0");
+	if (sysid_parent) {
+		of_node_get(sysid_parent);
+		err = of_property_read_u32(sysid_parent, "systemid", &sysid);
+		if (!err && ((sysid & GRLIB_VERSION_MASK) >=
+			     GRCAN_TXBUG_SAFE_GRLIB_VERSION))
+			txbug = false;
+		of_node_put(sysid_parent);
+	}
 
 	err = of_property_read_u32(np, "freq", &ambafreq);
 	if (err) {


