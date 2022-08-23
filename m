Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C19559D4CE
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243480AbiHWIca (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:32:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243948AbiHWIam (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:30:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B98724A110;
        Tue, 23 Aug 2022 01:15:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 574096135D;
        Tue, 23 Aug 2022 08:14:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60AA1C433D6;
        Tue, 23 Aug 2022 08:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242477;
        bh=A/aPAFq7veYWuIg6AGp1rPtrhNGsvacQvE4A2a/OP3o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CKZ8y5ooogQIqSbDxDk9g8cCQ0BNDoDol2SJjmnyiwZ+zW34qlIwYP1viFll0XoCe
         n+4tjhYjtU+46ciewOQbGWhqW8wJOlg+KyT7/Z9wexCzJEL+MEOzm/QZL7/ixuM3AB
         7l7GJ9FlaFq9h/7laeR+OzsKLPopu3aCRZPLmmtg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <gnault@redhat.com>,
        Matthias May <matthias.may@westermo.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.19 121/365] vxlan: do not use RT_TOS for IPv6 flowlabel
Date:   Tue, 23 Aug 2022 10:00:22 +0200
Message-Id: <20220823080123.248049136@linuxfoundation.org>
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

commit e488d4f5d6e4cd1e728ba4ddbdcd7ef5f4d13a21 upstream.

According to Guillaume Nault RT_TOS should never be used for IPv6.

Quote:
RT_TOS() is an old macro used to interprete IPv4 TOS as described in
the obsolete RFC 1349. It's conceptually wrong to use it even in IPv4
code, although, given the current state of the code, most of the
existing calls have no consequence.

But using RT_TOS() in IPv6 code is always a bug: IPv6 never had a "TOS"
field to be interpreted the RFC 1349 way. There's no historical
compatibility to worry about.

Fixes: 1400615d64cf ("vxlan: allow setting ipv6 traffic class")
Acked-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Matthias May <matthias.may@westermo.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vxlan/vxlan_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -2321,7 +2321,7 @@ static struct dst_entry *vxlan6_get_rout
 	fl6.flowi6_oif = oif;
 	fl6.daddr = *daddr;
 	fl6.saddr = *saddr;
-	fl6.flowlabel = ip6_make_flowinfo(RT_TOS(tos), label);
+	fl6.flowlabel = ip6_make_flowinfo(tos, label);
 	fl6.flowi6_mark = skb->mark;
 	fl6.flowi6_proto = IPPROTO_UDP;
 	fl6.fl6_dport = dport;


