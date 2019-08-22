Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB56199AF1
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732095AbfHVRR3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:17:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:58088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390337AbfHVRI1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:08:27 -0400
Received: from sasha-vm.mshome.net (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3EC0B2341C;
        Thu, 22 Aug 2019 17:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566493707;
        bh=lpxYxosWAYQE5h909HT3g8DPzYphC8qQJFSXHbQFpKg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tn6VdA6XGRzOJqOs12kM3NBX/UlOp/EOEl1ZmndoM7N+eRx0xxeLL7SjIAL1C1ci/
         ExOnpEkKKeKTtrIOdvMBA+NRuKiHBDewAEZz3glDneDz/dwIcgptD3RLDpFgceXg2i
         X7YPe+3TkMbFftSC6fTVNKuOpdOKSdFeTAiOf04c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oliver Neukum <oneukum@suse.com>,
        syzbot+965152643a75a56737be@syzkaller.appspotmail.com,
        Jiri Kosina <jkosina@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.2 024/135] HID: holtek: test for sanity of intfdata
Date:   Thu, 22 Aug 2019 13:06:20 -0400
Message-Id: <20190822170811.13303-25-sashal@kernel.org>
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

commit 01ec0a5f19c8c82960a07f6c7410fc9e01d7fb51 upstream.

The ioctl handler uses the intfdata of a second interface,
which may not be present in a broken or malicious device, hence
the intfdata needs to be checked for NULL.

[jkosina@suse.cz: fix newly added spurious space]
Reported-by: syzbot+965152643a75a56737be@syzkaller.appspotmail.com
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-holtek-kbd.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-holtek-kbd.c b/drivers/hid/hid-holtek-kbd.c
index b3d502421b79d..0a38e8e9bc783 100644
--- a/drivers/hid/hid-holtek-kbd.c
+++ b/drivers/hid/hid-holtek-kbd.c
@@ -123,9 +123,14 @@ static int holtek_kbd_input_event(struct input_dev *dev, unsigned int type,
 
 	/* Locate the boot interface, to receive the LED change events */
 	struct usb_interface *boot_interface = usb_ifnum_to_if(usb_dev, 0);
+	struct hid_device *boot_hid;
+	struct hid_input *boot_hid_input;
 
-	struct hid_device *boot_hid = usb_get_intfdata(boot_interface);
-	struct hid_input *boot_hid_input = list_first_entry(&boot_hid->inputs,
+	if (unlikely(boot_interface == NULL))
+		return -ENODEV;
+
+	boot_hid = usb_get_intfdata(boot_interface);
+	boot_hid_input = list_first_entry(&boot_hid->inputs,
 		struct hid_input, list);
 
 	return boot_hid_input->input->event(boot_hid_input->input, type, code,
-- 
2.20.1

