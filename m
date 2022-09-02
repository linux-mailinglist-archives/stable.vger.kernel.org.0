Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EFB15AB3AB
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 16:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236014AbiIBOcv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 10:32:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237072AbiIBOav (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 10:30:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96392201A4;
        Fri,  2 Sep 2022 06:55:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74FA4B82AAC;
        Fri,  2 Sep 2022 12:39:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9DEEC433D6;
        Fri,  2 Sep 2022 12:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662122339;
        bh=grrOAlYIZGyqwrMbbVHIL1tatlu+W0H81mTS44QmifQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x4j+pr9lj3Yfi8s83ixAKCgJNvqnhYeBJYPxRivY8nzH7NVYonq16nv78Zn5pe+hc
         fZf2jyH96iy9GuNZFA593plCxMf5dWiJyXh6TviValFNr+7agDIPgl/ZWUCLuwFrhr
         J6nUrRgcCmA/dW/Wd5HBfYzosdQ8/dJZDB38u+Bw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+7a12909485b94426aceb@syzkaller.appspotmail.com,
        Zhengchao Shao <shaozhengchao@huawei.com>,
        Stanislav Fomichev <sdf@google.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.10 16/37] bpf: Dont redirect packets with invalid pkt_len
Date:   Fri,  2 Sep 2022 14:19:38 +0200
Message-Id: <20220902121359.686245488@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121359.177846782@linuxfoundation.org>
References: <20220902121359.177846782@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhengchao Shao <shaozhengchao@huawei.com>

commit fd1894224407c484f652ad456e1ce423e89bb3eb upstream.

Syzbot found an issue [1]: fq_codel_drop() try to drop a flow whitout any
skbs, that is, the flow->head is null.
The root cause, as the [2] says, is because that bpf_prog_test_run_skb()
run a bpf prog which redirects empty skbs.
So we should determine whether the length of the packet modified by bpf
prog or others like bpf_prog_test is valid before forwarding it directly.

LINK: [1] https://syzkaller.appspot.com/bug?id=0b84da80c2917757915afa89f7738a9d16ec96c5
LINK: [2] https://www.spinics.net/lists/netdev/msg777503.html

Reported-by: syzbot+7a12909485b94426aceb@syzkaller.appspotmail.com
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Reviewed-by: Stanislav Fomichev <sdf@google.com>
Link: https://lore.kernel.org/r/20220715115559.139691-1-shaozhengchao@huawei.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/skbuff.h |    8 ++++++++
 net/bpf/test_run.c     |    3 +++
 net/core/dev.c         |    1 +
 3 files changed, 12 insertions(+)

--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2222,6 +2222,14 @@ static inline void skb_set_tail_pointer(
 
 #endif /* NET_SKBUFF_DATA_USES_OFFSET */
 
+static inline void skb_assert_len(struct sk_buff *skb)
+{
+#ifdef CONFIG_DEBUG_NET
+	if (WARN_ONCE(!skb->len, "%s\n", __func__))
+		DO_ONCE_LITE(skb_dump, KERN_ERR, skb, false);
+#endif /* CONFIG_DEBUG_NET */
+}
+
 /*
  *	Add data to an sk_buff
  */
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -441,6 +441,9 @@ static int convert___skb_to_skb(struct s
 {
 	struct qdisc_skb_cb *cb = (struct qdisc_skb_cb *)skb->cb;
 
+	if (!skb->len)
+		return -EINVAL;
+
 	if (!__skb)
 		return 0;
 
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4097,6 +4097,7 @@ static int __dev_queue_xmit(struct sk_bu
 	bool again = false;
 
 	skb_reset_mac_header(skb);
+	skb_assert_len(skb);
 
 	if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_SCHED_TSTAMP))
 		__skb_tstamp_tx(skb, NULL, skb->sk, SCM_TSTAMP_SCHED);


