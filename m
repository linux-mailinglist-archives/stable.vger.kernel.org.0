Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC1AA472468
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:36:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232864AbhLMJgM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:36:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234338AbhLMJfM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:35:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86233C061B38;
        Mon, 13 Dec 2021 01:35:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52194B80E1A;
        Mon, 13 Dec 2021 09:35:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97BB8C00446;
        Mon, 13 Dec 2021 09:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388110;
        bh=MHNxRwqc8kSvDt8LkerObcAGIt+g8qrMDoR9dMxVI+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VVuzBGMXJLgekIueoSoax56PgWaKeG4ccY0BNuJ5FDN9e+6q+pNb0iDgTpQcNdR6T
         52oB1f0mfl9h1tpPCP6OXF3ioc2fI1cJDKzLe48zend+N+wUk6d4ragQ+68WAWoU/u
         K9cYl6+SnTMskiM60ojazQbcSaACSPcszH2fVxjU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Pavel Hofman <pavel.hofman@ivitera.com>
Subject: [PATCH 4.9 32/42] usb: core: config: using bit mask instead of individual bits
Date:   Mon, 13 Dec 2021 10:30:14 +0100
Message-Id: <20211213092927.608444374@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092926.578829548@linuxfoundation.org>
References: <20211213092926.578829548@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Hofman <pavel.hofman@ivitera.com>

commit ca5737396927afd4d57b133fd2874bbcf3421cdb upstream.

Using standard USB_EP_MAXP_MULT_MASK instead of individual bits for
extracting multiple-transactions bits from wMaxPacketSize value.

Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Pavel Hofman <pavel.hofman@ivitera.com>
Link: https://lore.kernel.org/r/20211210085219.16796-2-pavel.hofman@ivitera.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/config.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/core/config.c
+++ b/drivers/usb/core/config.c
@@ -420,9 +420,9 @@ static int usb_parse_endpoint(struct dev
 		maxpacket_maxes = full_speed_maxpacket_maxes;
 		break;
 	case USB_SPEED_HIGH:
-		/* Bits 12..11 are allowed only for HS periodic endpoints */
+		/* Multiple-transactions bits are allowed only for HS periodic endpoints */
 		if (usb_endpoint_xfer_int(d) || usb_endpoint_xfer_isoc(d)) {
-			i = maxp & (BIT(12) | BIT(11));
+			i = maxp & USB_EP_MAXP_MULT_MASK;
 			maxp &= ~i;
 		}
 		/* fallthrough */


