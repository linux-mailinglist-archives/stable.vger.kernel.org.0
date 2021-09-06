Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EBBE401C04
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 15:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243594AbhIFNBJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 09:01:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:34516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243421AbhIFNAD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Sep 2021 09:00:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE12960F45;
        Mon,  6 Sep 2021 12:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630933138;
        bh=njQpz3sGTFHiCi7aJ/y94HoaBBoa7wUeAP0HQDdn+d8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UD/CHk1ypkn4K3pWT+Gzp1hy28/bPfqDCmtgYDH8YYSf0YQtLNuS27s1ejVjj6vy6
         FkbnycTCf+e3SUSjz0S9AjOnyAAFTdEOfvL/hAnKyjHrU3TG/2L6tKeN+EBFyZ/bs7
         QI1kQpVoztRRwn0dfEKHzMlXtvDnT0+087FwMCyQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>,
        syzbot+9b57a46bf1801ce2a2ca@syzkaller.appspotmail.com
Subject: [PATCH 5.14 08/14] HID: usbhid: Fix warning caused by 0-length input reports
Date:   Mon,  6 Sep 2021 14:55:54 +0200
Message-Id: <20210906125448.462217718@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210906125448.160263393@linuxfoundation.org>
References: <20210906125448.160263393@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

commit 0a824efdb724e07574bafcd2c2486b2a3de35ff6 upstream.

Syzbot found a warning caused by hid_submit_ctrl() submitting a
control request to transfer a 0-length input report:

	usb 1-1: BOGUS control dir, pipe 80000280 doesn't match bRequestType a1

(The warning message is a little difficult to understand.  It means
that the control request claims to be for an IN transfer but this
contradicts the USB spec, which requires 0-length control transfers
always to be in the OUT direction.)

Now, a zero-length report isn't good for anything and there's no
reason for a device to have one, but the fuzzer likes to pick out
these weird edge cases.  In the future, perhaps we will decide to
reject 0-length reports at probe time.  For now, the simplest approach
for avoiding these warnings is to pretend that the report actually has
length 1.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-and-tested-by: syzbot+9b57a46bf1801ce2a2ca@syzkaller.appspotmail.com
Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Tested-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Acked-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/usbhid/hid-core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -389,6 +389,7 @@ static int hid_submit_ctrl(struct hid_de
 		maxpacket = usb_maxpacket(hid_to_usb_dev(hid),
 					  usbhid->urbctrl->pipe, 0);
 		if (maxpacket > 0) {
+			len += (len == 0);    /* Don't allow 0-length reports */
 			len = DIV_ROUND_UP(len, maxpacket);
 			len *= maxpacket;
 			if (len > usbhid->bufsize)


