Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71B623CD7F3
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242447AbhGSOTt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:19:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:54484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241320AbhGSOSw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:18:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 60FF860551;
        Mon, 19 Jul 2021 14:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626706771;
        bh=b7iXs4O/s5Z1wZtmwkzzXCl0+4PxfYp4H99cUxTFtF4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eunNTmjKP9SvjwLb+iTuitdzegNQwjk0ughRrx+T8+8dyg8EJH7jldxC/cNeK/w6r
         mCfVVOcuxhbygpHIF3anhhRb5RJazG2YFA1uDhFUgun4EyHwGDF+eynVqPj/z8yd+L
         +ABVsj3nwe4yBNUs+Vf1rVKjaA/dFLt/prDNYSWk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.4 092/188] mmc: vub3000: fix control-request direction
Date:   Mon, 19 Jul 2021 16:51:16 +0200
Message-Id: <20210719144934.516664773@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144913.076563739@linuxfoundation.org>
References: <20210719144913.076563739@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 3c0bb3107703d2c58f7a0a7a2060bb57bc120326 upstream.

The direction of the pipe argument must match the request-type direction
bit or control requests may fail depending on the host-controller-driver
implementation.

Fix the SET_ROM_WAIT_STATES request which erroneously used
usb_rcvctrlpipe().

Fixes: 88095e7b473a ("mmc: Add new VUB300 USB-to-SD/SDIO/MMC driver")
Cc: stable@vger.kernel.org      # 3.0
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20210521133026.17296-1-johan@kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/vub300.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/host/vub300.c
+++ b/drivers/mmc/host/vub300.c
@@ -2294,7 +2294,7 @@ static int vub300_probe(struct usb_inter
 	if (retval < 0)
 		goto error5;
 	retval =
-		usb_control_msg(vub300->udev, usb_rcvctrlpipe(vub300->udev, 0),
+		usb_control_msg(vub300->udev, usb_sndctrlpipe(vub300->udev, 0),
 				SET_ROM_WAIT_STATES,
 				USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 				firmware_rom_wait_states, 0x0000, NULL, 0, HZ);


