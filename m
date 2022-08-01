Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2715758689A
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 13:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbiHALvC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 07:51:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231446AbiHALue (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 07:50:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B20A73AE47;
        Mon,  1 Aug 2022 04:49:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D982B612C6;
        Mon,  1 Aug 2022 11:49:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4D69C433C1;
        Mon,  1 Aug 2022 11:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659354553;
        bh=LIcRHKYKYlzajg/YMOhVk1Ufpco9mjpW0QZrPm6QgCA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2i5j0mPavSthhlaoNalmxQjvvgO5qfKi3MfbmAiR2C7Rl/6NYXRp3NoBeO2yomCHW
         /895wjX8WwezCiNnaQ5ysnvJjGGKUNfX6H3Ra0+NxIt6/to6g0KQ7T3i4KIxExYwso
         HAAQhCwSDhA9JZL4L1xUT2rBrrBf+jipg8xKfEC8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 06/34] tcp: Fix a data-race around sysctl_tcp_adv_win_scale.
Date:   Mon,  1 Aug 2022 13:46:46 +0200
Message-Id: <20220801114128.304976802@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114128.025615151@linuxfoundation.org>
References: <20220801114128.025615151@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
@@ -1389,7 +1389,7 @@ void tcp_select_initial_window(const str
 
 static inline int tcp_win_from_space(const struct sock *sk, int space)
 {
-	int tcp_adv_win_scale = sock_net(sk)->ipv4.sysctl_tcp_adv_win_scale;
+	int tcp_adv_win_scale = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_adv_win_scale);
 
 	return tcp_adv_win_scale <= 0 ?
 		(space>>(-tcp_adv_win_scale)) :


