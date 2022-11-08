Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1166262152D
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:09:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235043AbiKHOJF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:09:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235133AbiKHOJE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:09:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3FC562D6
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:09:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7B028B81B00
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:09:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D00C2C433D6;
        Tue,  8 Nov 2022 14:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916541;
        bh=lorqxkb89nuj3ff/MaAeN8ixP6aGWYnS2ylBt4qNbUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B3FKhVcCJRUirJHaFg8XgN1nAWfPzvDyHJyk+w8x4OdZKseE5trJjBneurc2I/YrB
         n4uHN5YG6oR0MFVRBh6crDZK33Iq6hYU9eZT3PVIztKLgaWcH6zr8ISOXc6k1qNA4H
         B6mxq5febS0LxylvTZeb5axZ+yjBgNJByrOZT/38=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hawkins Jiawei <yin31149@gmail.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+8f819e36e01022991cfa@syzkaller.appspotmail.com
Subject: [PATCH 6.0 053/197] Bluetooth: L2CAP: Fix memory leak in vhci_write
Date:   Tue,  8 Nov 2022 14:38:11 +0100
Message-Id: <20221108133357.230636521@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hawkins Jiawei <yin31149@gmail.com>

[ Upstream commit 7c9524d929648935bac2bbb4c20437df8f9c3f42 ]

Syzkaller reports a memory leak as follows:
====================================
BUG: memory leak
unreferenced object 0xffff88810d81ac00 (size 240):
  [...]
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff838733d9>] __alloc_skb+0x1f9/0x270 net/core/skbuff.c:418
    [<ffffffff833f742f>] alloc_skb include/linux/skbuff.h:1257 [inline]
    [<ffffffff833f742f>] bt_skb_alloc include/net/bluetooth/bluetooth.h:469 [inline]
    [<ffffffff833f742f>] vhci_get_user drivers/bluetooth/hci_vhci.c:391 [inline]
    [<ffffffff833f742f>] vhci_write+0x5f/0x230 drivers/bluetooth/hci_vhci.c:511
    [<ffffffff815e398d>] call_write_iter include/linux/fs.h:2192 [inline]
    [<ffffffff815e398d>] new_sync_write fs/read_write.c:491 [inline]
    [<ffffffff815e398d>] vfs_write+0x42d/0x540 fs/read_write.c:578
    [<ffffffff815e3cdd>] ksys_write+0x9d/0x160 fs/read_write.c:631
    [<ffffffff845e0645>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
    [<ffffffff845e0645>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
    [<ffffffff84600087>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
====================================

HCI core will uses hci_rx_work() to process frame, which is queued to
the hdev->rx_q tail in hci_recv_frame() by HCI driver.

Yet the problem is that, HCI core may not free the skb after handling
ACL data packets. To be more specific, when start fragment does not
contain the L2CAP length, HCI core just copies skb into conn->rx_skb and
finishes frame process in l2cap_recv_acldata(), without freeing the skb,
which triggers the above memory leak.

This patch solves it by releasing the relative skb, after processing
the above case in l2cap_recv_acldata().

Fixes: 4d7ea8ee90e4 ("Bluetooth: L2CAP: Fix handling fragmented length")
Link: https://lore.kernel.org/all/0000000000000d0b1905e6aaef64@google.com/
Reported-and-tested-by: syzbot+8f819e36e01022991cfa@syzkaller.appspotmail.com
Signed-off-by: Hawkins Jiawei <yin31149@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 9a32ce634919..1fbe087d6ae4 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -8461,9 +8461,8 @@ void l2cap_recv_acldata(struct hci_conn *hcon, struct sk_buff *skb, u16 flags)
 		 * expected length.
 		 */
 		if (skb->len < L2CAP_LEN_SIZE) {
-			if (l2cap_recv_frag(conn, skb, conn->mtu) < 0)
-				goto drop;
-			return;
+			l2cap_recv_frag(conn, skb, conn->mtu);
+			break;
 		}
 
 		len = get_unaligned_le16(skb->data) + L2CAP_HDR_SIZE;
@@ -8507,7 +8506,7 @@ void l2cap_recv_acldata(struct hci_conn *hcon, struct sk_buff *skb, u16 flags)
 
 			/* Header still could not be read just continue */
 			if (conn->rx_skb->len < L2CAP_LEN_SIZE)
-				return;
+				break;
 		}
 
 		if (skb->len > conn->rx_len) {
-- 
2.35.1



