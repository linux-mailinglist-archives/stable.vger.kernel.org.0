Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D215710BEE4
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:39:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728020AbfK0VjT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:39:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:53704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729580AbfK0UoY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:44:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18C1B217F9;
        Wed, 27 Nov 2019 20:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887463;
        bh=4lw864Ct5JLJps2WHuqaE8tkLWAdm3FEF5yk1oCmcRY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k7H71LlkOjnRwqhMbmBNvib/oGUbiol6YfkkvZtXqKq/cIGLGvshlLiTt/wcLGlMv
         a5ADEXRdsvrZDygj7IyxqhY11CXMMRzCxLgUwNxpqG5PoKoNcHY9A5Ao+9XHjnLT1l
         0Ck2yZf4L8jMAST3pnBnSqEPC/XAKU/7cytlHyu8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        syzbot+711468aa5c3a1eabf863@syzkaller.appspotmail.com
Subject: [PATCH 4.9 122/151] nfc: port100: handle command failure cleanly
Date:   Wed, 27 Nov 2019 21:31:45 +0100
Message-Id: <20191127203045.103624570@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203000.773542911@linuxfoundation.org>
References: <20191127203000.773542911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

commit 5f9f0b11f0816b35867f2cf71e54d95f53f03902 upstream.

If starting the transfer of a command suceeds but the transfer for the reply
fails, it is not enough to initiate killing the transfer for the
command may still be running. You need to wait for the killing to finish
before you can reuse URB and buffer.

Reported-and-tested-by: syzbot+711468aa5c3a1eabf863@syzkaller.appspotmail.com
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/nfc/port100.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/nfc/port100.c
+++ b/drivers/nfc/port100.c
@@ -791,7 +791,7 @@ static int port100_send_frame_async(stru
 
 	rc = port100_submit_urb_for_ack(dev, GFP_KERNEL);
 	if (rc)
-		usb_unlink_urb(dev->out_urb);
+		usb_kill_urb(dev->out_urb);
 
 exit:
 	mutex_unlock(&dev->out_urb_lock);


