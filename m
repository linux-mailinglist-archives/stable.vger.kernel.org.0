Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0F596E63E2
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231919AbjDRMoH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:44:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231907AbjDRMoG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:44:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7158F19A6
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:44:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E910763371
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:44:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0606FC433D2;
        Tue, 18 Apr 2023 12:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821844;
        bh=gSl3TiatGp+t0OH5DFM93BUuo6xHWfhROJItxIlBKRU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nNRmSiAg3FFGpOBjb7Qjk6jn7nGlmLRyvcYgK+LnqAXoC5IKEcpm9mBC+jisMtKSZ
         KPcSnAyc0AzkQM581X39PsXx2NprEHw02Xequm1Q2kV5v9cmZ/CTbUNebWIKQf1e4R
         pQlvjqMxdha1F8KPIvZC6cUqjsxWckh0R+BUZgl8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+4436c9630a45820fda76@syzkaller.appspotmail.com,
        Manivannan Sadhasivam <mani@kernel.org>,
        Ziyang Xuan <william.xuanziyang@huawei.com>,
        Simon Horman <simon.horman@corigine.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 062/134] net: qrtr: Fix an uninit variable access bug in qrtr_tx_resume()
Date:   Tue, 18 Apr 2023 14:21:58 +0200
Message-Id: <20230418120315.124698772@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
References: <20230418120313.001025904@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ziyang Xuan <william.xuanziyang@huawei.com>

[ Upstream commit 6417070918de3bcdbe0646e7256dae58fd8083ba ]

Syzbot reported a bug as following:

=====================================================
BUG: KMSAN: uninit-value in qrtr_tx_resume+0x185/0x1f0 net/qrtr/af_qrtr.c:230
 qrtr_tx_resume+0x185/0x1f0 net/qrtr/af_qrtr.c:230
 qrtr_endpoint_post+0xf85/0x11b0 net/qrtr/af_qrtr.c:519
 qrtr_tun_write_iter+0x270/0x400 net/qrtr/tun.c:108
 call_write_iter include/linux/fs.h:2189 [inline]
 aio_write+0x63a/0x950 fs/aio.c:1600
 io_submit_one+0x1d1c/0x3bf0 fs/aio.c:2019
 __do_sys_io_submit fs/aio.c:2078 [inline]
 __se_sys_io_submit+0x293/0x770 fs/aio.c:2048
 __x64_sys_io_submit+0x92/0xd0 fs/aio.c:2048
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Uninit was created at:
 slab_post_alloc_hook mm/slab.h:766 [inline]
 slab_alloc_node mm/slub.c:3452 [inline]
 __kmem_cache_alloc_node+0x71f/0xce0 mm/slub.c:3491
 __do_kmalloc_node mm/slab_common.c:967 [inline]
 __kmalloc_node_track_caller+0x114/0x3b0 mm/slab_common.c:988
 kmalloc_reserve net/core/skbuff.c:492 [inline]
 __alloc_skb+0x3af/0x8f0 net/core/skbuff.c:565
 __netdev_alloc_skb+0x120/0x7d0 net/core/skbuff.c:630
 qrtr_endpoint_post+0xbd/0x11b0 net/qrtr/af_qrtr.c:446
 qrtr_tun_write_iter+0x270/0x400 net/qrtr/tun.c:108
 call_write_iter include/linux/fs.h:2189 [inline]
 aio_write+0x63a/0x950 fs/aio.c:1600
 io_submit_one+0x1d1c/0x3bf0 fs/aio.c:2019
 __do_sys_io_submit fs/aio.c:2078 [inline]
 __se_sys_io_submit+0x293/0x770 fs/aio.c:2048
 __x64_sys_io_submit+0x92/0xd0 fs/aio.c:2048
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

It is because that skb->len requires at least sizeof(struct qrtr_ctrl_pkt)
in qrtr_tx_resume(). And skb->len equals to size in qrtr_endpoint_post().
But size is less than sizeof(struct qrtr_ctrl_pkt) when qrtr_cb->type
equals to QRTR_TYPE_RESUME_TX in qrtr_endpoint_post() under the syzbot
scenario. This triggers the uninit variable access bug.

Add size check when qrtr_cb->type equals to QRTR_TYPE_RESUME_TX in
qrtr_endpoint_post() to fix the bug.

Fixes: 5fdeb0d372ab ("net: qrtr: Implement outgoing flow control")
Reported-by: syzbot+4436c9630a45820fda76@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?id=c14607f0963d27d5a3d5f4c8639b500909e43540
Suggested-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Link: https://lore.kernel.org/r/20230410012352.3997823-1-william.xuanziyang@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/qrtr/af_qrtr.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/qrtr/af_qrtr.c b/net/qrtr/af_qrtr.c
index 3a70255c8d02f..76f0434d3d06a 100644
--- a/net/qrtr/af_qrtr.c
+++ b/net/qrtr/af_qrtr.c
@@ -498,6 +498,11 @@ int qrtr_endpoint_post(struct qrtr_endpoint *ep, const void *data, size_t len)
 	if (!size || len != ALIGN(size, 4) + hdrlen)
 		goto err;
 
+	if ((cb->type == QRTR_TYPE_NEW_SERVER ||
+	     cb->type == QRTR_TYPE_RESUME_TX) &&
+	    size < sizeof(struct qrtr_ctrl_pkt))
+		goto err;
+
 	if (cb->dst_port != QRTR_PORT_CTRL && cb->type != QRTR_TYPE_DATA &&
 	    cb->type != QRTR_TYPE_RESUME_TX)
 		goto err;
@@ -510,9 +515,6 @@ int qrtr_endpoint_post(struct qrtr_endpoint *ep, const void *data, size_t len)
 		/* Remote node endpoint can bridge other distant nodes */
 		const struct qrtr_ctrl_pkt *pkt;
 
-		if (size < sizeof(*pkt))
-			goto err;
-
 		pkt = data + hdrlen;
 		qrtr_node_assign(node, le32_to_cpu(pkt->server.node));
 	}
-- 
2.39.2



