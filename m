Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3B3842DC49
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 16:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232338AbhJNO5z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 10:57:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:42716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232087AbhJNO5j (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 10:57:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8073B610D1;
        Thu, 14 Oct 2021 14:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634223335;
        bh=QHYWtQfI6ZzcbQDUaOWgmt2ErIr9Rc3YKOU7G7Go6ZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SG0nWp5ghsfEPemSjv3y4joPczu3F7OOHNCK0SWOV2uQ+e+16itrgDI7L4OTpFd3V
         KWziWpDhk2C5nbs0GNbhPGHPPJp37u7suqaABKHxXGk2I9GhEOi3H7jn0rf25WB+wJ
         6QRnnbf3PRDtx04alpzQFRSuTg8l3rC0mQ2U0Xeo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.4 02/18] USB: cdc-acm: fix break reporting
Date:   Thu, 14 Oct 2021 16:53:34 +0200
Message-Id: <20211014145206.408298159@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211014145206.330102860@linuxfoundation.org>
References: <20211014145206.330102860@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 58fc1daa4d2e9789b9ffc880907c961ea7c062cc upstream.

A recent change that started reporting break events forgot to push the
event to the line discipline, which meant that a detected break would
not be reported until further characters had been receive (the port
could even have been closed and reopened in between).

Fixes: 08dff274edda ("cdc-acm: fix BREAK rx code path adding necessary calls")
Cc: stable@vger.kernel.org
Acked-by: Oliver Neukum <oneukum@suse.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20210929090937.7410-3-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-acm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -348,6 +348,9 @@ static void acm_ctrl_irq(struct urb *urb
 			acm->iocount.overrun++;
 		spin_unlock(&acm->read_lock);
 
+		if (newctrl & ACM_CTRL_BRK)
+			tty_flip_buffer_push(&acm->port);
+
 		if (difference)
 			wake_up_all(&acm->wioctl);
 


