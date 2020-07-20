Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76DEC226784
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387938AbgGTQMU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:12:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:51786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387932AbgGTQMR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:12:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20ECF2064B;
        Mon, 20 Jul 2020 16:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261536;
        bh=VBfbCXXqdqWlWCplIuAS219MrbV1oelsnaXURMo+0I4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uhNZoLOPQBlYINLsg8an9Axuxz7Fg11KH0bsj1A+b0Um2z/n2JVouHXXuVxZiq+kg
         ad3Dmg8rktooJKeKd6ceRiUiNxBQhQzDC1yKShDV3ziVK5IHP2ITJyRFnXoapHPZLS
         lMKbTfaZG1INxKvFwrqGllNtCQ59CP3Ob89cLxio=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+145012a46658ac00fc9e@syzkaller.appspotmail.com,
        Alan Stern <stern@rowland.harvard.edu>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.7 152/244] ALSA: line6: Sync the pending work cancel at disconnection
Date:   Mon, 20 Jul 2020 17:37:03 +0200
Message-Id: <20200720152833.079370870@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 68359a1ad8447c99732ebeab8c169bfed543667a upstream.

Recently syzkaller reported a UAF in LINE6 driver, and it's likely
because we call cancel_delayed_work() at the disconnect callback
instead of cancel_delayed_work_sync().  Let's use the correct one
instead.

Reported-by: syzbot+145012a46658ac00fc9e@syzkaller.appspotmail.com
Suggested-by: Alan Stern <stern@rowland.harvard.edu>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/s5hlfjr4gio.wl-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/line6/driver.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/usb/line6/driver.c
+++ b/sound/usb/line6/driver.c
@@ -820,7 +820,7 @@ void line6_disconnect(struct usb_interfa
 	if (WARN_ON(usbdev != line6->usbdev))
 		return;
 
-	cancel_delayed_work(&line6->startup_work);
+	cancel_delayed_work_sync(&line6->startup_work);
 
 	if (line6->urb_listen != NULL)
 		line6_stop_listen(line6);


