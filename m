Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACF02EEEF9
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:19:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388402AbfKDWCI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:02:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:60430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389205AbfKDWCH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:02:07 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7570A20650;
        Mon,  4 Nov 2019 22:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904927;
        bh=5OK+09pmuILU+2bDs11edp42TY7UT0xvLUG+Qff8SaI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wb5mEC23YLAdfdMtcb3ZDJMkEJOw40YTvYpV80CPFaP5w9zmxmXLFl3Stl8ZHhp9h
         ZkiEtSLcGlOpojnAK34cGcvMF9gibQQGVyWWOtPiy09siMj+PeP17VKOYnJafDtnva
         s/DiIgnpAuR9sGsT2RGq11fsxrExAqkSQyFit3Kw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+a4fbb3bb76cda0ea4e58@syzkaller.appspotmail.com,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.19 118/149] USB: ldusb: fix control-message timeout
Date:   Mon,  4 Nov 2019 22:45:11 +0100
Message-Id: <20191104212144.595993317@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212126.090054740@linuxfoundation.org>
References: <20191104212126.090054740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 52403cfbc635d28195167618690595013776ebde upstream.

USB control-message timeouts are specified in milliseconds, not jiffies.
Waiting 83 minutes for a transfer to complete is a bit excessive.

Fixes: 2824bd250f0b ("[PATCH] USB: add ldusb driver")
Cc: stable <stable@vger.kernel.org>     # 2.6.13
Reported-by: syzbot+a4fbb3bb76cda0ea4e58@syzkaller.appspotmail.com
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20191022153127.22295-1-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/misc/ldusb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/misc/ldusb.c
+++ b/drivers/usb/misc/ldusb.c
@@ -580,7 +580,7 @@ static ssize_t ld_usb_write(struct file
 					 1 << 8, 0,
 					 dev->interrupt_out_buffer,
 					 bytes_to_write,
-					 USB_CTRL_SET_TIMEOUT * HZ);
+					 USB_CTRL_SET_TIMEOUT);
 		if (retval < 0)
 			dev_err(&dev->intf->dev,
 				"Couldn't submit HID_REQ_SET_REPORT %d\n",


