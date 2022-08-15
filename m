Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB40594FAB
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbiHPEbj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:31:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbiHPEbN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:31:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57B30164436;
        Mon, 15 Aug 2022 13:20:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7478D6106F;
        Mon, 15 Aug 2022 20:20:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C781C433C1;
        Mon, 15 Aug 2022 20:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594821;
        bh=O35wFFqh39gsj4H7AeSsF+t8oAXaVBPzARFRk7JtuG8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O5jofGKxy42moUoSo1gigrVnIqM5GfWStb1E0l0taSRazE/PbxVMmzr/OmGNiowYn
         3UJjiRWCi95/WjEH50i5PAOfWQLKVUbEH51OZuS3Bf+Qy/gPhncKWXBBwPj+NDgGlk
         v3PvhtuuvP9cDA4y4D1CTInuYJ9dmocFSrz9roYM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0569/1157] dccp: put dccp_qpolicy_full() and dccp_qpolicy_push() in the same lock
Date:   Mon, 15 Aug 2022 19:58:45 +0200
Message-Id: <20220815180502.381578729@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Hangyu Hua <hbh25y@gmail.com>

[ Upstream commit a41b17ff9dacd22f5f118ee53d82da0f3e52d5e3 ]

In the case of sk->dccps_qpolicy == DCCPQ_POLICY_PRIO, dccp_qpolicy_full
will drop a skb when qpolicy is full. And the lock in dccp_sendmsg is
released before sock_alloc_send_skb and then relocked after
sock_alloc_send_skb. The following conditions may lead dccp_qpolicy_push
to add skb to an already full sk_write_queue:

thread1--->lock
thread1--->dccp_qpolicy_full: queue is full. drop a skb
thread1--->unlock
thread2--->lock
thread2--->dccp_qpolicy_full: queue is not full. no need to drop.
thread2--->unlock
thread1--->lock
thread1--->dccp_qpolicy_push: add a skb. queue is full.
thread1--->unlock
thread2--->lock
thread2--->dccp_qpolicy_push: add a skb!
thread2--->unlock

Fix this by moving dccp_qpolicy_full.

Fixes: b1308dc015eb ("[DCCP]: Set TX Queue Length Bounds via Sysctl")
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
Link: https://lore.kernel.org/r/20220729110027.40569-1-hbh25y@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dccp/proto.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/dccp/proto.c b/net/dccp/proto.c
index eb8e128e43e8..e13641c65f88 100644
--- a/net/dccp/proto.c
+++ b/net/dccp/proto.c
@@ -736,11 +736,6 @@ int dccp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 
 	lock_sock(sk);
 
-	if (dccp_qpolicy_full(sk)) {
-		rc = -EAGAIN;
-		goto out_release;
-	}
-
 	timeo = sock_sndtimeo(sk, noblock);
 
 	/*
@@ -759,6 +754,11 @@ int dccp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	if (skb == NULL)
 		goto out_release;
 
+	if (dccp_qpolicy_full(sk)) {
+		rc = -EAGAIN;
+		goto out_discard;
+	}
+
 	if (sk->sk_state == DCCP_CLOSED) {
 		rc = -ENOTCONN;
 		goto out_discard;
-- 
2.35.1



