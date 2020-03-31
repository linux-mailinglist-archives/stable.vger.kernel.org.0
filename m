Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99B611991B5
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730506AbgCaJVA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:21:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:54366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731579AbgCaJKc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:10:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2FE1208E0;
        Tue, 31 Mar 2020 09:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645831;
        bh=Gyq5CPIWhGyETl7u146YtvZnj20MLETTWKjndr0vl/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PmA+zrc6B8Hok9yuq44PqoyjzOcojHbxy4lJg6vdbavH/g06VYwlkQBqKBOBDoYPB
         8lUMI7NYqgSKLLQL5xLCW70LgVzAH1C5mMPg97FZkKs1gCTsVhT2vr+DXxD6V8b8vc
         m9sULjtc9oZINJzsvi9yBxbyMwcAk4vi7Eq/1rmo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiujun Huang <hqjagain@gmail.com>,
        Johan Hovold <johan@kernel.org>,
        syzbot+37ba33391ad5f3935bbd@syzkaller.appspotmail.com
Subject: [PATCH 5.5 153/170] USB: serial: io_edgeport: fix slab-out-of-bounds read in edge_interrupt_callback
Date:   Tue, 31 Mar 2020 10:59:27 +0200
Message-Id: <20200331085439.348229781@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085423.990189598@linuxfoundation.org>
References: <20200331085423.990189598@linuxfoundation.org>
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
@@ -710,7 +710,7 @@ static void edge_interrupt_callback(stru
 		/* grab the txcredits for the ports if available */
 		position = 2;
 		portNumber = 0;
-		while ((position < length) &&
+		while ((position < length - 1) &&
 				(portNumber < edge_serial->serial->num_ports)) {
 			txCredits = data[position] | (data[position+1] << 8);
 			if (txCredits) {


