Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C3DF6BB1C3
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:30:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232596AbjCOMa3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:30:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232735AbjCOMaD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:30:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 338729DE1F
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:29:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2EAF2B81E00
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:29:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EC06C4339B;
        Wed, 15 Mar 2023 12:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883342;
        bh=vt3ByGGSCYlj0xr5Xz7hltlJxUUVLkLnmYrJGLFFpnw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bNgT1Q3WuQZ7BQQZY252uHOo83nqdldXlwQOzh1zFwjyuKCkSG37x4t5IsYwhTMfl
         CO0yCHhlTT815TikiZFjEP/AkbAAx7hbzbdMt+NK83HLgjwt5f2dkY37o4vICuuFL8
         iSUW34Y0W3s1AkAmHxBGabHHm9wagcSvxJZ2SDgs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 077/145] af_unix: Remove unnecessary brackets around CONFIG_AF_UNIX_OOB.
Date:   Wed, 15 Mar 2023 13:12:23 +0100
Message-Id: <20230315115741.547777892@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115738.951067403@linuxfoundation.org>
References: <20230315115738.951067403@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.co.jp>

[ Upstream commit 4edf21aa94ee33c75f819f2b6eb6dd52ef8a1628 ]

Let's remove unnecessary brackets around CONFIG_AF_UNIX_OOB.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Link: https://lore.kernel.org/r/20220317032308.65372-1-kuniyu@amazon.co.jp
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 2aab4b969002 ("af_unix: fix struct pid leaks in OOB support")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 0a59a00cb5815..32ddf8fe32c69 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1969,7 +1969,7 @@ static int unix_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
  */
 #define UNIX_SKB_FRAGS_SZ (PAGE_SIZE << get_order(32768))
 
-#if (IS_ENABLED(CONFIG_AF_UNIX_OOB))
+#if IS_ENABLED(CONFIG_AF_UNIX_OOB)
 static int queue_oob(struct socket *sock, struct msghdr *msg, struct sock *other)
 {
 	struct unix_sock *ousk = unix_sk(other);
@@ -2035,7 +2035,7 @@ static int unix_stream_sendmsg(struct socket *sock, struct msghdr *msg,
 
 	err = -EOPNOTSUPP;
 	if (msg->msg_flags & MSG_OOB) {
-#if (IS_ENABLED(CONFIG_AF_UNIX_OOB))
+#if IS_ENABLED(CONFIG_AF_UNIX_OOB)
 		if (len)
 			len--;
 		else
@@ -2106,7 +2106,7 @@ static int unix_stream_sendmsg(struct socket *sock, struct msghdr *msg,
 		sent += size;
 	}
 
-#if (IS_ENABLED(CONFIG_AF_UNIX_OOB))
+#if IS_ENABLED(CONFIG_AF_UNIX_OOB)
 	if (msg->msg_flags & MSG_OOB) {
 		err = queue_oob(sock, msg, other);
 		if (err)
-- 
2.39.2



