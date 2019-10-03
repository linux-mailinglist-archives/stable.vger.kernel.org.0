Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF34C98D7
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 09:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726677AbfJCHKa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 03:10:30 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:38617 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725879AbfJCHKa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Oct 2019 03:10:30 -0400
Received: by mail-lj1-f194.google.com with SMTP id b20so1442636ljj.5;
        Thu, 03 Oct 2019 00:10:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lk6voscM/OATPvzWTrWbUwYmf+fWIvoC2W/uo8QiGLY=;
        b=eShvmU4cSWR8qWvhXkAcmM0DTZje81UNgrSj6p/6PS0untkes+f6/+535Gji5PJ9jO
         95i8qYOxuG0tWVVZHzSulffm3fiLtYG+QKXaQaacpC/egoSlfyINSfz2jhbpIUiXw8Ib
         +i9ycBrgV9npdE84ZixMC/IePDwzs4seh2XLjfmZDkpBBpHFq0814bPuOEh3OUPredyi
         FlYbThP80oSZ7Uq7myLMjkPQ75xdIRqhQ85qNcBEFI7xKSyQEpJDwcT/hZWdlEGLH94B
         NOjDCwJqwyAfsRRtCZ1+9VVmPq9UsL4XDQUdX8j6gXiy3xrXchktzNn1KedF7r3cqKoL
         DzPg==
X-Gm-Message-State: APjAAAXMUE1mhDjhTM/fcZEZQP/SuwYr0OruhF2ZttmtLl4bFHKeYAsq
        nPwhg5yLZQ7Tjlaed8NxviY=
X-Google-Smtp-Source: APXvYqxPIuDO+y/Zg0KXsLt/MOdKkAfmlZKqUfD8kAjpDTxSLxVZUWx8/lJjq7SyKAhsLe7IbjuYFQ==
X-Received: by 2002:a2e:1648:: with SMTP id 8mr4745861ljw.194.1570086627736;
        Thu, 03 Oct 2019 00:10:27 -0700 (PDT)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id j17sm261618lfb.11.2019.10.03.00.10.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Oct 2019 00:10:26 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92.2)
        (envelope-from <johan@xi.terra>)
        id 1iFvFz-0004RG-2j; Thu, 03 Oct 2019 09:10:35 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>,
        syzbot+5630ca7c3b2be5c9da5e@syzkaller.appspotmail.com
Subject: [PATCH] USB: microtek: fix info-leak at probe
Date:   Thu,  3 Oct 2019 09:09:31 +0200
Message-Id: <20191003070931.17009-1-johan@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <0000000000000e235d0593f474ba@google.com>
References: <0000000000000e235d0593f474ba@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Add missing bulk-in endpoint sanity check to prevent uninitialised stack
data from being reported to the system log and used as endpoint
addresses.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable <stable@vger.kernel.org>
Reported-by: syzbot+5630ca7c3b2be5c9da5e@syzkaller.appspotmail.com
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/image/microtek.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/image/microtek.c b/drivers/usb/image/microtek.c
index 0a57c2cc8e5a..7a6b122c833f 100644
--- a/drivers/usb/image/microtek.c
+++ b/drivers/usb/image/microtek.c
@@ -716,6 +716,10 @@ static int mts_usb_probe(struct usb_interface *intf,
 
 	}
 
+	if (ep_in_current != &ep_in_set[2]) {
+		MTS_WARNING("couldn't find two input bulk endpoints. Bailing out.\n");
+		return -ENODEV;
+	}
 
 	if ( ep_out == -1 ) {
 		MTS_WARNING( "couldn't find an output bulk endpoint. Bailing out.\n" );
-- 
2.23.0

