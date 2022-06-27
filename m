Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 250C755C9B7
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236604AbiF0Lit (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:38:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236340AbiF0Lg5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:36:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A01DC101E;
        Mon, 27 Jun 2022 04:32:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3792E60920;
        Mon, 27 Jun 2022 11:32:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AA38C341C7;
        Mon, 27 Jun 2022 11:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329530;
        bh=9bAV0+306x5lteaFMiWqSZkBkr8FcYIqevBwLdY+pKo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y3L449+yfM0z3LEm1KONAjQkGC3QqteminuNX+qNGUzaTwfsqS0ODRL07dAKHarD8
         o1z2JFWCZe8OvBej0CjCKjai3vySoKh7ZSHddBHC4xz6kUBe42i397oSEATeUQnVup
         EupasvdKhSSHjkecSJMizhc6fV0T3RbZ2hSOrvGE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Charles Yeh <charlesyeh522@gmail.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.15 029/135] USB: serial: pl2303: add support for more HXN (G) types
Date:   Mon, 27 Jun 2022 13:20:36 +0200
Message-Id: <20220627111939.005772297@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111938.151743692@linuxfoundation.org>
References: <20220627111938.151743692@linuxfoundation.org>
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


