Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAEDC58689F
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 13:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231622AbiHALvI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 07:51:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231934AbiHALul (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 07:50:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BD52402DC;
        Mon,  1 Aug 2022 04:49:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 90952612C5;
        Mon,  1 Aug 2022 11:49:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 994CEC433C1;
        Mon,  1 Aug 2022 11:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659354556;
        bh=bZ79vMwd6lZjbx+kr4CrkCQzjZarKgGBb2BuBwBdQ20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wttkDDwk9K0Eo70cW77PWIwqsNurDOyXvoNpVM7ZiEyX/tCg8rX7R1jYBTYWhK/xD
         Qp0YlvfpUTUs83u+6stc5acrAHLm9qBCDc+hjsHWLuRvbQ1J970p80j5btr19/WYP8
         pQ03QxWmc/cDennJF9FgJT317eqgny6fvlbNTQmo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 07/34] tcp: Fix a data-race around sysctl_tcp_frto.
Date:   Mon,  1 Aug 2022 13:46:47 +0200
Message-Id: <20220801114128.334090136@linuxfoundation.org>
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

commit 706c6202a3589f290e1ef9be0584a8f4a3cc0507 upstream.

While reading sysctl_tcp_frto, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its reader.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_input.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2030,7 +2030,7 @@ void tcp_enter_loss(struct sock *sk)
 	 * loss recovery is underway except recurring timeout(s) on
 	 * the same SND.UNA (sec 3.2). Disable F-RTO on path MTU probing
 	 */
-	tp->frto = net->ipv4.sysctl_tcp_frto &&
+	tp->frto = READ_ONCE(net->ipv4.sysctl_tcp_frto) &&
 		   (new_recovery || icsk->icsk_retransmits) &&
 		   !inet_csk(sk)->icsk_mtup.probe_size;
 }


