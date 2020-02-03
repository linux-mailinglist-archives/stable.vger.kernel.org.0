Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37262150B42
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:26:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727792AbgBCQ0F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:26:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:36946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728882AbgBCQ0D (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:26:03 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5A002080C;
        Mon,  3 Feb 2020 16:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747162;
        bh=UteHNnpLt/O9YQ6oHAMfw8GJtA0rGXMaFuZvPNpQoR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RwW46wH4oj+MabdomE9w58XUEX4YLjKkssxkMRSS6zsDeeKyWzXxd34D16B6XWGhR
         aSzmkXKRXXLYMEhXq6awDkx52zInMFe3gsmiXfR5LFW3cqPzlgxJqYk4/DR5N4pcBu
         TTPeRCvy8ufKBS5TFySKLAdReyxI8K+XRGZLMvm8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        syzbot+32310fc2aea76898d074@syzkaller.appspotmail.com,
        syzbot+99706d6390be1ac542a2@syzkaller.appspotmail.com,
        syzbot+64437af5c781a7f0e08e@syzkaller.appspotmail.com
Subject: [PATCH 4.9 36/68] media: gspca: zero usb_buf
Date:   Mon,  3 Feb 2020 16:19:32 +0000
Message-Id: <20200203161910.889671568@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161904.705434837@linuxfoundation.org>
References: <20200203161904.705434837@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

commit de89d0864f66c2a1b75becfdd6bf3793c07ce870 upstream.

Allocate gspca_dev->usb_buf with kzalloc instead of kmalloc to
ensure it is property zeroed. This fixes various syzbot errors
about uninitialized data.

Syzbot links:

https://syzkaller.appspot.com/bug?extid=32310fc2aea76898d074
https://syzkaller.appspot.com/bug?extid=99706d6390be1ac542a2
https://syzkaller.appspot.com/bug?extid=64437af5c781a7f0e08e

Reported-and-tested-by: syzbot+32310fc2aea76898d074@syzkaller.appspotmail.com
Reported-and-tested-by: syzbot+99706d6390be1ac542a2@syzkaller.appspotmail.com
Reported-and-tested-by: syzbot+64437af5c781a7f0e08e@syzkaller.appspotmail.com

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/usb/gspca/gspca.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/usb/gspca/gspca.c
+++ b/drivers/media/usb/gspca/gspca.c
@@ -2043,7 +2043,7 @@ int gspca_dev_probe2(struct usb_interfac
 		pr_err("couldn't kzalloc gspca struct\n");
 		return -ENOMEM;
 	}
-	gspca_dev->usb_buf = kmalloc(USB_BUF_SZ, GFP_KERNEL);
+	gspca_dev->usb_buf = kzalloc(USB_BUF_SZ, GFP_KERNEL);
 	if (!gspca_dev->usb_buf) {
 		pr_err("out of memory\n");
 		ret = -ENOMEM;


