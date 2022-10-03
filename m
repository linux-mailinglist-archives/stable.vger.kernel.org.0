Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7C735F2934
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbiJCHPx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:15:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbiJCHPB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:15:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BFBE4456D;
        Mon,  3 Oct 2022 00:13:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 84E6C60F9D;
        Mon,  3 Oct 2022 07:13:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95928C433C1;
        Mon,  3 Oct 2022 07:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781192;
        bh=oI7WoSRs0qWoU3rqb4Lgv2/KUIFnQrRNqyd6f56F2ks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oZkzG+JIWEDQliKN1FtSslAc8U7Vlal6xodrsct6PL71uLn3sQhLKeYWNkkLyaA5c
         EaBlTVRyL3A4wSOXk30sYX9xfdf6v2qRVWiDP1c+/UUbymqlGjXivK4E9fimA2uF1Z
         50WAJItwoc353pe9X7QND3aFzsLcH2JRbNCkDkvU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiang Biao <benbjiang@tencent.com>,
        Mengen Sun <mengensun@tencent.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Menglong Dong <imagedong@tencent.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.19 031/101] mptcp: factor out __mptcp_close() without socket lock
Date:   Mon,  3 Oct 2022 09:10:27 +0200
Message-Id: <20221003070725.245896745@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070724.490989164@linuxfoundation.org>
References: <20221003070724.490989164@linuxfoundation.org>
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

From: Menglong Dong <imagedong@tencent.com>

commit 26d3e21ce1aab6cb19069c510fac8e7474445b18 upstream.

Factor out __mptcp_close() from mptcp_close(). The caller of
__mptcp_close() should hold the socket lock, and cancel mptcp work when
__mptcp_close() returns true.

This function will be used in the next commit.

Fixes: f296234c98a8 ("mptcp: Add handling of incoming MP_JOIN requests")
Fixes: 6aeed9045071 ("mptcp: fix race on unaccepted mptcp sockets")
Cc: stable@vger.kernel.org
Reviewed-by: Jiang Biao <benbjiang@tencent.com>
Reviewed-by: Mengen Sun <mengensun@tencent.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Menglong Dong <imagedong@tencent.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |   14 ++++++++++++--
 net/mptcp/protocol.h |    1 +
 2 files changed, 13 insertions(+), 2 deletions(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2832,13 +2832,12 @@ static void __mptcp_destroy_sock(struct
 	sock_put(sk);
 }
 
-static void mptcp_close(struct sock *sk, long timeout)
+bool __mptcp_close(struct sock *sk, long timeout)
 {
 	struct mptcp_subflow_context *subflow;
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	bool do_cancel_work = false;
 
-	lock_sock(sk);
 	sk->sk_shutdown = SHUTDOWN_MASK;
 
 	if ((1 << sk->sk_state) & (TCPF_LISTEN | TCPF_CLOSE)) {
@@ -2880,6 +2879,17 @@ cleanup:
 	} else {
 		mptcp_reset_timeout(msk, 0);
 	}
+
+	return do_cancel_work;
+}
+
+static void mptcp_close(struct sock *sk, long timeout)
+{
+	bool do_cancel_work;
+
+	lock_sock(sk);
+
+	do_cancel_work = __mptcp_close(sk, timeout);
 	release_sock(sk);
 	if (do_cancel_work)
 		mptcp_cancel_work(sk);
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -613,6 +613,7 @@ void mptcp_subflow_reset(struct sock *ss
 void mptcp_subflow_queue_clean(struct sock *ssk);
 void mptcp_sock_graft(struct sock *sk, struct socket *parent);
 struct socket *__mptcp_nmpc_socket(const struct mptcp_sock *msk);
+bool __mptcp_close(struct sock *sk, long timeout);
 
 bool mptcp_addresses_equal(const struct mptcp_addr_info *a,
 			   const struct mptcp_addr_info *b, bool use_port);


