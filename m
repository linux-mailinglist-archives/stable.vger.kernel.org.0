Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3536E077A
	for <lists+stable@lfdr.de>; Tue, 22 Oct 2019 17:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732295AbfJVPbc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Oct 2019 11:31:32 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:33995 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730305AbfJVPbc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Oct 2019 11:31:32 -0400
Received: by mail-lj1-f193.google.com with SMTP id j19so17695784lja.1;
        Tue, 22 Oct 2019 08:31:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EJB7XvTqhwkjvsiq5gN/UX3zka3jCAmlwtv3LG1edKM=;
        b=GmteRHHVXu7hTKNck9oncJxOalc+3Wn2O/Neg1SgG0y+YprmsuFFXlpvoSuTZ17BwV
         wnnGWJw3jrTExyJdTz6nEi7Camk1f/OD6K26d5GoA7Lni/IeQ5xiMGs7Ag6S4ehbLvKU
         WdFjHEB9l6JBuKC7Mbln8PzR8Ov3yJPjNaWoqz4DmF8AzgIETu65FfrWRjCSV3dOupPW
         5SL7wH2Bk/tNqQmuDSVUajAAbuDnv4L0paULBNcV5WtF5rESmQn+6tDahVOOMUMf/U0J
         bpuNFeoVkvngd7r9NyvIbDOJGTiAUAZ7GVnjboBOBGL+GHtS+lgTiPAOv6hLAW/jgDMc
         C4Xg==
X-Gm-Message-State: APjAAAXY47a8bbQC7tosthE7diIfjXlnTtcKgav1qTspk/Nvvi28pQDv
        XvRV/ZZdaSfbIG9TNU8Dxcw=
X-Google-Smtp-Source: APXvYqz7WVVbHykWkvapHIKnSa5f3AP+b6vE+OgP9+nSP9uT98ogjaSLRJqBoOoJ6Wqgl5oBqYNZqA==
X-Received: by 2002:a2e:6c15:: with SMTP id h21mr18862340ljc.10.1571758290572;
        Tue, 22 Oct 2019 08:31:30 -0700 (PDT)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id q24sm7556775ljj.6.2019.10.22.08.31.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Oct 2019 08:31:29 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92.2)
        (envelope-from <johan@xi.terra>)
        id 1iMw8O-0005oL-4R; Tue, 22 Oct 2019 17:31:44 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>,
        syzbot+a4fbb3bb76cda0ea4e58@syzkaller.appspotmail.com
Subject: [PATCH] USB: ldusb: fix control-message timeout
Date:   Tue, 22 Oct 2019 17:31:27 +0200
Message-Id: <20191022153127.22295-1-johan@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <000000000000daa63d059580f872@google.com>
References: <000000000000daa63d059580f872@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

USB control-message timeouts are specified in milliseconds, not jiffies.
Waiting 83 minutes for a transfer to complete is a bit excessive.

Fixes: 2824bd250f0b ("[PATCH] USB: add ldusb driver")
Cc: stable <stable@vger.kernel.org>     # 2.6.13
Reported-by: syzbot+a4fbb3bb76cda0ea4e58@syzkaller.appspotmail.com
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/misc/ldusb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/misc/ldusb.c b/drivers/usb/misc/ldusb.c
index dd1ea25e42b1..8f86b4ebca89 100644
--- a/drivers/usb/misc/ldusb.c
+++ b/drivers/usb/misc/ldusb.c
@@ -581,7 +581,7 @@ static ssize_t ld_usb_write(struct file *file, const char __user *buffer,
 					 1 << 8, 0,
 					 dev->interrupt_out_buffer,
 					 bytes_to_write,
-					 USB_CTRL_SET_TIMEOUT * HZ);
+					 USB_CTRL_SET_TIMEOUT);
 		if (retval < 0)
 			dev_err(&dev->intf->dev,
 				"Couldn't submit HID_REQ_SET_REPORT %d\n",
-- 
2.23.0

