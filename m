Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6360760ACDB
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 16:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233495AbiJXOQd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 10:16:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234697AbiJXOOI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 10:14:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03023CABE0;
        Mon, 24 Oct 2022 05:53:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B40846125D;
        Mon, 24 Oct 2022 12:51:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F66BC433D7;
        Mon, 24 Oct 2022 12:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615902;
        bh=0yRnkpEfxS7tWFboF4T+L+HG5P/SvlF22wbvGiSDb4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zoYJk6RjuhOCX7rdvI3uYQazUV+fha0KYFFKQqJ+jx00jbiNzxqDcvVK3G8crk9Wi
         +ftRfY2APDIEzsC/xCA7VQpGcBKLeF8vjWQXTCx6C5Rse6Uqiz+iv1eUdaATB7UA4O
         GLnIXtmKJUhExlJdxDqIkWdOd8izdClPeQl44Oig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        syzbot+5ec9bb042ddfe9644773@syzkaller.appspotmail.com,
        Khalid Masum <khalid.masum.92@gmail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 425/530] xfrm: Update ipcomp_scratches with NULL when freed
Date:   Mon, 24 Oct 2022 13:32:49 +0200
Message-Id: <20221024113104.345480133@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Khalid Masum <khalid.masum.92@gmail.com>

[ Upstream commit 8a04d2fc700f717104bfb95b0f6694e448a4537f ]

Currently if ipcomp_alloc_scratches() fails to allocate memory
ipcomp_scratches holds obsolete address. So when we try to free the
percpu scratches using ipcomp_free_scratches() it tries to vfree non
existent vm area. Described below:

static void * __percpu *ipcomp_alloc_scratches(void)
{
        ...
        scratches = alloc_percpu(void *);
        if (!scratches)
                return NULL;
ipcomp_scratches does not know about this allocation failure.
Therefore holding the old obsolete address.
        ...
}

So when we free,

static void ipcomp_free_scratches(void)
{
        ...
        scratches = ipcomp_scratches;
Assigning obsolete address from ipcomp_scratches

        if (!scratches)
                return;

        for_each_possible_cpu(i)
               vfree(*per_cpu_ptr(scratches, i));
Trying to free non existent page, causing warning: trying to vfree
existent vm area.
        ...
}

Fix this breakage by updating ipcomp_scrtches with NULL when scratches
is freed

Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
Reported-by: syzbot+5ec9bb042ddfe9644773@syzkaller.appspotmail.com
Tested-by: syzbot+5ec9bb042ddfe9644773@syzkaller.appspotmail.com
Signed-off-by: Khalid Masum <khalid.masum.92@gmail.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_ipcomp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/xfrm/xfrm_ipcomp.c b/net/xfrm/xfrm_ipcomp.c
index cb40ff0ff28d..92ad336a83ab 100644
--- a/net/xfrm/xfrm_ipcomp.c
+++ b/net/xfrm/xfrm_ipcomp.c
@@ -203,6 +203,7 @@ static void ipcomp_free_scratches(void)
 		vfree(*per_cpu_ptr(scratches, i));
 
 	free_percpu(scratches);
+	ipcomp_scratches = NULL;
 }
 
 static void * __percpu *ipcomp_alloc_scratches(void)
-- 
2.35.1



