Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7162312140F
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:08:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729990AbfLPSHl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:07:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:48814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729815AbfLPSHk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:07:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B7B420700;
        Mon, 16 Dec 2019 18:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519659;
        bh=/tj0gDX0fkh+RFZbiR/QISLXCPBGQ1w4WHMffeu0LKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jnqujf1OenP+PFVaM7BIVJ3gskriZDkR8JIVNa9tzFbyS+V0rFb/5UFPAL81zZIi9
         TFNRWis080r6E6g9h9OeT4HQQUxNfX/o0ppuujHPL+FKW08c0kMf9JRtHveHoA8Oxh
         1FmCmfTwM4+zqjCwXFVbUtTU98d3rm0x+z74K2Qo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+35b1c403a14f5c89eba7@syzkaller.appspotmail.com,
        Hansjoerg Lipp <hjlipp@web.de>,
        Tilman Schmidt <tilman@imap.cc>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.3 017/180] staging: gigaset: fix general protection fault on probe
Date:   Mon, 16 Dec 2019 18:47:37 +0100
Message-Id: <20191216174809.562201534@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174806.018988360@linuxfoundation.org>
References: <20191216174806.018988360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 53f35a39c3860baac1e5ca80bf052751cfb24a99 upstream.

Fix a general protection fault when accessing the endpoint descriptors
which could be triggered by a malicious device due to missing sanity
checks on the number of endpoints.

Reported-by: syzbot+35b1c403a14f5c89eba7@syzkaller.appspotmail.com
Fixes: 07dc1f9f2f80 ("[PATCH] isdn4linux: Siemens Gigaset drivers - M105 USB DECT adapter")
Cc: stable <stable@vger.kernel.org>     # 2.6.17
Cc: Hansjoerg Lipp <hjlipp@web.de>
Cc: Tilman Schmidt <tilman@imap.cc>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20191202085610.12719-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/isdn/gigaset/usb-gigaset.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/staging/isdn/gigaset/usb-gigaset.c
+++ b/drivers/staging/isdn/gigaset/usb-gigaset.c
@@ -685,6 +685,11 @@ static int gigaset_probe(struct usb_inte
 		return -ENODEV;
 	}
 
+	if (hostif->desc.bNumEndpoints < 2) {
+		dev_err(&interface->dev, "missing endpoints\n");
+		return -ENODEV;
+	}
+
 	dev_info(&udev->dev, "%s: Device matched ... !\n", __func__);
 
 	/* allocate memory for our device state and initialize it */


