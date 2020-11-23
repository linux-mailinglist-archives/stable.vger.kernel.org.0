Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57AF52C0B0B
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:55:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731807AbgKWMgs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:36:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:48794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731734AbgKWMgl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:36:41 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 436CD208DB;
        Mon, 23 Nov 2020 12:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135000;
        bh=NJM/xv7ajV6T3lJmtrIFBLU9THVHK/5+yjuVa9HCo7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ujEkbBNIVjds8qVq60mbkKondEaZAWX9oG7A0Yt3ylq7JokMcggMBvF7QC3XlVxQw
         2B1s4oUZ1BBsNf6NeZz/20tUCIOxSVZ60V4TlaAvfMv9LBJ/nwhJ2LtpMF0jFUseBq
         V1JaiJjUxhBtm9kGUJuQ5TEK4F13P302RdOM9Fcg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Claire Chang <tientzu@chromium.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 069/158] rfkill: Fix use-after-free in rfkill_resume()
Date:   Mon, 23 Nov 2020 13:21:37 +0100
Message-Id: <20201123121823.264864165@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121819.943135899@linuxfoundation.org>
References: <20201123121819.943135899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claire Chang <tientzu@chromium.org>

[ Upstream commit 94e2bd0b259ed39a755fdded47e6734acf1ce464 ]

If a device is getting removed or reprobed during resume, use-after-free
might happen. For example, h5_btrtl_resume() schedules a work queue for
device reprobing, which of course requires removal first.

If the removal happens in parallel with the device_resume() and wins the
race to acquire device_lock(), removal may remove the device from the PM
lists and all, but device_resume() is already running and will continue
when the lock can be acquired, thus calling rfkill_resume().

During this, if rfkill_set_block() is then called after the corresponding
*_unregister() and kfree() are called, there will be an use-after-free
in hci_rfkill_set_block():

BUG: KASAN: use-after-free in hci_rfkill_set_block+0x58/0xc0 [bluetooth]
...
Call trace:
  dump_backtrace+0x0/0x154
  show_stack+0x20/0x2c
  dump_stack+0xbc/0x12c
  print_address_description+0x88/0x4b0
  __kasan_report+0x144/0x168
  kasan_report+0x10/0x18
  check_memory_region+0x19c/0x1ac
  __kasan_check_write+0x18/0x24
  hci_rfkill_set_block+0x58/0xc0 [bluetooth]
  rfkill_set_block+0x9c/0x120
  rfkill_resume+0x34/0x70
  dpm_run_callback+0xf0/0x1f4
  device_resume+0x210/0x22c

Fix this by checking rfkill->registered in rfkill_resume(). device_del()
in rfkill_unregister() requires device_lock() and the whole rfkill_resume()
is also protected by the same lock via device_resume(), we can make sure
either the rfkill->registered is false before rfkill_resume() starts or the
rfkill device won't be unregistered before rfkill_resume() returns.

As async_resume() holds a reference to the device, at this level there can
be no use-after-free; only in the user that doesn't expect this scenario.

Fixes: 8589086f4efd ("Bluetooth: hci_h5: Turn off RTL8723BS on suspend, reprobe on resume")
Signed-off-by: Claire Chang <tientzu@chromium.org>
Link: https://lore.kernel.org/r/20201110084908.219088-1-tientzu@chromium.org
[edit commit message for clarity and add more info provided later]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rfkill/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/rfkill/core.c b/net/rfkill/core.c
index 6c089320ae4f1..5bba7c36ac74f 100644
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -876,6 +876,9 @@ static int rfkill_resume(struct device *dev)
 
 	rfkill->suspended = false;
 
+	if (!rfkill->registered)
+		return 0;
+
 	if (!rfkill->persistent) {
 		cur = !!(rfkill->state & RFKILL_BLOCK_SW);
 		rfkill_set_block(rfkill, cur);
-- 
2.27.0



