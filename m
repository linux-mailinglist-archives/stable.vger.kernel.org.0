Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4F9A428F42
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 15:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237817AbhJKN4l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 09:56:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:40550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237516AbhJKNyo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 09:54:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8491761078;
        Mon, 11 Oct 2021 13:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960346;
        bh=+mYok/bzo0IpkHBsG2kKg2navJQO87uwt6xVTNrfkas=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xaIjXaKA1KEfUg6hGpo5ctFd4Sh2Mx5eOttTRkFCcVvIXyLnKMArmSFZiaT5TSkZN
         EKOsO+WxuGw4RbqUT6nS1UmJv+Hl+/rRI0J8pDIqJA0weQRta6d/DA+JSC0aFlo1QX
         ZKymgzCjl5CkOQddUfeIhu+rQC2pXF2K/jXtewSU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 04/83] USB: cdc-acm: fix break reporting
Date:   Mon, 11 Oct 2021 15:45:24 +0200
Message-Id: <20211011134508.513591200@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134508.362906295@linuxfoundation.org>
References: <20211011134508.362906295@linuxfoundation.org>
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
@@ -340,6 +340,9 @@ static void acm_process_notification(str
 			acm->iocount.overrun++;
 		spin_unlock_irqrestore(&acm->read_lock, flags);
 
+		if (newctrl & ACM_CTRL_BRK)
+			tty_flip_buffer_push(&acm->port);
+
 		if (difference)
 			wake_up_all(&acm->wioctl);
 


