Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 880AD2F134A
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:07:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728396AbhAKNG0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:06:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:53778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728766AbhAKNGZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:06:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8ECF32255F;
        Mon, 11 Jan 2021 13:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370370;
        bh=8lGXfChzd96VRmdI3XiedLSbfp9gS012jJfWzenkTac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J7KCfvr0okJtjY0YUUtcfRwj0nDrkPVPVh3XwtyhdUGiGZKpk4A3xKI5F//PyyZLg
         1+5kiqAFWZAXWVO5tSFd3+65f06ZFOyINonnP3Qh+/gTrbVJYAMd1JRQeH8UTuqVER
         WDrqxsVTKO5ph5eBR680lLTAsM1wM+fZ6EAC9AuI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.14 49/57] USB: serial: keyspan_pda: remove unused variable
Date:   Mon, 11 Jan 2021 14:02:08 +0100
Message-Id: <20210111130036.097607321@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130033.715773309@linuxfoundation.org>
References: <20210111130033.715773309@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

Remove an unused variable which was mistakingly left by commit
37faf5061541 ("USB: serial: keyspan_pda: fix write-wakeup
use-after-free") and only removed by a later change.

This is needed to suppress a W=1 warning about the unused variable in
the stable trees that the build bots triggers.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/keyspan_pda.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/usb/serial/keyspan_pda.c
+++ b/drivers/usb/serial/keyspan_pda.c
@@ -559,10 +559,8 @@ exit:
 static void keyspan_pda_write_bulk_callback(struct urb *urb)
 {
 	struct usb_serial_port *port = urb->context;
-	struct keyspan_pda_private *priv;
 
 	set_bit(0, &port->write_urbs_free);
-	priv = usb_get_serial_port_data(port);
 
 	/* queue up a wakeup at scheduler time */
 	usb_serial_port_softint(port);


