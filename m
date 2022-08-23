Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E42F59D647
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243689AbiHWIcp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:32:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343753AbiHWIbR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:31:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2817074E2F;
        Tue, 23 Aug 2022 01:15:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 01B9F6129A;
        Tue, 23 Aug 2022 08:14:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0070CC433C1;
        Tue, 23 Aug 2022 08:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242493;
        bh=Rfq4sGxkv7PUq84xlx59lHyoBQyqRqYH7SkfBniubrg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u7uVWiKy3VeDe/1qpGMsUob6025P/vx3FEJ97U6u9uElFnHjrXdoItC7K5Slkvwgc
         rsCrqopN5YYosjq1hP20fPDhPWVnlwEAVJuYHcvkor1EEveIrTxnKpOZcIQtiNALoB
         WOJ9IEWMAwK8Ftp+9QhSTlNxsvoLxOmN3/8jyzkE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <gnault@redhat.com>,
        Matthias May <matthias.may@westermo.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.19 123/365] ipv6: do not use RT_TOS for IPv6 flowlabel
Date:   Tue, 23 Aug 2022 10:00:24 +0200
Message-Id: <20220823080123.340298617@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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

From: Matthias May <matthias.may@westermo.com>

commit ab7e2e0dfa5d37540ab1dc5376e9a2cb9188925d upstream.

According to Guillaume Nault RT_TOS should never be used for IPv6.

Quote:
RT_TOS() is an old macro used to interprete IPv4 TOS as described in
the obsolete RFC 1349. It's conceptually wrong to use it even in IPv4
code, although, given the current state of the code, most of the
existing calls have no consequence.

But using RT_TOS() in IPv6 code is always a bug: IPv6 never had a "TOS"
field to be interpreted the RFC 1349 way. There's no historical
compatibility to worry about.

Fixes: 571912c69f0e ("net: UDP tunnel encapsulation module for tunnelling different protocols like MPLS, IP, NSH etc.")
Acked-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Matthias May <matthias.may@westermo.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_output.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1311,8 +1311,7 @@ struct dst_entry *ip6_dst_lookup_tunnel(
 	fl6.daddr = info->key.u.ipv6.dst;
 	fl6.saddr = info->key.u.ipv6.src;
 	prio = info->key.tos;
-	fl6.flowlabel = ip6_make_flowinfo(RT_TOS(prio),
-					  info->key.label);
+	fl6.flowlabel = ip6_make_flowinfo(prio, info->key.label);
 
 	dst = ipv6_stub->ipv6_dst_lookup_flow(net, sock->sk, &fl6,
 					      NULL);


