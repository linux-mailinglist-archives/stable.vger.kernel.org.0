Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37F9525931B
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729516AbgIAPVH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:21:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:41576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729662AbgIAPVH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:21:07 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43C062078B;
        Tue,  1 Sep 2020 15:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598973666;
        bh=KZqOG/D8Kv+NwvA7W2O63q9QsMqSBbOK6JsY9OwhER8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RjZKXBPGus2qn66fQghC9dwh4YIijjOPPavHj3xPS+Wj5NWImq8Gybq57X4lIYPLc
         PDZBwMs5VDA7N6e69eLTAckVmx8FsQ8CMKzxwdVAKb+UuZ1S7LeoEbK5A4iOG88gMp
         xWsnK5w2C+ELBnAn6Sqi6WsbGN9ib+lpSas9/+K4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+34ee1b45d88571c2fa8b@syzkaller.appspotmail.com,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Peilin Ye <yepeilin.cs@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 4.14 90/91] HID: hiddev: Fix slab-out-of-bounds write in hiddev_ioctl_usage()
Date:   Tue,  1 Sep 2020 17:11:04 +0200
Message-Id: <20200901150932.640258413@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150928.096174795@linuxfoundation.org>
References: <20200901150928.096174795@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peilin Ye <yepeilin.cs@gmail.com>

commit 25a097f5204675550afb879ee18238ca917cba7a upstream.

`uref->usage_index` is not always being properly checked, causing
hiddev_ioctl_usage() to go out of bounds under some cases. Fix it.

Reported-by: syzbot+34ee1b45d88571c2fa8b@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?id=f2aebe90b8c56806b050a20b36f51ed6acabe802
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/usbhid/hiddev.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/hid/usbhid/hiddev.c
+++ b/drivers/hid/usbhid/hiddev.c
@@ -532,12 +532,16 @@ static noinline int hiddev_ioctl_usage(s
 
 		switch (cmd) {
 		case HIDIOCGUSAGE:
+			if (uref->usage_index >= field->report_count)
+				goto inval;
 			uref->value = field->value[uref->usage_index];
 			if (copy_to_user(user_arg, uref, sizeof(*uref)))
 				goto fault;
 			goto goodreturn;
 
 		case HIDIOCSUSAGE:
+			if (uref->usage_index >= field->report_count)
+				goto inval;
 			field->value[uref->usage_index] = uref->value;
 			goto goodreturn;
 


