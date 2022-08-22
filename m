Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4223059BC01
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 10:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231331AbiHVIvW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 04:51:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232877AbiHVIvM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 04:51:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16B56167DD
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 01:51:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A11EE61068
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 08:51:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F23EC433C1;
        Mon, 22 Aug 2022 08:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661158270;
        bh=42y0HHaza7JpFEsTBvIHQKhk9kJTrBdC4gqiOzMMJdo=;
        h=Subject:To:Cc:From:Date:From;
        b=2LQvBNMZHuSSOljxSrI6PH5A1IV6g6vQ/aeN00xlfVkqz39r1uq+2kb1TOExPsYHy
         3Swgw0JMoMNyX5BOvwy2yWbziVDIPJSPvOSg4MpvYBij4A4b0zfA/tQPrU9EaH1RQI
         ChaeOmd3TxHq4vvIAqqiPRmndN3+K0LnG/ZdX/t4=
Subject: FAILED: patch "[PATCH] geneve: do not use RT_TOS for IPv6 flowlabel" failed to apply to 4.9-stable tree
To:     matthias.may@westermo.com, gnault@redhat.com, kuba@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 22 Aug 2022 10:51:06 +0200
Message-ID: <1661158266146134@kroah.com>
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


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ca2bb69514a8bc7f83914122f0d596371352416c Mon Sep 17 00:00:00 2001
From: Matthias May <matthias.may@westermo.com>
Date: Fri, 5 Aug 2022 21:19:03 +0200
Subject: [PATCH] geneve: do not use RT_TOS for IPv6 flowlabel

According to Guillaume Nault RT_TOS should never be used for IPv6.

Quote:
RT_TOS() is an old macro used to interprete IPv4 TOS as described in
the obsolete RFC 1349. It's conceptually wrong to use it even in IPv4
code, although, given the current state of the code, most of the
existing calls have no consequence.

But using RT_TOS() in IPv6 code is always a bug: IPv6 never had a "TOS"
field to be interpreted the RFC 1349 way. There's no historical
compatibility to worry about.

Fixes: 3a56f86f1be6 ("geneve: handle ipv6 priority like ipv4 tos")
Acked-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Matthias May <matthias.may@westermo.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index fafe7dea2227..7962c37b3f14 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -879,8 +879,7 @@ static struct dst_entry *geneve_get_v6_dst(struct sk_buff *skb,
 		use_cache = false;
 	}
 
-	fl6->flowlabel = ip6_make_flowinfo(RT_TOS(prio),
-					   info->key.label);
+	fl6->flowlabel = ip6_make_flowinfo(prio, info->key.label);
 	dst_cache = (struct dst_cache *)&info->dst_cache;
 	if (use_cache) {
 		dst = dst_cache_get_ip6(dst_cache, &fl6->saddr);

