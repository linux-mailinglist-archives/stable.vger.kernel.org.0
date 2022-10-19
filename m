Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3804D604112
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 12:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231683AbiJSKhL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 06:37:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231671AbiJSKgk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 06:36:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89CB0167D1;
        Wed, 19 Oct 2022 03:15:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3503B823AD;
        Wed, 19 Oct 2022 08:52:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3251CC433C1;
        Wed, 19 Oct 2022 08:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169543;
        bh=84VswrwwfjQvWqlHGuaNrTFLiXO7xcJlvXZBgToTAdI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ns+QLlvZijcrn6u4w8H1Sodzd2kb+ZALnJBZKizOakRDy5vK6xnb5L4l+ApTckLnQ
         yKXGRC/DXdBo7JnudAEdp9zcj1gUaKsN2xI9q32Nw2F6Z+i9PNQ8cNZqigJjNM+i4B
         FBOK/m6uJ/hRHcjHF6RndzioYZF7I6Rdw3VgjCFg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liu Jian <liujian56@huawei.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 317/862] skmsg: Schedule psock work if the cached skb exists on the psock
Date:   Wed, 19 Oct 2022 10:26:44 +0200
Message-Id: <20221019083304.026586017@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liu Jian <liujian56@huawei.com>

[ Upstream commit bec217197b412d74168c6a42fc0f76d0cc9cad00 ]

In sk_psock_backlog function, for ingress direction skb, if no new data
packet arrives after the skb is cached, the cached skb does not have a
chance to be added to the receive queue of psock. As a result, the cached
skb cannot be received by the upper-layer application. Fix this by reschedule
the psock work to dispose the cached skb in sk_msg_recvmsg function.

Fixes: 604326b41a6f ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: Liu Jian <liujian56@huawei.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/bpf/20220907071311.60534-1-liujian56@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skmsg.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 188f8558d27d..ca70525621c7 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -434,8 +434,10 @@ int sk_msg_recvmsg(struct sock *sk, struct sk_psock *psock, struct msghdr *msg,
 			if (copied + copy > len)
 				copy = len - copied;
 			copy = copy_page_to_iter(page, sge->offset, copy, iter);
-			if (!copy)
-				return copied ? copied : -EFAULT;
+			if (!copy) {
+				copied = copied ? copied : -EFAULT;
+				goto out;
+			}
 
 			copied += copy;
 			if (likely(!peek)) {
@@ -455,7 +457,7 @@ int sk_msg_recvmsg(struct sock *sk, struct sk_psock *psock, struct msghdr *msg,
 				 * didn't copy the entire length lets just break.
 				 */
 				if (copy != sge->length)
-					return copied;
+					goto out;
 				sk_msg_iter_var_next(i);
 			}
 
@@ -477,7 +479,9 @@ int sk_msg_recvmsg(struct sock *sk, struct sk_psock *psock, struct msghdr *msg,
 		}
 		msg_rx = sk_psock_peek_msg(psock);
 	}
-
+out:
+	if (psock->work_state.skb && copied > 0)
+		schedule_work(&psock->work);
 	return copied;
 }
 EXPORT_SYMBOL_GPL(sk_msg_recvmsg);
-- 
2.35.1



