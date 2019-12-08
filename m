Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5B91161DF
	for <lists+stable@lfdr.de>; Sun,  8 Dec 2019 14:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727193AbfLHNzl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Dec 2019 08:55:41 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60476 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726897AbfLHNyq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Dec 2019 08:54:46 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1idx1H-0007iB-8v; Sun, 08 Dec 2019 13:54:43 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1idx1F-0002Pj-Fs; Sun, 08 Dec 2019 13:54:41 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Oliver Neukum" <oneukum@suse.com>,
        "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Date:   Sun, 08 Dec 2019 13:53:49 +0000
Message-ID: <lsq.1575813165.759121037@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 65/72] Input: ff-memless - kill timer in destroy()
In-Reply-To: <lsq.1575813164.154362148@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.79-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.com>

commit fa3a5a1880c91bb92594ad42dfe9eedad7996b86 upstream.

No timer must be left running when the device goes away.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Reported-and-tested-by: syzbot+b6c55daa701fc389e286@syzkaller.appspotmail.com
Link: https://lore.kernel.org/r/1573726121.17351.3.camel@suse.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/input/ff-memless.c | 9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/input/ff-memless.c
+++ b/drivers/input/ff-memless.c
@@ -489,6 +489,15 @@ static void ml_ff_destroy(struct ff_devi
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
 

