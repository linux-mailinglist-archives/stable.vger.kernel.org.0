Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 170F8283AB2
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727375AbgJEPg2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:36:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:60276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728037AbgJEPci (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:32:38 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C8E9208C7;
        Mon,  5 Oct 2020 15:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601911957;
        bh=IhUrg3Oki7W6Msi2uepV5D0Ce2I8UgeUV+OVuc8P5AA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E0X7msA+BH8AnOZl567wbPRRt1kacHNuOx4+dD3VGLEJ/ii01uQNFgZakaMogrkGp
         paOz05hbfTE9ehV0orvhJqWoem8SzULCDSUWOOeKVXXRPT0IBDhrQCpePdYLPiyfEu
         MBtqVqlDGw1+tTRCr4Yp1UADXGU/X9tENekv/zeg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bastien Nocera <hadess@hadess.net>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        syzkaller@googlegroups.com,
        Andrey Konovalov <andreyknvl@google.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        "M. Vefa Bicakci" <m.v.b@runbox.com>
Subject: [PATCH 5.8 05/85] Revert "usbip: Implement a match function to fix usbip"
Date:   Mon,  5 Oct 2020 17:26:01 +0200
Message-Id: <20201005142115.000911358@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142114.732094228@linuxfoundation.org>
References: <20201005142114.732094228@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: M. Vefa Bicakci <m.v.b@runbox.com>

commit d6407613c1e2ef90213dee388aa16b6e1bd08cbc upstream.

This commit reverts commit 7a2f2974f265 ("usbip: Implement a match
function to fix usbip").

In summary, commit d5643d2249b2 ("USB: Fix device driver race")
inadvertently broke usbip functionality, which I resolved in an incorrect
manner by introducing a match function to usbip, usbip_match(), that
unconditionally returns true.

However, the usbip_match function, as is, causes usbip to take over
virtual devices used by syzkaller for USB fuzzing, which is a regression
reported by Andrey Konovalov.

Furthermore, in conjunction with the fix of another bug, handled by another
patch titled "usbcore/driver: Fix specific driver selection" in this patch
set, the usbip_match function causes unexpected USB subsystem behaviour
when the usbip_host driver is loaded. The unexpected behaviour can be
qualified as follows:
- If commit 41160802ab8e ("USB: Simplify USB ID table match") is included
  in the kernel, then all USB devices are bound to the usbip_host
  driver, which appears to the user as if all USB devices were
  disconnected.
- If the same commit (41160802ab8e) is not in the kernel (as is the case
  with v5.8.10) then all USB devices are re-probed and re-bound to their
  original device drivers, which appears to the user as a disconnection
  and re-connection of USB devices.

Please note that this commit will make usbip non-operational again,
until yet another patch in this patch set is merged, titled
"usbcore/driver: Accommodate usbip".

Cc: <stable@vger.kernel.org> # 5.8: 41160802ab8e: USB: Simplify USB ID table match
Cc: <stable@vger.kernel.org> # 5.8
Cc: Bastien Nocera <hadess@hadess.net>
Cc: Valentina Manea <valentina.manea.m@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: <syzkaller@googlegroups.com>
Reported-by: Andrey Konovalov <andreyknvl@google.com>
Tested-by: Andrey Konovalov <andreyknvl@google.com>
Acked-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: M. Vefa Bicakci <m.v.b@runbox.com>
Link: https://lore.kernel.org/r/20200922110703.720960-2-m.v.b@runbox.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/usbip/stub_dev.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/drivers/usb/usbip/stub_dev.c
+++ b/drivers/usb/usbip/stub_dev.c
@@ -461,11 +461,6 @@ static void stub_disconnect(struct usb_d
 	return;
 }
 
-static bool usbip_match(struct usb_device *udev)
-{
-	return true;
-}
-
 #ifdef CONFIG_PM
 
 /* These functions need usb_port_suspend and usb_port_resume,
@@ -491,7 +486,6 @@ struct usb_device_driver stub_driver = {
 	.name		= "usbip-host",
 	.probe		= stub_probe,
 	.disconnect	= stub_disconnect,
-	.match		= usbip_match,
 #ifdef CONFIG_PM
 	.suspend	= stub_suspend,
 	.resume		= stub_resume,


