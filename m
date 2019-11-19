Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2A5810156D
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:44:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730778AbfKSFn4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:43:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:39148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730554AbfKSFnz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:43:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9FAB2084D;
        Tue, 19 Nov 2019 05:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142235;
        bh=n0hSoyCt+a7Qwm0d+IWQ9s8PCzkBt2QJMIFcCIC1V2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zSDbSg/ZLs1qdbUqNa+riF90s8+6Gff1l5tcHwvDOGtT29mokSUbSP8Bfg3TTTGMe
         BgogwR9H7dX9SlPbGE15AyQyiGal11rwL2/D7g06uJhPxAaQGdTni2A3kFTSEvNXK7
         RQwajdcgWUFWUokjZcT/OV7jkwiQ04w4+i+XC2Mk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        syzbot+b6c55daa701fc389e286@syzkaller.appspotmail.com
Subject: [PATCH 4.14 013/239] Input: ff-memless - kill timer in destroy()
Date:   Tue, 19 Nov 2019 06:16:53 +0100
Message-Id: <20191119051300.474753546@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051255.850204959@linuxfoundation.org>
References: <20191119051255.850204959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

commit fa3a5a1880c91bb92594ad42dfe9eedad7996b86 upstream.

No timer must be left running when the device goes away.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Reported-and-tested-by: syzbot+b6c55daa701fc389e286@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/1573726121.17351.3.camel@suse.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/ff-memless.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/input/ff-memless.c
+++ b/drivers/input/ff-memless.c
@@ -501,6 +501,15 @@ static void ml_ff_destroy(struct ff_devi
 {
 	struct ml_device *ml = ff->private;
 
+	/*
+	 * Even though we stop all playing effects when tearing down
+	 * an input device (via input_device_flush() that calls into
+	 * input_ff_flush() that stops and erases all effects), we
+	 * do not actually stop the timer, and therefore we should
+	 * do it here.
+	 */
+	del_timer_sync(&ml->timer);
+
 	kfree(ml->private);
 }
 


