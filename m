Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC2B255CA4D
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237992AbiF0Lte (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:49:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238091AbiF0Lrq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:47:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 734BEE0D4;
        Mon, 27 Jun 2022 04:39:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1BD4EB8111B;
        Mon, 27 Jun 2022 11:39:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EA9BC3411D;
        Mon, 27 Jun 2022 11:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329968;
        bh=9bAV0+306x5lteaFMiWqSZkBkr8FcYIqevBwLdY+pKo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aSbST5viX5731oVPv1KBbm2641On7LdF8F2BreQn3Vss0F22SzrwihFJ3jL64HQeb
         t1CnB7u+Kcuq05pna8IvwYo75bkcQOW2ZDvqkrhg87JIfPM6cfVHp0jRwvaU+mJuJ/
         DZAm8Q+icbSAMMZErHYYxy9c/Cp7EDBYEkc6BvyM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Charles Yeh <charlesyeh522@gmail.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.18 038/181] USB: serial: pl2303: add support for more HXN (G) types
Date:   Mon, 27 Jun 2022 13:20:11 +0200
Message-Id: <20220627111945.667730346@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit ae60aac59a9ad8ab64a4b07de509a534a75b6bac upstream.

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
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/pl2303.c |   29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -436,22 +436,27 @@ static int pl2303_detect_type(struct usb
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


