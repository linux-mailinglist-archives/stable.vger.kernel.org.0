Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01B21461EC4
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379365AbhK2Sj7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:39:59 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:42416 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379235AbhK2Shr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:37:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E29BB815D4;
        Mon, 29 Nov 2021 18:34:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 907ABC53FC7;
        Mon, 29 Nov 2021 18:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210867;
        bh=gvbSvbZhBMiCaXeRox8eX1kHA2X6vmBPuxME2VIRHmQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mk9VJ+yNHJAupKvF0zBUwqoQI2KzIX3uVLhEZljI9XujAKQfiZ2XBKEc+hKbOqg2l
         rbTIf5F/6pJ4AJRymNbKwhvrUM7TOl5qbFRTb7NibVBVAbqkmj2XGf93loPKWxIfh5
         FB3NtLFPzve+3cEUSgjxliYOBzcVe/oRWQrXmhPE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anton Lundin <glance@acc.umu.se>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.15 004/179] USB: serial: pl2303: fix GC type detection
Date:   Mon, 29 Nov 2021 19:16:38 +0100
Message-Id: <20211129181719.067993043@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit aa5721a9e0c9fb8a4bdfe0c8751377cd537d6174 upstream.

At least some PL2303GC have a bcdDevice of 0x105 instead of 0x100 as the
datasheet claims. Add it to the list of known release numbers for the
HXN (G) type.

Note the chip type could only be determined indirectly based on its
package being of QFP type, which appears to only be available for
PL2303GC.

Fixes: 894758d0571d ("USB: serial: pl2303: tighten type HXN (G) detection")
Cc: stable@vger.kernel.org	# 5.13
Reported-by: Anton Lundin <glance@acc.umu.se>
Link: https://lore.kernel.org/r/20211123071613.GZ108031@montezuma.acc.umu.se
Link: https://lore.kernel.org/r/20211123091017.30708-1-johan@kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/pl2303.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -432,6 +432,7 @@ static int pl2303_detect_type(struct usb
 	case 0x200:
 		switch (bcdDevice) {
 		case 0x100:
+		case 0x105:
 		case 0x305:
 		case 0x405:
 			/*


