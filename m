Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 708531FE8C8
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728001AbgFRBJA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:09:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:35016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727911AbgFRBJA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:09:00 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3353121BE5;
        Thu, 18 Jun 2020 01:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442540;
        bh=ZdkxLbvJy2bvMzWtQalS9auF7+faPIQZEi6k7SJBIdI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B725kRKzrneMI4Z4PUYgfnPdHh/Y1x21btHzua1vOR5mK46Kqn2JmGVFPsmva5WaM
         wCRd0SoHLiFsuWhHyvEHt9xOhpuMADn5kWwG6y1Iy7I5v1msvjibka9k72Bg6WP/oj
         +YeS+uAH66QrzIBq0iJ8Dg+1E6xJhyzjGeKUEmI4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oliver Neukum <oneukum@suse.com>,
        syzbot+be5b5f86a162a6c281e6@syzkaller.appspotmail.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 041/388] usblp: poison URBs upon disconnect
Date:   Wed, 17 Jun 2020 21:02:18 -0400
Message-Id: <20200618010805.600873-41-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

[ Upstream commit 296a193b06120aa6ae7cf5c0d7b5e5b55968026e ]

syzkaller reported an URB that should have been killed to be active.
We do not understand it, but this should fix the issue if it is real.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Reported-by: syzbot+be5b5f86a162a6c281e6@syzkaller.appspotmail.com
Link: https://lore.kernel.org/r/20200507085806.5793-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/class/usblp.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/class/usblp.c b/drivers/usb/class/usblp.c
index 0d8e3f3804a3..084c48c5848f 100644
--- a/drivers/usb/class/usblp.c
+++ b/drivers/usb/class/usblp.c
@@ -468,7 +468,8 @@ static int usblp_release(struct inode *inode, struct file *file)
 	usb_autopm_put_interface(usblp->intf);
 
 	if (!usblp->present)		/* finish cleanup from disconnect */
-		usblp_cleanup(usblp);
+		usblp_cleanup(usblp);	/* any URBs must be dead */
+
 	mutex_unlock(&usblp_mutex);
 	return 0;
 }
@@ -1375,9 +1376,11 @@ static void usblp_disconnect(struct usb_interface *intf)
 
 	usblp_unlink_urbs(usblp);
 	mutex_unlock(&usblp->mut);
+	usb_poison_anchored_urbs(&usblp->urbs);
 
 	if (!usblp->used)
 		usblp_cleanup(usblp);
+
 	mutex_unlock(&usblp_mutex);
 }
 
-- 
2.25.1

