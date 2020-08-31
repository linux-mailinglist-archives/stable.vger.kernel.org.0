Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51E7A257CD4
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 17:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728951AbgHaPbj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 11:31:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:42712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728941AbgHaPbi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 Aug 2020 11:31:38 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 62DD1214D8;
        Mon, 31 Aug 2020 15:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598887898;
        bh=21dXZEn0O1G96r2416vRzRVa6C2P3RoJxIOadJDE+Tc=;
        h=From:To:Cc:Subject:Date:From;
        b=Jz2YNJ2Uu9QmDShASf17E/4JUGi0I54FYimTjzm4xzJpW0ukTxH2PK3FD7yjnUx9Z
         V/5LT4FpCEZ8fxe53kAzWSQR79kUP9lMN2shuL5oXBvmtTMtfM0zAYPaSK6dg5PXzt
         xwHExx9O/pNnUFe0rvS/nLKv70CvyVAqdzV9QA2k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peilin Ye <yepeilin.cs@gmail.com>,
        syzbot+34ee1b45d88571c2fa8b@syzkaller.appspotmail.com,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 1/9] HID: hiddev: Fix slab-out-of-bounds write in hiddev_ioctl_usage()
Date:   Mon, 31 Aug 2020 11:31:28 -0400
Message-Id: <20200831153136.1024676-1-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peilin Ye <yepeilin.cs@gmail.com>

[ Upstream commit 25a097f5204675550afb879ee18238ca917cba7a ]

`uref->usage_index` is not always being properly checked, causing
hiddev_ioctl_usage() to go out of bounds under some cases. Fix it.

Reported-by: syzbot+34ee1b45d88571c2fa8b@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?id=f2aebe90b8c56806b050a20b36f51ed6acabe802
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/usbhid/hiddev.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/hid/usbhid/hiddev.c b/drivers/hid/usbhid/hiddev.c
index d9602f3a359e1..5f56feb468c15 100644
--- a/drivers/hid/usbhid/hiddev.c
+++ b/drivers/hid/usbhid/hiddev.c
@@ -532,12 +532,16 @@ static noinline int hiddev_ioctl_usage(struct hiddev *hiddev, unsigned int cmd,
 
 		switch (cmd) {
 		case HIDIOCGUSAGE:
+			if (uref->usage_index >= field->report_count)
+				goto inval;
 			uref->value = field->value[uref->usage_index];
 			if (copy_to_user(user_arg, uref, sizeof(*uref)))
 				goto fault;
 			goto goodreturn;
 
 		case HIDIOCSUSAGE:
+			if (uref->usage_index >= field->report_count)
+				goto inval;
 			field->value[uref->usage_index] = uref->value;
 			goto goodreturn;
 
-- 
2.25.1

