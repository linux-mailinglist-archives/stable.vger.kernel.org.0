Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 542024F39F0
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378897AbiDELjl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:39:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354200AbiDEKMP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:12:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0DFE54182;
        Tue,  5 Apr 2022 02:58:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 79944B817D3;
        Tue,  5 Apr 2022 09:58:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E39A2C385A1;
        Tue,  5 Apr 2022 09:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152713;
        bh=+I1kIkWfWuQyDHUH07N7TM2+SinRMRMesn+il5ED1Oo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1O1tsJTAogyfBZ1rbX7Q9SBJU0k6b+2r4o4l1IqYK3bOGcThvxdyT4Xa0F9EuUbw7
         P9wPha+fadGwaSqdF48/4rzEabQsRoOvMkXhP4lOTcQMqDKkVKBuaGiKFFvgtW3WHA
         q5Ik+sZTOOqBHQheTyM8zJWjMGHlXQq4kdM4AdWE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 877/913] af_unix: Support POLLPRI for OOB.
Date:   Tue,  5 Apr 2022 09:32:19 +0200
Message-Id: <20220405070406.111282097@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Kuniyuki Iwashima <kuniyu@amazon.co.jp>

commit d9a232d435dcc966738b0f414a86f7edf4f4c8c4 upstream.

The commit 314001f0bf92 ("af_unix: Add OOB support") introduced OOB for
AF_UNIX, but it lacks some changes for POLLPRI.  Let's add the missing
piece.

In the selftest, normal datagrams are sent followed by OOB data, so this
commit replaces `POLLIN | POLLPRI` with just `POLLPRI` in the first test
case.

Fixes: 314001f0bf92 ("af_unix: Add OOB support")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/unix/af_unix.c                                  |    4 ++++
 tools/testing/selftests/net/af_unix/test_unix_oob.c |    6 +++---
 2 files changed, 7 insertions(+), 3 deletions(-)

--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -3049,6 +3049,10 @@ static __poll_t unix_poll(struct file *f
 		mask |= EPOLLIN | EPOLLRDNORM;
 	if (sk_is_readable(sk))
 		mask |= EPOLLIN | EPOLLRDNORM;
+#if IS_ENABLED(CONFIG_AF_UNIX_OOB)
+	if (READ_ONCE(unix_sk(sk)->oob_skb))
+		mask |= EPOLLPRI;
+#endif
 
 	/* Connection-based need to check for termination and startup */
 	if ((sk->sk_type == SOCK_STREAM || sk->sk_type == SOCK_SEQPACKET) &&
--- a/tools/testing/selftests/net/af_unix/test_unix_oob.c
+++ b/tools/testing/selftests/net/af_unix/test_unix_oob.c
@@ -218,10 +218,10 @@ main(int argc, char **argv)
 
 	/* Test 1:
 	 * veriyf that SIGURG is
-	 * delivered and 63 bytes are
-	 * read and oob is '@'
+	 * delivered, 63 bytes are
+	 * read, oob is '@', and POLLPRI works.
 	 */
-	wait_for_data(pfd, POLLIN | POLLPRI);
+	wait_for_data(pfd, POLLPRI);
 	read_oob(pfd, &oob);
 	len = read_data(pfd, buf, 1024);
 	if (!signal_recvd || len != 63 || oob != '@') {


