Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 716B8566AF3
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233357AbiGEMDJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233453AbiGEMCq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:02:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61D1C17E21;
        Tue,  5 Jul 2022 05:02:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 10B37B817D3;
        Tue,  5 Jul 2022 12:02:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74C28C341C7;
        Tue,  5 Jul 2022 12:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657022562;
        bh=RBN1VrK3jAHNYDEBxvR5VsJAYA7eBYhPYQO6FEJg6Ik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mLsRrjUX5CMWqKo3IT+65JxshvcWUC1dtjvxqbpVLiIAOeek0JHzjeZcbsghAHzvI
         IklF3/Ob5kg5aB50nGBePGTT1DDqUHVdkE9ayI/4bntTkxsUfI028kblSq7L7omgHR
         auQCBtjvK1qOE7i2V6eZFjiAkI/rP7XfyremAfr4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, syzbot <syzkaller@googlegroups.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 21/33] net: tun: avoid disabling NAPI twice
Date:   Tue,  5 Jul 2022 13:58:13 +0200
Message-Id: <20220705115607.334949507@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115606.709817198@linuxfoundation.org>
References: <20220705115606.709817198@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

commit ff1fa2081d173b01cebe2fbf0a2d0f1cee9ce4b5 upstream.

Eric reports that syzbot made short work out of my speculative
fix. Indeed when queue gets detached its tfile->tun remains,
so we would try to stop NAPI twice with a detach(), close()
sequence.

Alternative fix would be to move tun_napi_disable() to
tun_detach_all() and let the NAPI run after the queue
has been detached.

Fixes: a8fc8cb5692a ("net: tun: stop NAPI when detaching queues")
Reported-by: syzbot <syzkaller@googlegroups.com>
Reported-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20220629181911.372047-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/tun.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -710,7 +710,8 @@ static void __tun_detach(struct tun_file
 	tun = rtnl_dereference(tfile->tun);
 
 	if (tun && clean) {
-		tun_napi_disable(tfile);
+		if (!tfile->detached)
+			tun_napi_disable(tfile);
 		tun_napi_del(tfile);
 	}
 


