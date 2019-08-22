Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39DA399AE7
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389268AbfHVRRD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:17:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:58148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390357AbfHVRIa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:08:30 -0400
Received: from sasha-vm.mshome.net (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71CA32341B;
        Thu, 22 Aug 2019 17:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566493709;
        bh=krS5At2NkPTefABXFbMtagk0hgAUZuzvX1TBT4tBZLI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BO0bVKiK4Fwy+UDKmIhmKL0W6PniSIHdfLC9E5YX3Aaogw84Wpgm2kagH6wP9gszI
         OkQfGF/fHd/Y0TP8A8DxxI6AsRUaSWDddoJnhhOls+nSzwcee/7amF8WASGNy/9+hr
         wJDuJW/4+1QbDFjjTvYXki+NDr2vVNgDp79jAVnE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oliver Neukum <oneukum@suse.com>,
        syzbot+5efc10c005014d061a74@syzkaller.appspotmail.com,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.2 028/135] Input: iforce - add sanity checks
Date:   Thu, 22 Aug 2019 13:06:24 -0400
Message-Id: <20190822170811.13303-29-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190822170811.13303-1-sashal@kernel.org>
References: <20190822170811.13303-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.2.10-rc1
X-KernelTest-Deadline: 2019-08-24T17:07+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

commit 849f5ae3a513c550cad741c68dd3d7eb2bcc2a2c upstream.

The endpoint type should also be checked before a device
is accepted.

Reported-by: syzbot+5efc10c005014d061a74@syzkaller.appspotmail.com
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/joystick/iforce/iforce-usb.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/input/joystick/iforce/iforce-usb.c b/drivers/input/joystick/iforce/iforce-usb.c
index f1569ae8381bc..a0a686f56ac4f 100644
--- a/drivers/input/joystick/iforce/iforce-usb.c
+++ b/drivers/input/joystick/iforce/iforce-usb.c
@@ -129,7 +129,12 @@ static int iforce_usb_probe(struct usb_interface *intf,
 		return -ENODEV;
 
 	epirq = &interface->endpoint[0].desc;
+	if (!usb_endpoint_is_int_in(epirq))
+		return -ENODEV;
+
 	epout = &interface->endpoint[1].desc;
+	if (!usb_endpoint_is_int_out(epout))
+		return -ENODEV;
 
 	if (!(iforce = kzalloc(sizeof(struct iforce) + 32, GFP_KERNEL)))
 		goto fail;
-- 
2.20.1

