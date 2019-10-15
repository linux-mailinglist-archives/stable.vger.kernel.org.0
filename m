Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2E9D7E2B
	for <lists+stable@lfdr.de>; Tue, 15 Oct 2019 19:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731482AbfJORzW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Oct 2019 13:55:22 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:40441 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726192AbfJORzW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Oct 2019 13:55:22 -0400
Received: by mail-lj1-f193.google.com with SMTP id 7so21195132ljw.7;
        Tue, 15 Oct 2019 10:55:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rWzJ8n7OSIuZ45gRCoMAJHmCCjITG30iMIEnwpMd3gk=;
        b=rsfHjKJNul8qvJFrZaTUY3A5XhV1bvpQX3KjrCcgU4aS5AXw7rFjarDCxexCU5ZpUU
         ReQv1N8+Znv1pBsSjcZf0dIc+XPlXxjcnO9uENjSyG9H9XaoCsRmHDWj5dHT/v/DA1xZ
         p5x+ZCwMxcQH5W73/kb+HmNF3TjllWMn86wCgAQu8FogJGzkeOukvGMDSG0xtM/NRrHz
         iyz+bOAn5eBuWfxS01Z0aQfAI8l5KT09tGsKzcTl7sWKs+FPCSaOKPOZ5MY+pMYLRFFD
         5zOiKhKMpgPrJ457YBu3NzsS5KX2UGASA7zYYUXYMffxKMvy9vcAQFhUDas7Upx6BKL6
         fakg==
X-Gm-Message-State: APjAAAWLUDluS5IgFsgy1RC2Lh2AS29ws8bJsEBjKANrLtwoHL54uq1X
        7bH25uGHeV2PnfOVwxAyLpM=
X-Google-Smtp-Source: APXvYqyQGk2et1WyKkWpkdV/Yy5lebwn2GnBYCuxpzhCEW10W7I+MFMFyhtXxB/szxWu/QVo50JHjg==
X-Received: by 2002:a2e:85c1:: with SMTP id h1mr23284311ljj.169.1571162119912;
        Tue, 15 Oct 2019 10:55:19 -0700 (PDT)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id 207sm4637079lfj.25.2019.10.15.10.55.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Oct 2019 10:55:18 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92.2)
        (envelope-from <johan@xi.terra>)
        id 1iKR2h-0004ox-8A; Tue, 15 Oct 2019 19:55:31 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pete Zaitcev <zaitcev@redhat.com>,
        Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>,
        syzbot+cd24df4d075c319ebfc5@syzkaller.appspotmail.com
Subject: [PATCH] USB: usblp: fix use-after-free on disconnect
Date:   Tue, 15 Oct 2019 19:55:22 +0200
Message-Id: <20191015175522.18490-1-johan@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <000000000000f6ca4c0594f4f3d4@google.com>
References: <000000000000f6ca4c0594f4f3d4@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A recent commit addressing a runtime PM use-count regression, introduced
a use-after-free by not making sure we held a reference to the struct
usb_interface for the lifetime of the driver data.

Fixes: 9a31535859bf ("USB: usblp: fix runtime PM after driver unbind")
Cc: stable <stable@vger.kernel.org>
Reported-by: syzbot+cd24df4d075c319ebfc5@syzkaller.appspotmail.com
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/class/usblp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/class/usblp.c b/drivers/usb/class/usblp.c
index fb8bd60c83f4..0d8e3f3804a3 100644
--- a/drivers/usb/class/usblp.c
+++ b/drivers/usb/class/usblp.c
@@ -445,6 +445,7 @@ static void usblp_cleanup(struct usblp *usblp)
 	kfree(usblp->readbuf);
 	kfree(usblp->device_id_string);
 	kfree(usblp->statusbuf);
+	usb_put_intf(usblp->intf);
 	kfree(usblp);
 }
 
@@ -1113,7 +1114,7 @@ static int usblp_probe(struct usb_interface *intf,
 	init_waitqueue_head(&usblp->wwait);
 	init_usb_anchor(&usblp->urbs);
 	usblp->ifnum = intf->cur_altsetting->desc.bInterfaceNumber;
-	usblp->intf = intf;
+	usblp->intf = usb_get_intf(intf);
 
 	/* Malloc device ID string buffer to the largest expected length,
 	 * since we can re-query it on an ioctl and a dynamic string
@@ -1198,6 +1199,7 @@ static int usblp_probe(struct usb_interface *intf,
 	kfree(usblp->readbuf);
 	kfree(usblp->statusbuf);
 	kfree(usblp->device_id_string);
+	usb_put_intf(usblp->intf);
 	kfree(usblp);
 abort_ret:
 	return retval;
-- 
2.23.0

