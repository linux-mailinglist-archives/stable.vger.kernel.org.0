Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E850410BBFE
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:17:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729318AbfK0VMN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:12:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:42506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730218AbfK0VMN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:12:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40701216F4;
        Wed, 27 Nov 2019 21:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574889132;
        bh=KfsP4joNPBfwg4VCvP6d5wvjsTN78CTCpN96dghvUiU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zD0qLob30nl+6MhW8ojZR+UMKLnRicMXkze01t7I5KDj9NoW/q2+Aek2F7ON7C708
         U/FAr49xZwAI8NEwsiGkfpdBhwtzpBIbZyDDvHacYG74OAyKfvdVeSTGKt2N4TXdkD
         uZesrvujOtwg3KFA63OU+zk2IizWhFeSupjsQIso=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.3 89/95] USB: serial: mos7840: fix remote wakeup
Date:   Wed, 27 Nov 2019 21:32:46 +0100
Message-Id: <20191127202957.941951862@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202845.651587549@linuxfoundation.org>
References: <20191127202845.651587549@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 92fe35fb9c70a00d8fbbf5bd6172c921dd9c7815 upstream.

The driver was setting the device remote-wakeup feature during probe in
violation of the USB specification (which says it should only be set
just prior to suspending the device). This could potentially waste
power during suspend as well as lead to spurious wakeups.

Note that USB core would clear the remote-wakeup feature at first
resume.

Fixes: 3f5429746d91 ("USB: Moschip 7840 USB-Serial Driver")
Cc: stable <stable@vger.kernel.org>     # 2.6.19
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/mos7840.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -2290,11 +2290,6 @@ out:
 			goto error;
 		} else
 			dev_dbg(&port->dev, "ZLP_REG5 Writing success status%d\n", status);
-
-		/* setting configuration feature to one */
-		usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev, 0),
-				0x03, 0x00, 0x01, 0x00, NULL, 0x00,
-				MOS_WDR_TIMEOUT);
 	}
 	return 0;
 error:


