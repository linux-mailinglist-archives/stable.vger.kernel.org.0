Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 239B51FE2F0
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730842AbgFRBWs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:22:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:56002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730345AbgFRBWs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:22:48 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5589420776;
        Thu, 18 Jun 2020 01:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443368;
        bh=+LkZii1dP7fTREBqDrvivXDp8hq7SWXVnFnqZtEXXuw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tMiMhdtKtawpAAc4+xj4IEqxgp/6ewgK0YRhSvDUAytznyfwwSjvozvNqvDT0dCz5
         0hyEjnu5lPche5B8sUDfZCe0a+7yfKGrrYhUcE4rHXqIategHn4J09Z0eoDwyjIKuP
         L5D083jDwpNx1kX3nF0CBp/o53RSXIBWojqjJPWw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oliver Neukum <oneukum@suse.com>,
        syzbot+be5b5f86a162a6c281e6@syzkaller.appspotmail.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 023/172] usblp: poison URBs upon disconnect
Date:   Wed, 17 Jun 2020 21:19:49 -0400
Message-Id: <20200618012218.607130-23-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618012218.607130-1-sashal@kernel.org>
References: <20200618012218.607130-1-sashal@kernel.org>
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
index 4a80103675d5..419804c9c974 100644
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

