Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B164272EB9
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727517AbgIUQvo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:51:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:59156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730024AbgIUQuf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:50:35 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B54C23718;
        Mon, 21 Sep 2020 16:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600707035;
        bh=V1vuWQoKtYsuwretsQckiGBX277MipPxgMK4O2Srd/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XwjeQ11F1bheH9b2Vq8ezlt08RAUJ+DD/F5V8UClla/rVh8mh2CGoFQ5X+hwFKi0+
         SwNqpT3TI++4ZQn6MgxoqJaPSHeRdQL5aPBy97u8QdFiTHxA1Hq07JbzZbUCd4AYVz
         OFRmTVaGLe3cbnCImOEhHQTe93gmZg85V9pvQGLU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        syzbot+be5b5f86a162a6c281e6@syzkaller.appspotmail.com
Subject: [PATCH 5.4 54/72] usblp: fix race between disconnect() and read()
Date:   Mon, 21 Sep 2020 18:31:33 +0200
Message-Id: <20200921163124.451821295@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921163121.870386357@linuxfoundation.org>
References: <20200921163121.870386357@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

commit 9cdabcb3ef8c24ca3a456e4db7b012befb688e73 upstream.

read() needs to check whether the device has been
disconnected before it tries to talk to the device.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Reported-by: syzbot+be5b5f86a162a6c281e6@syzkaller.appspotmail.com
Link: https://lore.kernel.org/r/20200917103427.15740-1-oneukum@suse.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/class/usblp.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/usb/class/usblp.c
+++ b/drivers/usb/class/usblp.c
@@ -827,6 +827,11 @@ static ssize_t usblp_read(struct file *f
 	if (rv < 0)
 		return rv;
 
+	if (!usblp->present) {
+		count = -ENODEV;
+		goto done;
+	}
+
 	if ((avail = usblp->rstatus) < 0) {
 		printk(KERN_ERR "usblp%d: error %d reading from printer\n",
 		    usblp->minor, (int)avail);


