Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78C2D58DDA7
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 20:03:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245711AbiHISDn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 14:03:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237606AbiHISDG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 14:03:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC5192657F;
        Tue,  9 Aug 2022 11:01:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 691E761028;
        Tue,  9 Aug 2022 18:01:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D152FC433D7;
        Tue,  9 Aug 2022 18:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660068105;
        bh=dqrGDBv5Fni7p4XMtiyBMCJpynKRI0h2aG7lpP0oGww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e6fDPR9eSVQI3NkgFkErcVaE+Tqg45g+FAUy8xaf6HY4FRDIVn10HF6CFDs1VGq4A
         yTN1+yuixNuSNacB0NeMwBI72cMqgwuzjmRW+oUBg3TKmfOyCoLqZWSdAss48NlqGz
         /UlfxEpSUQtEaqpRFks7GVM6jvxMSY9XeE56JF00=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 06/32] tcp: Fix a data-race around sysctl_tcp_adv_win_scale.
Date:   Tue,  9 Aug 2022 19:59:57 +0200
Message-Id: <20220809175513.293786850@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220809175513.082573955@linuxfoundation.org>
References: <20220809175513.082573955@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.com>

commit 36eeee75ef0157e42fb6593dcc65daab289b559e upstream.

While reading sysctl_tcp_adv_win_scale, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its reader.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/tcp.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1355,7 +1355,7 @@ void tcp_select_initial_window(const str
 
 static inline int tcp_win_from_space(const struct sock *sk, int space)
 {
-	int tcp_adv_win_scale = sock_net(sk)->ipv4.sysctl_tcp_adv_win_scale;
+	int tcp_adv_win_scale = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_adv_win_scale);
 
 	return tcp_adv_win_scale <= 0 ?
 		(space>>(-tcp_adv_win_scale)) :


