Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31EC5B5C49
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729870AbfIRGYt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:24:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:45358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729914AbfIRGYq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:24:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE809218AF;
        Wed, 18 Sep 2019 06:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568787885;
        bh=EZNyax7R31/fUpxWagzOXKRSCF27HvnrImbZpRsL8sY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0od94pKX+gYwSXchVGSqT/7QT6rSEzJw7awGnx5vxMmDmdNZvDRwoNWlMAyovB7or
         IAxqAYZBBDcnxlD4tGxzuH+WEkpQk3DY2T/7cPxObVBWSJ2UQ/R3njfbNZnsZ3IMBs
         4eiu54gV5ECtKp1RxHCnz6pjZg37IxbfAMFUDQiA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars Melin <larsm17@gmail.com>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.2 02/85] cdc_ether: fix rndis support for Mediatek based smartphones
Date:   Wed, 18 Sep 2019 08:18:20 +0200
Message-Id: <20190918061234.200486731@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918061234.107708857@linuxfoundation.org>
References: <20190918061234.107708857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Bjørn Mork" <bjorn@mork.no>

[ Upstream commit 4d7ffcf3bf1be98d876c570cab8fc31d9fa92725 ]

A Mediatek based smartphone owner reports problems with USB
tethering in Linux.  The verbose USB listing shows a rndis_host
interface pair (e0/01/03 + 10/00/00), but the driver fails to
bind with

[  355.960428] usb 1-4: bad CDC descriptors

The problem is a failsafe test intended to filter out ACM serial
functions using the same 02/02/ff class/subclass/protocol as RNDIS.
The serial functions are recognized by their non-zero bmCapabilities.

No RNDIS function with non-zero bmCapabilities were known at the time
this failsafe was added. But it turns out that some Wireless class
RNDIS functions are using the bmCapabilities field. These functions
are uniquely identified as RNDIS by their class/subclass/protocol, so
the failing test can safely be disabled.  The same applies to the two
types of Misc class RNDIS functions.

Applying the failsafe to Communication class functions only retains
the original functionality, and fixes the problem for the Mediatek based
smartphone.

Tow examples of CDC functional descriptors with non-zero bmCapabilities
from Wireless class RNDIS functions are:

0e8d:000a  Mediatek Crosscall Spider X5 3G Phone

      CDC Header:
        bcdCDC               1.10
      CDC ACM:
        bmCapabilities       0x0f
          connection notifications
          sends break
          line coding and serial state
          get/set/clear comm features
      CDC Union:
        bMasterInterface        0
        bSlaveInterface         1
      CDC Call Management:
        bmCapabilities       0x03
          call management
          use DataInterface
        bDataInterface          1

and

19d2:1023  ZTE K4201-z

      CDC Header:
        bcdCDC               1.10
      CDC ACM:
        bmCapabilities       0x02
          line coding and serial state
      CDC Call Management:
        bmCapabilities       0x03
          call management
          use DataInterface
        bDataInterface          1
      CDC Union:
        bMasterInterface        0
        bSlaveInterface         1

The Mediatek example is believed to apply to most smartphones with
Mediatek firmware.  The ZTE example is most likely also part of a larger
family of devices/firmwares.

Suggested-by: Lars Melin <larsm17@gmail.com>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/cdc_ether.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/net/usb/cdc_ether.c
+++ b/drivers/net/usb/cdc_ether.c
@@ -206,7 +206,15 @@ int usbnet_generic_cdc_bind(struct usbne
 		goto bad_desc;
 	}
 skip:
-	if (rndis && header.usb_cdc_acm_descriptor &&
+	/* Communcation class functions with bmCapabilities are not
+	 * RNDIS.  But some Wireless class RNDIS functions use
+	 * bmCapabilities for their own purpose. The failsafe is
+	 * therefore applied only to Communication class RNDIS
+	 * functions.  The rndis test is redundant, but a cheap
+	 * optimization.
+	 */
+	if (rndis && is_rndis(&intf->cur_altsetting->desc) &&
+	    header.usb_cdc_acm_descriptor &&
 	    header.usb_cdc_acm_descriptor->bmCapabilities) {
 		dev_dbg(&intf->dev,
 			"ACM capabilities %02x, not really RNDIS?\n",


