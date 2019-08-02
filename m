Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE9487F380
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406974AbfHBJ5s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:57:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:37124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406642AbfHBJ5p (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:57:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5C8B2064A;
        Fri,  2 Aug 2019 09:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739865;
        bh=mBtojOTp1hg0hXz5A1TBIU10LPdZxGISLBS/m3vpjFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vUtLbBU70A5DAEluoCvZX8wvtTAXecI+1AJmZj/IuwvV/jDOtv8GsleXjd7SSc5dp
         g2r7F0Ixrhv7h4/SbVluPUGE4u+dnv2CDq8NR7itTl7uXMcLkBuTG95vf8wYUx7GCI
         gFKBpSkUNRmVeb5DJqe9SNJSTO3gn0YxisuvsWfw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+8750abbc3a46ef47d509@syzkaller.appspotmail.com,
        Phong Tran <tranmanphong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.2 02/20] ISDN: hfcsusb: checking idx of ep configuration
Date:   Fri,  2 Aug 2019 11:39:56 +0200
Message-Id: <20190802092057.454840463@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092055.131876977@linuxfoundation.org>
References: <20190802092055.131876977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Phong Tran <tranmanphong@gmail.com>

commit f384e62a82ba5d85408405fdd6aeff89354deaa9 upstream.

The syzbot test with random endpoint address which made the idx is
overflow in the table of endpoint configuations.

this adds the checking for fixing the error report from
syzbot

KASAN: stack-out-of-bounds Read in hfcsusb_probe [1]
The patch tested by syzbot [2]

Reported-by: syzbot+8750abbc3a46ef47d509@syzkaller.appspotmail.com

[1]:
https://syzkaller.appspot.com/bug?id=30a04378dac680c5d521304a00a86156bb913522
[2]:
https://groups.google.com/d/msg/syzkaller-bugs/_6HBdge8F3E/OJn7wVNpBAAJ

Signed-off-by: Phong Tran <tranmanphong@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/isdn/hardware/mISDN/hfcsusb.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/isdn/hardware/mISDN/hfcsusb.c
+++ b/drivers/isdn/hardware/mISDN/hfcsusb.c
@@ -1955,6 +1955,9 @@ hfcsusb_probe(struct usb_interface *intf
 
 				/* get endpoint base */
 				idx = ((ep_addr & 0x7f) - 1) * 2;
+				if (idx > 15)
+					return -EIO;
+
 				if (ep_addr & 0x80)
 					idx++;
 				attr = ep->desc.bmAttributes;


