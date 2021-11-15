Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EBF3452251
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:08:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345327AbhKPBKy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:10:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:44640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245168AbhKOTTn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:19:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B4F66350B;
        Mon, 15 Nov 2021 18:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000983;
        bh=lQxQVutVPwlRON39M/YBHJlk+mFQyhk+JdIwQsGqelw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D09nzu4djaXVsM+UiWOyFgr6BhrmOPV8gYht3FISIMOoxYMl7bTP5YEfhZxzrMpUV
         w6fipTiJOdkG2xmqyqCNU+vqvp6BuaGcUfxpN6VAewAWad8XyHkX4baIS0F5UoJTLN
         OFzk/BrpEBUfLh1tmg2hy7nR2KJHDS99w6pV8L9Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eli Billauer <eli.billauer@gmail.com>,
        Ziyang Xuan <william.xuanziyang@huawei.com>
Subject: [PATCH 5.15 017/917] char: xillybus: fix msg_ep UAF in xillyusb_probe()
Date:   Mon, 15 Nov 2021 17:51:52 +0100
Message-Id: <20211115165429.319322456@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ziyang Xuan <william.xuanziyang@huawei.com>

commit 15c9a359094ec6251578b02387436bc64f11a477 upstream.

When endpoint_alloc() return failed in xillyusb_setup_base_eps(),
'xdev->msg_ep' will be freed but not set to NULL. That lets program
enter fail handling to cleanup_dev() in xillyusb_probe(). Check for
'xdev->msg_ep' is invalid in cleanup_dev() because 'xdev->msg_ep' did
not set to NULL when was freed. So the UAF problem for 'xdev->msg_ep'
is triggered.

==================================================================
BUG: KASAN: use-after-free in fifo_mem_release+0x1f4/0x210
CPU: 0 PID: 166 Comm: kworker/0:2 Not tainted 5.15.0-rc5+ #19
Call Trace:
 dump_stack_lvl+0xe2/0x152
 print_address_description.constprop.0+0x21/0x140
 ? fifo_mem_release+0x1f4/0x210
 kasan_report.cold+0x7f/0x11b
 ? xillyusb_probe+0x530/0x700
 ? fifo_mem_release+0x1f4/0x210
 fifo_mem_release+0x1f4/0x210
 ? __sanitizer_cov_trace_pc+0x1d/0x50
 endpoint_dealloc+0x35/0x2b0
 cleanup_dev+0x90/0x120
 xillyusb_probe+0x59a/0x700
...

Freed by task 166:
 kasan_save_stack+0x1b/0x40
 kasan_set_track+0x1c/0x30
 kasan_set_free_info+0x20/0x30
 __kasan_slab_free+0x109/0x140
 kfree+0x117/0x4c0
 xillyusb_probe+0x606/0x700

Set 'xdev->msg_ep' to NULL after being freed in xillyusb_setup_base_eps()
to fix the UAF problem.

Fixes: a53d1202aef1 ("char: xillybus: Add driver for XillyUSB (Xillybus variant for USB)")
Cc: stable <stable@vger.kernel.org>
Acked-by: Eli Billauer <eli.billauer@gmail.com>
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Link: https://lore.kernel.org/r/20211016052047.1611983-1-william.xuanziyang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/xillybus/xillyusb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/char/xillybus/xillyusb.c
+++ b/drivers/char/xillybus/xillyusb.c
@@ -1912,6 +1912,7 @@ static int xillyusb_setup_base_eps(struc
 
 dealloc:
 	endpoint_dealloc(xdev->msg_ep); /* Also frees FIFO mem if allocated */
+	xdev->msg_ep = NULL;
 	return -ENOMEM;
 }
 


