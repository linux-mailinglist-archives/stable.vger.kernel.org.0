Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E27F0552DC8
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 11:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347018AbiFUJBV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 05:01:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348757AbiFUI72 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 04:59:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8B32E1C;
        Tue, 21 Jun 2022 01:59:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E88361548;
        Tue, 21 Jun 2022 08:59:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4116C3411C;
        Tue, 21 Jun 2022 08:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655801966;
        bh=AB66Enb7R4KQGpkDyB/YlDU5O1cc0YNqXbOPRX++uow=;
        h=From:To:Cc:Subject:Date:From;
        b=lyL3yW2NWKl7RDcU49EKOYTAcavL5+mfzufzfEbko+by7cetSpJ4FQLXycevhzeEs
         eYgQbrkll+UVn6jqlCel/Uu1Bah7uAzIDcuGmJwSglPyguRbmBcGPhLvaR4Dz1EDSG
         y+ReuXhPgmpPG0DpCvB2fXsP3sKsygYtjx4IV3K6TOnMpswfjX4UH+omoPqg+7yTL1
         b1cDr9PcN/PMEMqRBOvRDtLQaHJIllasUvU1UznyvcV1B7pLgO67NuyP+w+ewV+UQO
         IhBKKHV//Wnp64MpzC9V2yIrpbrx7LJc1nOSRmDde4C9Exju4+jWALxzzJJ+Fu95ue
         LshYBa9fwiUIw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1o3ZjE-0001d1-0M; Tue, 21 Jun 2022 10:59:20 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        charles-yeh@prolific.com.tw, Charles Yeh <charlesyeh522@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH] USB: serial: pl2303: add support for more HXN (G) types
Date:   Tue, 21 Jun 2022 10:58:55 +0200
Message-Id: <20220621085855.6252-1-johan@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
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

Add support for further HXN (G) type devices (GT variant, GL variant, GS
variant and GR) and document the bcdDevice mapping.

Note that the TA and TB types use the same bcdDevice as some GT and GE
variants, respectively, but that the HX status request can be used to
determine which is which.

Also note that we currently do not distinguish between the various HXN
(G) types in the driver but that this may change eventually (e.g. when
adding GPIO support).

Reported-by: Charles Yeh <charlesyeh522@gmail.com>
Link: https://lore.kernel.org/r/YrF77b9DdeumUAee@hovoldconsulting.com
Cc: stable@vger.kernel.org	# 5.13
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/pl2303.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index 3506c47e1eef..40b1ab3d284d 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -436,22 +436,27 @@ static int pl2303_detect_type(struct usb_serial *serial)
 		break;
 	case 0x200:
 		switch (bcdDevice) {
-		case 0x100:
+		case 0x100:	/* GC */
 		case 0x105:
+			return TYPE_HXN;
+		case 0x300:	/* GT / TA */
+			if (pl2303_supports_hx_status(serial))
+				return TYPE_TA;
+			fallthrough;
 		case 0x305:
+		case 0x400:	/* GL */
 		case 0x405:
+			return TYPE_HXN;
+		case 0x500:	/* GE / TB */
+			if (pl2303_supports_hx_status(serial))
+				return TYPE_TB;
+			fallthrough;
+		case 0x505:
+		case 0x600:	/* GS */
 		case 0x605:
-			/*
-			 * Assume it's an HXN-type if the device doesn't
-			 * support the old read request value.
-			 */
-			if (!pl2303_supports_hx_status(serial))
-				return TYPE_HXN;
-			break;
-		case 0x300:
-			return TYPE_TA;
-		case 0x500:
-			return TYPE_TB;
+		case 0x700:	/* GR */
+		case 0x705:
+			return TYPE_HXN;
 		}
 		break;
 	}
-- 
2.35.1

