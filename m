Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34D24627FBB
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:01:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237755AbiKNNBp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:01:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237714AbiKNNB2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:01:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF3CD2649C
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:01:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 43ABE61154
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:01:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4318DC433C1;
        Mon, 14 Nov 2022 13:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430886;
        bh=LL6R9MZKMOv42M6U/4vXFjqv6DSOfAqVxX8klZJ0F98=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SxTT7Ql3TBwFN39IP6f9f3Kt0TW7uCiPoZYiI11NhPF/lBu7VTtvJ2sWg5S7Hm/HU
         2pqSH7xf26ioK4gdvGeaS1YXn5H2EMTw5xkvFXjRvsgvimDbJ0qCpQOuZ+Xln06X+X
         8AIyuvQY4xpl6580hwx1lE6SuSZz6t+zfEpxGsek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+c6e8fca81c294fd5620a@syzkaller.appspotmail.com,
        Zhengchao Shao <shaozhengchao@huawei.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 025/190] wifi: mac80211: fix general-protection-fault in ieee80211_subif_start_xmit()
Date:   Mon, 14 Nov 2022 13:44:09 +0100
Message-Id: <20221114124459.860846745@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
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

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit 780854186946e0de2be192ee7fa5125666533b3a ]

When device is running and the interface status is changed, the gpf issue
is triggered. The problem triggering process is as follows:
Thread A:                           Thread B
ieee80211_runtime_change_iftype()   process_one_work()
    ...                                 ...
    ieee80211_do_stop()                 ...
    ...                                 ...
        sdata->bss = NULL               ...
        ...                             ieee80211_subif_start_xmit()
                                            ieee80211_multicast_to_unicast
                                    //!sdata->bss->multicast_to_unicast
                                      cause gpf issue

When the interface status is changed, the sending queue continues to send
packets. After the bss is set to NULL, the bss is accessed. As a result,
this causes a general-protection-fault issue.

The following is the stack information:
general protection fault, probably for non-canonical address
0xdffffc000000002f: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000178-0x000000000000017f]
Workqueue: mld mld_ifc_work
RIP: 0010:ieee80211_subif_start_xmit+0x25b/0x1310
Call Trace:
<TASK>
dev_hard_start_xmit+0x1be/0x990
__dev_queue_xmit+0x2c9a/0x3b60
ip6_finish_output2+0xf92/0x1520
ip6_finish_output+0x6af/0x11e0
ip6_output+0x1ed/0x540
mld_sendpack+0xa09/0xe70
mld_ifc_work+0x71c/0xdb0
process_one_work+0x9bf/0x1710
worker_thread+0x665/0x1080
kthread+0x2e4/0x3a0
ret_from_fork+0x1f/0x30
</TASK>

Fixes: f856373e2f31 ("wifi: mac80211: do not wake queues on a vif that is being stopped")
Reported-by: syzbot+c6e8fca81c294fd5620a@syzkaller.appspotmail.com
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Link: https://lore.kernel.org/r/20221026063959.177813-1-shaozhengchao@huawei.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 13249e97a069..d2c4f9226f94 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4379,6 +4379,11 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 	if (likely(!is_multicast_ether_addr(eth->h_dest)))
 		goto normal;
 
+	if (unlikely(!ieee80211_sdata_running(sdata))) {
+		kfree_skb(skb);
+		return NETDEV_TX_OK;
+	}
+
 	if (unlikely(ieee80211_multicast_to_unicast(skb, dev))) {
 		struct sk_buff_head queue;
 
-- 
2.35.1



