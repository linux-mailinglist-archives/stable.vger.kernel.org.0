Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7A04411E66
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347702AbhITRac (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:30:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:56328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244979AbhITR2Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:28:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D4EA61ABB;
        Mon, 20 Sep 2021 17:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157402;
        bh=p4dfK9B501AN1rkSXoJzFgRNOq5iDuB7dytHk2Ts3qk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xw2UQal4r0wsz5EayniEwKPD5TbmZ7JbmWc7gpwaHvQrXIdWZJVeBxzJF6eqDvqzC
         BvQW9e5O/v7UhRsul78aCivCsn8ZVxAkPGIMwVpmU1fK3/jYuv2U0QTmcs/WP2hj0n
         +qAeMj3fmwyerkoPox2w6KfUWzcmJp67h//AsR+k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+74d6ef051d3d2eacf428@syzkaller.appspotmail.com,
        Shuah Khan <skhan@linuxfoundation.org>,
        Anirudh Rayabharam <mail@anirudhrb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 175/217] usbip: give back URBs for unsent unlink requests during cleanup
Date:   Mon, 20 Sep 2021 18:43:16 +0200
Message-Id: <20210920163930.567063590@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163924.591371269@linuxfoundation.org>
References: <20210920163924.591371269@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anirudh Rayabharam <mail@anirudhrb.com>

[ Upstream commit 258c81b341c8025d79073ce2d6ce19dcdc7d10d2 ]

In vhci_device_unlink_cleanup(), the URBs for unsent unlink requests are
not given back. This sometimes causes usb_kill_urb to wait indefinitely
for that urb to be given back. syzbot has reported a hung task issue [1]
for this.

To fix this, give back the urbs corresponding to unsent unlink requests
(unlink_tx list) similar to how urbs corresponding to unanswered unlink
requests (unlink_rx list) are given back.

[1]: https://syzkaller.appspot.com/bug?id=08f12df95ae7da69814e64eb5515d5a85ed06b76

Reported-by: syzbot+74d6ef051d3d2eacf428@syzkaller.appspotmail.com
Tested-by: syzbot+74d6ef051d3d2eacf428@syzkaller.appspotmail.com
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Anirudh Rayabharam <mail@anirudhrb.com>
Link: https://lore.kernel.org/r/20210820190122.16379-2-mail@anirudhrb.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/usbip/vhci_hcd.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/usb/usbip/vhci_hcd.c b/drivers/usb/usbip/vhci_hcd.c
index 9833f307d70e..709214df2c18 100644
--- a/drivers/usb/usbip/vhci_hcd.c
+++ b/drivers/usb/usbip/vhci_hcd.c
@@ -971,8 +971,32 @@ static void vhci_device_unlink_cleanup(struct vhci_device *vdev)
 	spin_lock(&vdev->priv_lock);
 
 	list_for_each_entry_safe(unlink, tmp, &vdev->unlink_tx, list) {
+		struct urb *urb;
+
+		/* give back urb of unsent unlink request */
 		pr_info("unlink cleanup tx %lu\n", unlink->unlink_seqnum);
+
+		urb = pickup_urb_and_free_priv(vdev, unlink->unlink_seqnum);
+		if (!urb) {
+			list_del(&unlink->list);
+			kfree(unlink);
+			continue;
+		}
+
+		urb->status = -ENODEV;
+
+		usb_hcd_unlink_urb_from_ep(hcd, urb);
+
 		list_del(&unlink->list);
+
+		spin_unlock(&vdev->priv_lock);
+		spin_unlock_irqrestore(&vhci->lock, flags);
+
+		usb_hcd_giveback_urb(hcd, urb, urb->status);
+
+		spin_lock_irqsave(&vhci->lock, flags);
+		spin_lock(&vdev->priv_lock);
+
 		kfree(unlink);
 	}
 
-- 
2.30.2



