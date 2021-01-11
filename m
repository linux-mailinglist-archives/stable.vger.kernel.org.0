Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03AF32F140D
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:20:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733238AbhAKNTK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:19:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:37484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733234AbhAKNTJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:19:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E95E822795;
        Mon, 11 Jan 2021 13:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610371108;
        bh=CPgXb2Py6cXtuSYR4oqBN0OYgU3xOHVOl/Rd3RrIOig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E6iblfflr/5inOaP/Fzuzm1eiQiXNcvl9yEdSK0SUcKRS9VZ5Zqwmp/neZQwgyLGI
         TGSu57cE15/qvKpahxAoUA4C/xGGo365U/B9E5PpfHQmJJc2yKTYzjUvV+ribEKkLT
         WwlDqH1OCfrVU2E7Kpnh55jcURSgcq6Qkpw9bDLQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+65be4277f3c489293939@syzkaller.appspotmail.com,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.10 145/145] rtlwifi: rise completion at the last step of firmware callback
Date:   Mon, 11 Jan 2021 14:02:49 +0100
Message-Id: <20210111130055.473163013@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ping-Ke Shih <pkshih@realtek.com>

commit 4dfde294b9792dcf8615b55c58f093d544f472f0 upstream.

request_firmware_nowait() which schedules another work is used to load
firmware when USB is probing. If USB is unplugged before running the
firmware work, it goes disconnect ops, and then causes use-after-free.
Though we wait for completion of firmware work before freeing the hw,
firmware callback rises completion too early. So I move it to the
last step.

usb 5-1: Direct firmware load for rtlwifi/rtl8192cufw.bin failed with error -2
rtlwifi: Loading alternative firmware rtlwifi/rtl8192cufw.bin
rtlwifi: Selected firmware is not available
==================================================================
BUG: KASAN: use-after-free in rtl_fw_do_work.cold+0x68/0x6a drivers/net/wireless/realtek/rtlwifi/core.c:93
Write of size 4 at addr ffff8881454cff50 by task kworker/0:6/7379

CPU: 0 PID: 7379 Comm: kworker/0:6 Not tainted 5.10.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events request_firmware_work_func
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x4c8 mm/kasan/report.c:385
 __kasan_report mm/kasan/report.c:545 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:562
 rtl_fw_do_work.cold+0x68/0x6a drivers/net/wireless/realtek/rtlwifi/core.c:93
 request_firmware_work_func+0x12c/0x230 drivers/base/firmware_loader/main.c:1079
 process_one_work+0x933/0x1520 kernel/workqueue.c:2272
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2418
 kthread+0x38c/0x460 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

The buggy address belongs to the page:
page:00000000f54435b3 refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1454cf
flags: 0x200000000000000()
raw: 0200000000000000 0000000000000000 ffffea00051533c8 0000000000000000
raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8881454cfe00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff8881454cfe80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>ffff8881454cff00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                                                 ^
 ffff8881454cff80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff8881454d0000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff

Reported-by: syzbot+65be4277f3c489293939@syzkaller.appspotmail.com
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20201214053106.7748-1-pkshih@realtek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/realtek/rtlwifi/core.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/realtek/rtlwifi/core.c
+++ b/drivers/net/wireless/realtek/rtlwifi/core.c
@@ -78,7 +78,6 @@ static void rtl_fw_do_work(const struct
 
 	rtl_dbg(rtlpriv, COMP_ERR, DBG_LOUD,
 		"Firmware callback routine entered!\n");
-	complete(&rtlpriv->firmware_loading_complete);
 	if (!firmware) {
 		if (rtlpriv->cfg->alt_fw_name) {
 			err = request_firmware(&firmware,
@@ -91,13 +90,13 @@ static void rtl_fw_do_work(const struct
 		}
 		pr_err("Selected firmware is not available\n");
 		rtlpriv->max_fw_size = 0;
-		return;
+		goto exit;
 	}
 found_alt:
 	if (firmware->size > rtlpriv->max_fw_size) {
 		pr_err("Firmware is too big!\n");
 		release_firmware(firmware);
-		return;
+		goto exit;
 	}
 	if (!is_wow) {
 		memcpy(rtlpriv->rtlhal.pfirmware, firmware->data,
@@ -109,6 +108,9 @@ found_alt:
 		rtlpriv->rtlhal.wowlan_fwsize = firmware->size;
 	}
 	release_firmware(firmware);
+
+exit:
+	complete(&rtlpriv->firmware_loading_complete);
 }
 
 void rtl_fw_cb(const struct firmware *firmware, void *context)


