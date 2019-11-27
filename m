Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF9E910BC7B
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:21:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728381AbfK0VVI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:21:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:34008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732043AbfK0VHq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:07:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D155020637;
        Wed, 27 Nov 2019 21:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888866;
        bh=ofE2EqY7W9xW3Wu4tt2rqooLZDzue3n24dtJOdV27bA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AJoHCIPM9L8Zw8C9jpQHph3fRYurI783V79vSz6B/sJmxaWIPA65/YU7itMWuxI6Q
         oBrt6489RhtRH2A/L4namlHRxsZjk1zI29Nt/wWLIde1cYtFVoLnOLzh/7Zn3taLmr
         ml3BDKqAeUzW2TPx3SycT6mGh/NVTrfdC2hWCpsk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.19 300/306] USB: serial: mos7840: fix remote wakeup
Date:   Wed, 27 Nov 2019 21:32:30 +0100
Message-Id: <20191127203136.638683675@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
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
@@ -2325,11 +2325,6 @@ out:
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


