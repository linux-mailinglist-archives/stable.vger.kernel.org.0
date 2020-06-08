Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08E331F2E63
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733248AbgFIAlD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:41:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:60436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728253AbgFHXMq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:12:46 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03CD22151B;
        Mon,  8 Jun 2020 23:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657965;
        bh=ARWCG4B8K8jopZAcwPByyM6UvWyxgVj/0kWro+nQBTs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vwSjLeBVw1znFz+d5sNdJGZCLQAjOle8IKDkNvDQwrNOLlkCl/5WWNjRKOVnavWvo
         fhdLRZH8L0+l0BV4TE1hZgrhGonR5DIVZ0snFZtrdwcyyHJQyrXPJrSJh0bS3GMMs5
         KhwroUA5DnL6xaQdg7wxJthZpWuef1rIGZe3MKko=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kyungtae Kim <kt0755@gmail.com>, Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 029/606] USB: gadget: fix illegal array access in binding with UDC
Date:   Mon,  8 Jun 2020 19:02:34 -0400
Message-Id: <20200608231211.3363633-29-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kyungtae Kim <kt0755@gmail.com>

commit 15753588bcd4bbffae1cca33c8ced5722477fe1f upstream.

FuzzUSB (a variant of syzkaller) found an illegal array access
using an incorrect index while binding a gadget with UDC.

Reference: https://www.spinics.net/lists/linux-usb/msg194331.html

This bug occurs when a size variable used for a buffer
is misused to access its strcpy-ed buffer.
Given a buffer along with its size variable (taken from user input),
from which, a new buffer is created using kstrdup().
Due to the original buffer containing 0 value in the middle,
the size of the kstrdup-ed buffer becomes smaller than that of the original.
So accessing the kstrdup-ed buffer with the same size variable
triggers memory access violation.

The fix makes sure no zero value in the buffer,
by comparing the strlen() of the orignal buffer with the size variable,
so that the access to the kstrdup-ed buffer is safe.

BUG: KASAN: slab-out-of-bounds in gadget_dev_desc_UDC_store+0x1ba/0x200
drivers/usb/gadget/configfs.c:266
Read of size 1 at addr ffff88806a55dd7e by task syz-executor.0/17208

CPU: 2 PID: 17208 Comm: syz-executor.0 Not tainted 5.6.8 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0xce/0x128 lib/dump_stack.c:118
 print_address_description.constprop.4+0x21/0x3c0 mm/kasan/report.c:374
 __kasan_report+0x131/0x1b0 mm/kasan/report.c:506
 kasan_report+0x12/0x20 mm/kasan/common.c:641
 __asan_report_load1_noabort+0x14/0x20 mm/kasan/generic_report.c:132
 gadget_dev_desc_UDC_store+0x1ba/0x200 drivers/usb/gadget/configfs.c:266
 flush_write_buffer fs/configfs/file.c:251 [inline]
 configfs_write_file+0x2f1/0x4c0 fs/configfs/file.c:283
 __vfs_write+0x85/0x110 fs/read_write.c:494
 vfs_write+0x1cd/0x510 fs/read_write.c:558
 ksys_write+0x18a/0x220 fs/read_write.c:611
 __do_sys_write fs/read_write.c:623 [inline]
 __se_sys_write fs/read_write.c:620 [inline]
 __x64_sys_write+0x73/0xb0 fs/read_write.c:620
 do_syscall_64+0x9e/0x510 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Signed-off-by: Kyungtae Kim <kt0755@gmail.com>
Reported-and-tested-by: Kyungtae Kim <kt0755@gmail.com>
Cc: Felipe Balbi <balbi@kernel.org>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200510054326.GA19198@pizza01
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/configfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/gadget/configfs.c b/drivers/usb/gadget/configfs.c
index 32b637e3e1fa..6a9aa4413d64 100644
--- a/drivers/usb/gadget/configfs.c
+++ b/drivers/usb/gadget/configfs.c
@@ -260,6 +260,9 @@ static ssize_t gadget_dev_desc_UDC_store(struct config_item *item,
 	char *name;
 	int ret;
 
+	if (strlen(page) < len)
+		return -EOVERFLOW;
+
 	name = kstrdup(page, GFP_KERNEL);
 	if (!name)
 		return -ENOMEM;
-- 
2.25.1

