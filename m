Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB29A59D919
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243546AbiHWJyo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:54:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245474AbiHWJyC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:54:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E119C9F75C;
        Tue, 23 Aug 2022 01:46:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 560606153D;
        Tue, 23 Aug 2022 08:45:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 433BAC433D6;
        Tue, 23 Aug 2022 08:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244344;
        bh=8Ft3YJB8yFl83F7dr3vrx+/dK8rUaSG7Bm+tACWwROM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ex8P9ayz0PndKMI4W4aEdMsdQKPtTZHoKGoOFZPYVIby0uJKeoUMloxEH7ppagl9p
         V2pUrRDBqNONrMp5Gq1RnhvYV0vXdIgi16180FZfdEfSoUigSPiQWoPBH9Qpd5iJgg
         KNbZQz+BmQHzYbhny7XzUEMRAJu4tyLRDREa0Mz8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <gnault@redhat.com>,
        Matthias May <matthias.may@westermo.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 076/244] geneve: do not use RT_TOS for IPv6 flowlabel
Date:   Tue, 23 Aug 2022 10:23:55 +0200
Message-Id: <20220823080101.594502305@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
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

commit ca2bb69514a8bc7f83914122f0d596371352416c upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/geneve.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -852,8 +852,7 @@ static struct dst_entry *geneve_get_v6_d
 		use_cache = false;
 	}
 
-	fl6->flowlabel = ip6_make_flowinfo(RT_TOS(prio),
-					   info->key.label);
+	fl6->flowlabel = ip6_make_flowinfo(prio, info->key.label);
 	dst_cache = (struct dst_cache *)&info->dst_cache;
 	if (use_cache) {
 		dst = dst_cache_get_ip6(dst_cache, &fl6->saddr);


