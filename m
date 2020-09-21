Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5BB272C9D
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728647AbgIUQdm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:33:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:59700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728637AbgIUQd3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:33:29 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79A6B239D0;
        Mon, 21 Sep 2020 16:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706009;
        bh=CD6PsofLoeKEjoaySeMOD1zS5O/GIWyJ3Er++gagnKU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q+QcPtlRhXBpW5AyLi+Rtj0/Z9e14zsJgJ86LXZsW5TMNYAq5VtDacaL801M4FSom
         Xxy+ZY4nK2RC8XEGTewU/ao4HsiA8ZiP6YjfYq4UPYRGEoeA5FtCvZ3HiY/n19+Baz
         9/Joh5WkPkTgNnjDQcIskQGeMqnyhyS/Z0u/+yro=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        syzbot+be5b5f86a162a6c281e6@syzkaller.appspotmail.com
Subject: [PATCH 4.4 41/46] usblp: fix race between disconnect() and read()
Date:   Mon, 21 Sep 2020 18:27:57 +0200
Message-Id: <20200921162035.162662168@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162033.346434578@linuxfoundation.org>
References: <20200921162033.346434578@linuxfoundation.org>
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
@@ -840,6 +840,11 @@ static ssize_t usblp_read(struct file *f
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


