Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 898E814501E
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:44:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387977AbgAVJoC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:44:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:36914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387975AbgAVJoB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:44:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD4CB2468B;
        Wed, 22 Jan 2020 09:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579686241;
        bh=ww7v8HP4bT2dIJ+PNYY4ouiv91+eJiffjJuPz+myJbw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YmvdfF81D2qLVK/zSs9QpRpWR0mj7g9uDvjmMYT4RossqaTGZagVF9VLPCqJKCthH
         HRSH1T8Wzqcn0dXHTAC/Z5q9C6H9G8YfTvfbuXVh7x60UHnEtonLOIxmx1QZVW8DxG
         phfALHAUYSREFXiYrLe6cd6j2ZcPWi0E+6e6TMQ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 065/103] NFC: pn533: fix bulk-message timeout
Date:   Wed, 22 Jan 2020 10:29:21 +0100
Message-Id: <20200122092813.490088519@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092803.587683021@linuxfoundation.org>
References: <20200122092803.587683021@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit a112adafcb47760feff959ee1ecd10b74d2c5467 upstream.

The driver was doing a synchronous uninterruptible bulk-transfer without
using a timeout. This could lead to the driver hanging on probe due to a
malfunctioning (or malicious) device until the device is physically
disconnected. While sleeping in probe the driver prevents other devices
connected to the same hub from being added to (or removed from) the bus.

An arbitrary limit of five seconds should be more than enough.

Fixes: dbafc28955fa ("NFC: pn533: don't send USB data off of the stack")
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/nfc/pn533/usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/nfc/pn533/usb.c
+++ b/drivers/nfc/pn533/usb.c
@@ -403,7 +403,7 @@ static int pn533_acr122_poweron_rdr(stru
 		       cmd, sizeof(cmd), false);
 
 	rc = usb_bulk_msg(phy->udev, phy->out_urb->pipe, buffer, sizeof(cmd),
-			  &transferred, 0);
+			  &transferred, 5000);
 	kfree(buffer);
 	if (rc || (transferred != sizeof(cmd))) {
 		nfc_err(&phy->udev->dev,


