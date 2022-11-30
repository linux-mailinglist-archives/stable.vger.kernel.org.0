Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27F2663DEAA
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:39:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbiK3Sjc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:39:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230521AbiK3SjY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:39:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2D959701E
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:39:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 694E8B81C9C
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:39:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5DB1C433C1;
        Wed, 30 Nov 2022 18:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833560;
        bh=w6X6m7nbBQh0fdcY72VeFYIPyqxgox0B6TKZd7xtJV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cTdBCJqW572z1GM2tnMroYTUcIzJC1PKv5QDuVhYeWRRumiSQPqOKHo9XzD21vBcW
         Wp5GsorAgOQ2BpBfcFOuyVBcmQuuOFp3Xfkht8wZLZ5ogqsCT2TzEQg+Ko+AapMuAz
         qj3EkpCs6hZqn1QFikir1EZhLvTW9P5T9WWKLWcc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+cdb9a427d1bc08815104@syzkaller.appspotmail.com,
        Liu Shixin <liushixin2@huawei.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 113/206] NFC: nci: fix memory leak in nci_rx_data_packet()
Date:   Wed, 30 Nov 2022 19:22:45 +0100
Message-Id: <20221130180535.919210999@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
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
index aa5e712adf07..3d36ea5701f0 100644
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



