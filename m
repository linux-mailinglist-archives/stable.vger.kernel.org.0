Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC2A4E75E3
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 16:07:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359542AbiCYPIw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 11:08:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359577AbiCYPIh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 11:08:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62FDBD9E85;
        Fri, 25 Mar 2022 08:07:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C92EB828FA;
        Fri, 25 Mar 2022 15:07:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E329C36AF7;
        Fri, 25 Mar 2022 15:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648220818;
        bh=6rHfIW/WZwsrK5FT/DOL5y94ECAHBeYdakxc9xThW7A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z3Vk7Byk39g74SxqLXUDZGp6GUeWbNXi7DK5mMqggrcdHpCa2deDkWYzarnsnBrAQ
         855iJemQYk2cEygwGUpLc1WayExl4abgN6DMmJe/Q9Bb81LWZNkpKQzVnKDm+z0Fvq
         gPz/NPAvdlVk9rwfb6BNzZwqin4u94bV6yHT3EEU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+e223cf47ec8ae183f2a0@syzkaller.appspotmail.com,
        Tadeusz Struk <tadeusz.struk@linaro.org>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 02/20] net: ipv6: fix skb_over_panic in __ip6_append_data
Date:   Fri, 25 Mar 2022 16:04:40 +0100
Message-Id: <20220325150417.082295724@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220325150417.010265747@linuxfoundation.org>
References: <20220325150417.010265747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tadeusz Struk <tadeusz.struk@linaro.org>

commit 5e34af4142ffe68f01c8a9acae83300f8911e20c upstream.

Syzbot found a kernel bug in the ipv6 stack:
LINK: https://syzkaller.appspot.com/bug?id=205d6f11d72329ab8d62a610c44c5e7e25415580
The reproducer triggers it by sending a crafted message via sendmmsg()
call, which triggers skb_over_panic, and crashes the kernel:

skbuff: skb_over_panic: text:ffffffff84647fb4 len:65575 put:65575
head:ffff888109ff0000 data:ffff888109ff0088 tail:0x100af end:0xfec0
dev:<NULL>

Update the check that prevents an invalid packet with MTU equal
to the fregment header size to eat up all the space for payload.

The reproducer can be found here:
LINK: https://syzkaller.appspot.com/text?tag=ReproC&x=1648c83fb00000

Reported-by: syzbot+e223cf47ec8ae183f2a0@syzkaller.appspotmail.com
Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
Acked-by: Willem de Bruijn <willemb@google.com>
Link: https://lore.kernel.org/r/20220310232538.1044947-1-tadeusz.struk@linaro.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_output.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1325,8 +1325,8 @@ static int __ip6_append_data(struct sock
 		      sizeof(struct frag_hdr) : 0) +
 		     rt->rt6i_nfheader_len;
 
-	if (mtu < fragheaderlen ||
-	    ((mtu - fragheaderlen) & ~7) + fragheaderlen < sizeof(struct frag_hdr))
+	if (mtu <= fragheaderlen ||
+	    ((mtu - fragheaderlen) & ~7) + fragheaderlen <= sizeof(struct frag_hdr))
 		goto emsgsize;
 
 	maxfraglen = ((mtu - fragheaderlen) & ~7) + fragheaderlen -


