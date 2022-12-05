Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1A08643429
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:42:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234980AbiLETmq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:42:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235015AbiLETmC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:42:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BE5C2723
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:39:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E808661309
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:39:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08BAFC433D6;
        Mon,  5 Dec 2022 19:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670269185;
        bh=zhAZuG5onqBLrwOJxbrAd8JCzbn2CUUeCCZi5YKVDAA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=erPZlJQztkLVNPQrjyuvaCYyy+ULPmA6wA7Z5v3r/58ALcReWKRaKwPBPIMiPxppO
         g3LCFE40XLClRxM49p0SiKaSWTgqnRaDIktmLhcGm6R7WlIoehUorbdxbL4iXEjv7V
         ZGo0aWMAd6jfhm+O7IKYw7EAblXpgbOG0aLKo9Qk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+cdb9a427d1bc08815104@syzkaller.appspotmail.com,
        Liu Shixin <liushixin2@huawei.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 035/153] NFC: nci: fix memory leak in nci_rx_data_packet()
Date:   Mon,  5 Dec 2022 20:09:19 +0100
Message-Id: <20221205190809.735686447@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.733996403@linuxfoundation.org>
References: <20221205190808.733996403@linuxfoundation.org>
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

From: Liu Shixin <liushixin2@huawei.com>

[ Upstream commit 53270fb0fd77fe786d8c07a0793981d797836b93 ]

Syzbot reported a memory leak about skb:

unreferenced object 0xffff88810e144e00 (size 240):
  comm "syz-executor284", pid 3701, jiffies 4294952403 (age 12.620s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff83ab79a9>] __alloc_skb+0x1f9/0x270 net/core/skbuff.c:497
    [<ffffffff82a5cf64>] alloc_skb include/linux/skbuff.h:1267 [inline]
    [<ffffffff82a5cf64>] virtual_ncidev_write+0x24/0xe0 drivers/nfc/virtual_ncidev.c:116
    [<ffffffff815f6503>] do_loop_readv_writev fs/read_write.c:759 [inline]
    [<ffffffff815f6503>] do_loop_readv_writev fs/read_write.c:743 [inline]
    [<ffffffff815f6503>] do_iter_write+0x253/0x300 fs/read_write.c:863
    [<ffffffff815f66ed>] vfs_writev+0xdd/0x240 fs/read_write.c:934
    [<ffffffff815f68f6>] do_writev+0xa6/0x1c0 fs/read_write.c:977
    [<ffffffff848802d5>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
    [<ffffffff848802d5>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
    [<ffffffff84a00087>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

In nci_rx_data_packet(), if we don't get a valid conn_info, we will return
directly but forget to release the skb.

Reported-by: syzbot+cdb9a427d1bc08815104@syzkaller.appspotmail.com
Fixes: 4aeee6871e8c ("NFC: nci: Add dynamic logical connections support")
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Link: https://lore.kernel.org/r/20221118082419.239475-1-liushixin2@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/nfc/nci/data.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/nfc/nci/data.c b/net/nfc/nci/data.c
index b002e18f38c8..b4548d887489 100644
--- a/net/nfc/nci/data.c
+++ b/net/nfc/nci/data.c
@@ -279,8 +279,10 @@ void nci_rx_data_packet(struct nci_dev *ndev, struct sk_buff *skb)
 		 nci_plen(skb->data));
 
 	conn_info = nci_get_conn_info_by_conn_id(ndev, nci_conn_id(skb->data));
-	if (!conn_info)
+	if (!conn_info) {
+		kfree_skb(skb);
 		return;
+	}
 
 	/* strip the nci data header */
 	skb_pull(skb, NCI_DATA_HDR_SIZE);
-- 
2.35.1



