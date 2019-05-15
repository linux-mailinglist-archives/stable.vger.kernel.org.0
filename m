Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B4BD1F421
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727052AbfEOK7F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 06:59:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:55450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726594AbfEOK7D (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 06:59:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD4A3216F4;
        Wed, 15 May 2019 10:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557917942;
        bh=LOD1V+6gL9WXMN4zviTvrNZvb9jMmiuHBYDaYzfhRek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ylD7FiX5X+skZEkYUAwdsmIrjF5dGlFbuG4rtkdVkZx79gIYXPBmDlf0E18U6R/6I
         MdgyBmORIUG3iVtKVXZCISmwdyoabCXXK2NH+Ap7Sp7mZqZVE4EvIyX0XWfTZ/VpTU
         bJHChZbndAJ5tYOb3xKVzsaMyTqzmwlu3GGf1Kl0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        syzbot+b75b85111c10b8d680f1@syzkaller.appspotmail.com
Subject: [PATCH 3.18 34/86] USB: core: Fix unterminated string returned by usb_string()
Date:   Wed, 15 May 2019 12:55:11 +0200
Message-Id: <20190515090649.590467216@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090642.339346723@linuxfoundation.org>
References: <20190515090642.339346723@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

commit c01c348ecdc66085e44912c97368809612231520 upstream.

Some drivers (such as the vub300 MMC driver) expect usb_string() to
return a properly NUL-terminated string, even when an error occurs.
(In fact, vub300's probe routine doesn't bother to check the return
code from usb_string().)  When the driver goes on to use an
unterminated string, it leads to kernel errors such as
stack-out-of-bounds, as found by the syzkaller USB fuzzer.

An out-of-range string index argument is not at all unlikely, given
that some devices don't provide string descriptors and therefore list
0 as the value for their string indexes.  This patch makes
usb_string() return a properly terminated empty string along with the
-EINVAL error code when an out-of-range index is encountered.

And since a USB string index is a single-byte value, indexes >= 256
are just as invalid as values of 0 or below.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-by: syzbot+b75b85111c10b8d680f1@syzkaller.appspotmail.com
CC: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/message.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -820,9 +820,11 @@ int usb_string(struct usb_device *dev, i
 
 	if (dev->state == USB_STATE_SUSPENDED)
 		return -EHOSTUNREACH;
-	if (size <= 0 || !buf || !index)
+	if (size <= 0 || !buf)
 		return -EINVAL;
 	buf[0] = 0;
+	if (index <= 0 || index >= 256)
+		return -EINVAL;
 	tbuf = kmalloc(256, GFP_NOIO);
 	if (!tbuf)
 		return -ENOMEM;


