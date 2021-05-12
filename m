Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 487A437C483
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233781AbhELPbh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:31:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:38716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235310AbhELP1b (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:27:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6162D61C1A;
        Wed, 12 May 2021 15:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832351;
        bh=9d8e1kro+x5O+R31gGBlA+yRlL4lLFXIDtIe7ShIsyQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bQj1OcGRO4NAORNdV2H53ChOFa8HQbo7MeRxmbBkuy/Nn9mDeo+LXnZf0gyo6BcjH
         1DHTbyFncRLC65UG4G9LGPmfAAfG/Ccc/z24XSaaZRLTVTMQ9Et8OPsPeIrMRkBwTq
         wlTBo2U5rIBoRzufVq277HoYMQy/LXCfrhTQdG4Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        Johan Hovold <johan@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 244/530] USB: cdc-acm: fix TIOCGSERIAL implementation
Date:   Wed, 12 May 2021 16:45:54 +0200
Message-Id: <20210512144827.855050107@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 496960274153bdeb9d1f904ff1ea875cef8232c1 ]

TIOCSSERIAL is a horrid, underspecified, legacy interface which for most
serial devices is only useful for setting the close_delay and
closing_wait parameters.

The xmit_fifo_size parameter could be used to set the hardware transmit
fifo size of a legacy UART when it could not be detected, but the
interface is limited to eight bits and should be left unset when it is
not used.

Similarly, baud_base could be used to set the UART base clock when it
could not be detected, but might as well be left unset when it is not
known (which is the case for CDC).

Fix the cdc-acm TIOCGSERIAL implementation by dropping its custom
interpretation of the unused xmit_fifo_size and baud_base fields, which
overflowed the former with the URB buffer size and set the latter to the
current line speed. Also return the port line number, which is the only
other value used besides the close parameters.

Note that the current line speed can still be retrieved through the
standard termios interfaces.

Fixes: 18c75720e667 ("USB: allow users to run setserial with cdc-acm")
Acked-by: Oliver Neukum <oneukum@suse.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20210408131602.27956-4-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/class/cdc-acm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 63824552e5d0..6fbabf56dbb7 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -929,8 +929,7 @@ static int get_serial_info(struct tty_struct *tty, struct serial_struct *ss)
 {
 	struct acm *acm = tty->driver_data;
 
-	ss->xmit_fifo_size = acm->writesize;
-	ss->baud_base = le32_to_cpu(acm->line.dwDTERate);
+	ss->line = acm->minor;
 	ss->close_delay	= jiffies_to_msecs(acm->port.close_delay) / 10;
 	ss->closing_wait = acm->port.closing_wait == ASYNC_CLOSING_WAIT_NONE ?
 				ASYNC_CLOSING_WAIT_NONE :
-- 
2.30.2



