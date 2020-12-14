Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B25C2D968A
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 11:47:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729223AbgLNKpu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 05:45:50 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:40155 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726289AbgLNKpu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Dec 2020 05:45:50 -0500
Received: by mail-lf1-f67.google.com with SMTP id m12so28985775lfo.7;
        Mon, 14 Dec 2020 02:45:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=37w8XI/PHey+7PCjYDCHtGlWY4jIOMQTFTKt1BKLli8=;
        b=APFZhWosw4+oeG7YRIvp7Ft3J0ji6/5a9XcpvIwgL3hQBAcui3MByQS30QnqxK27QV
         Fa03qVofXxn5Zy0RD7GBwSKiQXVPOWSgICMEvF99qjlt8BYFChW6ffxsozDNJDm3VxXC
         cvNcFD6hcCOLnBqG1uJovPPih0PZXt0qlLNpVBtEqdi4p8JmqQtUbfm4NMAo3jreqwx9
         bKOmItIfbrtMiLbBvCEqWPDNdCAEqtdS0AKgZHqG0y3TSUFNODvCNlHL1sUj66krdqbw
         cLdsguuDlcrSkjHbFT3aMUT3ee9ASYBr0E/PjuM8ppYWtfQ9PygryUW08YIUHHsQCe55
         t8fQ==
X-Gm-Message-State: AOAM531iWaY6BAsMptQ53VJ+hezNmlNt2SRm1YuE2pdFVWVEAwuChkCe
        J+s0upryUMJ0iUwmr5kyTCY=
X-Google-Smtp-Source: ABdhPJwxpFM8dAuCXKcVa2ktkCXVhq9CmWEY2/vnzgZ8t3QJANf4Lw3aSd7XbwB++em0NaF+QvFuVQ==
X-Received: by 2002:ac2:5334:: with SMTP id f20mr9452559lfh.30.1607942708388;
        Mon, 14 Dec 2020 02:45:08 -0800 (PST)
Received: from xi.terra (c-b3cbe455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.203.179])
        by smtp.gmail.com with ESMTPSA id a15sm2044855lfg.27.2020.12.14.02.45.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 02:45:07 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.93.0.4)
        (envelope-from <johan@xi.terra>)
        id 1kolLi-0007Oc-O1; Mon, 14 Dec 2020 11:45:03 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        syzbot+e87ebe0f7913f71f2ea5@syzkaller.appspotmail.com,
        stable <stable@vger.kernel.org>
Subject: [PATCH] USB: yurex: fix control-URB timeout handling
Date:   Mon, 14 Dec 2020 11:44:44 +0100
Message-Id: <20201214104444.28386-1-johan@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <000000000000e2186705b65e671f@google.com>
References: <000000000000e2186705b65e671f@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Make sure to always cancel the control URB in write() so that it can be
reused after a timeout or spurious CMD_ACK.

Currently any further write requests after a timeout would fail after
triggering a WARN() in usb_submit_urb() when attempting to submit the
already active URB.

Reported-by: syzbot+e87ebe0f7913f71f2ea5@syzkaller.appspotmail.com
Fixes: 6bc235a2e24a ("USB: add driver for Meywa-Denki & Kayac YUREX")
Cc: stable <stable@vger.kernel.org>     # 2.6.37
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/misc/yurex.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/misc/yurex.c b/drivers/usb/misc/yurex.c
index 73ebfa6e9715..c640f98d20c5 100644
--- a/drivers/usb/misc/yurex.c
+++ b/drivers/usb/misc/yurex.c
@@ -496,6 +496,9 @@ static ssize_t yurex_write(struct file *file, const char __user *user_buffer,
 		timeout = schedule_timeout(YUREX_WRITE_TIMEOUT);
 	finish_wait(&dev->waitq, &wait);
 
+	/* make sure URB is idle after timeout or (spurious) CMD_ACK */
+	usb_kill_urb(dev->cntl_urb);
+
 	mutex_unlock(&dev->io_mutex);
 
 	if (retval < 0) {
-- 
2.26.2

