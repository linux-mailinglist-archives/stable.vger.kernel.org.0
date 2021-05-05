Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 203593739EF
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 14:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233231AbhEEMGY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 08:06:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:43942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233230AbhEEMGV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 08:06:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04D5A61157;
        Wed,  5 May 2021 12:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620216325;
        bh=ryVuvcylrMncOwfY2GCp0ucBsFelKyl9UYalyNNpH2A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QMoUw5SilxaUFcf61RxUm7qIjSTO2n59OrmP7v4F/i59dPHQ660VRogV1OE/CFKZh
         O15e4QE/qBCxIAFfyQ03qWIB/2k6AYwTVPMEGRcowCLEr0+OxeeYE78DcyingxQAJA
         E28YaR6yfkvNz4LI0GJrbq1y+kc2QE2UxtH09P1Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Chris Chiu <chris.chiu@canonical.com>
Subject: [PATCH 5.4 15/21] USB: Add reset-resume quirk for WD19s Realtek Hub
Date:   Wed,  5 May 2021 14:04:29 +0200
Message-Id: <20210505112325.233306120@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210505112324.729798712@linuxfoundation.org>
References: <20210505112324.729798712@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Chiu <chris.chiu@canonical.com>

commit ca91fd8c7643d93bfc18a6fec1a0d3972a46a18a upstream.

Realtek Hub (0bda:5487) in Dell Dock WD19 sometimes fails to work
after the system resumes from suspend with remote wakeup enabled
device connected:
[ 1947.640907] hub 5-2.3:1.0: hub_ext_port_status failed (err = -71)
[ 1947.641208] usb 5-2.3-port5: cannot disable (err = -71)
[ 1947.641401] hub 5-2.3:1.0: hub_ext_port_status failed (err = -71)
[ 1947.641450] usb 5-2.3-port4: cannot reset (err = -71)

Information of this hub:
T:  Bus=01 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#= 10 Spd=480  MxCh= 5
D:  Ver= 2.10 Cls=09(hub  ) Sub=00 Prot=02 MxPS=64 #Cfgs=  1
P:  Vendor=0bda ProdID=5487 Rev= 1.47
S:  Manufacturer=Dell Inc.
S:  Product=Dell dock
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:  If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=01 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   1 Ivl=256ms
I:* If#= 0 Alt= 1 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=02 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   1 Ivl=256ms

The failure results from the ETIMEDOUT by chance when turning on
the suspend feature for the specified port of the hub. The port
seems to be in an unknown state so the hub_activate during resume
fails the hub_port_status, then the hub will fail to work.

The quirky hub needs the reset-resume quirk to function correctly.

Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Chris Chiu <chris.chiu@canonical.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210420174651.6202-1-chris.chiu@canonical.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -406,6 +406,7 @@ static const struct usb_device_id usb_qu
 
 	/* Realtek hub in Dell WD19 (Type-C) */
 	{ USB_DEVICE(0x0bda, 0x0487), .driver_info = USB_QUIRK_NO_LPM },
+	{ USB_DEVICE(0x0bda, 0x5487), .driver_info = USB_QUIRK_RESET_RESUME },
 
 	/* Generic RTL8153 based ethernet adapters */
 	{ USB_DEVICE(0x0bda, 0x8153), .driver_info = USB_QUIRK_NO_LPM },


