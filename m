Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01988540D9C
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353467AbiFGStL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:49:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354314AbiFGSqx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:46:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 706DF1269A3;
        Tue,  7 Jun 2022 11:00:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2EAF2B82239;
        Tue,  7 Jun 2022 18:00:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D261C385A5;
        Tue,  7 Jun 2022 18:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624839;
        bh=T/8dKxgO1bV24yxbT1u1jIbcPlEOMWi68k46axBHxpw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sd5EhpKssMQvFyG2w6s5bGgOsheczlFIXOjvNix71o/AXqgCBx+gVkUWhiruvaGVY
         +98SDLx1CHDhxPTqt4zXLl/A3LEZdkFuvBGwLD15HE32jaFmS/x9nbC6UKEKFB3cP/
         nYUNe0IaXa7tUd5vwk10uwRp4xUUZZpHk5cXEH3g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Schroeder <jumaco@amazon.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 471/667] nfsd: destroy percpu stats counters after reply cache shutdown
Date:   Tue,  7 Jun 2022 19:02:16 +0200
Message-Id: <20220607164948.832223601@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
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

From: Julian Schroeder <jumaco@amazon.com>

[ Upstream commit fd5e363eac77ef81542db77ddad0559fa0f9204e ]

Upon nfsd shutdown any pending DRC cache is freed. DRC cache use is
tracked via a percpu counter. In the current code the percpu counter
is destroyed before. If any pending cache is still present,
percpu_counter_add is called with a percpu counter==NULL. This causes
a kernel crash.
The solution is to destroy the percpu counter after the cache is freed.

Fixes: e567b98ce9a4b (“nfsd: protect concurrent access to nfsd stats counters”)
Signed-off-by: Julian Schroeder <jumaco@amazon.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfscache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfsd/nfscache.c b/fs/nfsd/nfscache.c
index 96cdf77925f3..830bb8493c7f 100644
--- a/fs/nfsd/nfscache.c
+++ b/fs/nfsd/nfscache.c
@@ -212,7 +212,6 @@ void nfsd_reply_cache_shutdown(struct nfsd_net *nn)
 	struct svc_cacherep	*rp;
 	unsigned int i;
 
-	nfsd_reply_cache_stats_destroy(nn);
 	unregister_shrinker(&nn->nfsd_reply_cache_shrinker);
 
 	for (i = 0; i < nn->drc_hashsize; i++) {
@@ -223,6 +222,7 @@ void nfsd_reply_cache_shutdown(struct nfsd_net *nn)
 									rp, nn);
 		}
 	}
+	nfsd_reply_cache_stats_destroy(nn);
 
 	kvfree(nn->drc_hashtbl);
 	nn->drc_hashtbl = NULL;
-- 
2.35.1



