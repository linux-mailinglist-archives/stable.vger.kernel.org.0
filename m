Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B3916579AF
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:03:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233461AbiL1PDo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:03:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233460AbiL1PDn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:03:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E600E7D
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:03:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29530B816D9
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:03:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A387C433D2;
        Wed, 28 Dec 2022 15:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239819;
        bh=VDAPmCMjNCjArT8vN+NL3HvTe6znw5OGqw7YeJ6+ZLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bU9pwgLJHpL6o3dIlQ/3sk4DdQ7Fa7YE3tDrARmrb58DR7VLWScVAJMz4Z5xVsH6f
         A3Qe/Kh5fpwj7bmbZU6QCgev/d+fkjaddqFXeAw+dGMnxDuCPfzM8j9//1qIy3RQN2
         49RVmMRbc2VrsA7M+tTZnmel3UfOoPFwOXkx2Uqc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 274/731] hsr: Add a rcu-read lock to hsr_forward_skb().
Date:   Wed, 28 Dec 2022 15:36:21 +0100
Message-Id: <20221228144304.516959903@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 5aa2820177af650293b2f9f1873c1f6f8e4ad7a4 ]

hsr_forward_skb() a skb and keeps information in an on-stack
hsr_frame_info. hsr_get_node() assigns hsr_frame_info::node_src which is
from a RCU list. This pointer is used later in hsr_forward_do().
I don't see a reason why this pointer can't vanish midway since there is
no guarantee that hsr_forward_skb() is invoked from an RCU read section.

Use rcu_read_lock() to protect hsr_frame_info::node_src from its
assignment until it is no longer used.

Fixes: f266a683a4804 ("net/hsr: Better frame dispatch")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/hsr/hsr_forward.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
index 07892c4b6d0c..daf6abbadeb9 100644
--- a/net/hsr/hsr_forward.c
+++ b/net/hsr/hsr_forward.c
@@ -572,11 +572,13 @@ void hsr_forward_skb(struct sk_buff *skb, struct hsr_port *port)
 {
 	struct hsr_frame_info frame;
 
+	rcu_read_lock();
 	if (fill_frame_info(&frame, skb, port) < 0)
 		goto out_drop;
 
 	hsr_register_frame_in(frame.node_src, port, frame.sequence_nr);
 	hsr_forward_do(&frame);
+	rcu_read_unlock();
 	/* Gets called for ingress frames as well as egress from master port.
 	 * So check and increment stats for master port only here.
 	 */
@@ -591,6 +593,7 @@ void hsr_forward_skb(struct sk_buff *skb, struct hsr_port *port)
 	return;
 
 out_drop:
+	rcu_read_unlock();
 	port->dev->stats.tx_dropped++;
 	kfree_skb(skb);
 }
-- 
2.35.1



