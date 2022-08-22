Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62A5F59BC09
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 10:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232555AbiHVIvr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 04:51:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233801AbiHVIvp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 04:51:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEB7AE01B
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 01:51:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5285A6106C
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 08:51:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44D4AC433D6;
        Mon, 22 Aug 2022 08:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661158303;
        bh=DzXn+1hX10ApYrpWI+LuCQve94vg3u8ZNewid5fStd4=;
        h=Subject:To:Cc:From:Date:From;
        b=loAI2ecUdIMteO88HKP4i6eF3lIYGwiUn5IYA3Rnh0m4bi1GpmNSr6kBeJZuaNroC
         KBlbJXE4AxAPUI+DXvvEeNiB5V1idyrFZyLhUIUWhDocGaCbEJzdnTuy0E656N67uH
         91w6nl16Z6TlpjUAXsUs3t9Pvc+Nbw9EgG8ZhF8s=
Subject: FAILED: patch "[PATCH] vxlan: do not use RT_TOS for IPv6 flowlabel" failed to apply to 4.14-stable tree
To:     matthias.may@westermo.com, gnault@redhat.com, kuba@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 22 Aug 2022 10:51:28 +0200
Message-ID: <16611582889796@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e488d4f5d6e4cd1e728ba4ddbdcd7ef5f4d13a21 Mon Sep 17 00:00:00 2001
From: Matthias May <matthias.may@westermo.com>
Date: Fri, 5 Aug 2022 21:19:04 +0200
Subject: [PATCH] vxlan: do not use RT_TOS for IPv6 flowlabel

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

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index 90811ab851fd..c3285242f74f 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -2321,7 +2321,7 @@ static struct dst_entry *vxlan6_get_route(struct vxlan_dev *vxlan,
 	fl6.flowi6_oif = oif;
 	fl6.daddr = *daddr;
 	fl6.saddr = *saddr;
-	fl6.flowlabel = ip6_make_flowinfo(RT_TOS(tos), label);
+	fl6.flowlabel = ip6_make_flowinfo(tos, label);
 	fl6.flowi6_mark = skb->mark;
 	fl6.flowi6_proto = IPPROTO_UDP;
 	fl6.fl6_dport = dport;

