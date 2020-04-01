Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF7F19B0B9
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387997AbgDAQ27 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:28:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:54424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387558AbgDAQ27 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:28:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96EC720BED;
        Wed,  1 Apr 2020 16:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585758539;
        bh=Gyq5CPIWhGyETl7u146YtvZnj20MLETTWKjndr0vl/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=obS2t/VkCg6vfmwF38a52LTpobpT55+GiR9Yn/hC1C96xtVC2wfQF+OXBoIfKIwn6
         FaBVgKLGIx0T+qoHZUXjC3+kkLzGEw9DwKpzgNMIPMycxXCJt7c4q/TX6Mk+gKJtTg
         P5dLKtQiPpFGSn2PxAjNYMvwDOH/zqq2A6ln+BzI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiujun Huang <hqjagain@gmail.com>,
        Johan Hovold <johan@kernel.org>,
        syzbot+37ba33391ad5f3935bbd@syzkaller.appspotmail.com
Subject: [PATCH 4.19 083/116] USB: serial: io_edgeport: fix slab-out-of-bounds read in edge_interrupt_callback
Date:   Wed,  1 Apr 2020 18:17:39 +0200
Message-Id: <20200401161553.151464218@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161542.669484650@linuxfoundation.org>
References: <20200401161542.669484650@linuxfoundation.org>
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


