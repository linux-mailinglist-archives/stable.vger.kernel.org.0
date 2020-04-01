Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C22119B2F7
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387609AbgDAQsC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:48:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:49952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390106AbgDAQsB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:48:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B84332063A;
        Wed,  1 Apr 2020 16:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585759680;
        bh=IKlBNIhNGOdSwMXMGcHYdw2UJo0lDoL6NaGMlLD0S+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bacYpaSu1polefpnhBmbzrniEhuP3dPypknyXcehCZUzk81ofjUAGNT5ThaSX4ox3
         5U9xO70MwWYvqHk1rQ8YSdH+ZueTvH9Cyh82ud7+W8FvdiWBYxM5SBdYtopJYjfgfA
         L3O6W6zhdlLaNQJkv+W6oQml/8/o5gVOv5v63ftA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiujun Huang <hqjagain@gmail.com>,
        Johan Hovold <johan@kernel.org>,
        syzbot+37ba33391ad5f3935bbd@syzkaller.appspotmail.com
Subject: [PATCH 4.14 118/148] USB: serial: io_edgeport: fix slab-out-of-bounds read in edge_interrupt_callback
Date:   Wed,  1 Apr 2020 18:18:30 +0200
Message-Id: <20200401161603.801803678@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161552.245876366@linuxfoundation.org>
References: <20200401161552.245876366@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiujun Huang <hqjagain@gmail.com>

commit 57aa9f294b09463492f604feaa5cc719beaace32 upstream.

Fix slab-out-of-bounds read in the interrupt-URB completion handler.

The boundary condition should be (length - 1) as we access
data[position + 1].

Reported-and-tested-by: syzbot+37ba33391ad5f3935bbd@syzkaller.appspotmail.com
Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/io_edgeport.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/serial/io_edgeport.c
+++ b/drivers/usb/serial/io_edgeport.c
@@ -714,7 +714,7 @@ static void edge_interrupt_callback(stru
 		/* grab the txcredits for the ports if available */
 		position = 2;
 		portNumber = 0;
-		while ((position < length) &&
+		while ((position < length - 1) &&
 				(portNumber < edge_serial->serial->num_ports)) {
 			txCredits = data[position] | (data[position+1] << 8);
 			if (txCredits) {


