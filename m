Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E33375B7171
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234361AbiIMOhk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:37:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234248AbiIMOgM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:36:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C9DD5FAFF;
        Tue, 13 Sep 2022 07:20:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F916614D3;
        Tue, 13 Sep 2022 14:19:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B82A5C433C1;
        Tue, 13 Sep 2022 14:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078775;
        bh=912U8sWTW3D65FKaT9SuRv8+/rqOP3h0n2tF1A8FDVw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I/vMHYVXe/0okRAQvPHIkS0wu51JCbCJC+VqFgU2++CKhXNn5ebXG3B4yHNcw4EcE
         NA3JFSAWutI4YSrPYy3h/FmrE+Z5sXrC68Hm5KlZoy4LYKCEFLGT9zGLbzEXVLsyEZ
         KnGIiG4rgu8sjge3uaKeuXXUbmXbppnRVQRv/fzE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 078/121] tipc: fix shift wrapping bug in map_get()
Date:   Tue, 13 Sep 2022 16:04:29 +0200
Message-Id: <20220913140400.723421839@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140357.323297659@linuxfoundation.org>
References: <20220913140357.323297659@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit e2b224abd9bf45dcb55750479fc35970725a430b ]

There is a shift wrapping bug in this code so anything thing above
31 will return false.

Fixes: 35c55c9877f8 ("tipc: add neighbor monitoring framework")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/monitor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tipc/monitor.c b/net/tipc/monitor.c
index 2f4d23238a7e3..9618e4429f0fe 100644
--- a/net/tipc/monitor.c
+++ b/net/tipc/monitor.c
@@ -160,7 +160,7 @@ static void map_set(u64 *up_map, int i, unsigned int v)
 
 static int map_get(u64 up_map, int i)
 {
-	return (up_map & (1 << i)) >> i;
+	return (up_map & (1ULL << i)) >> i;
 }
 
 static struct tipc_peer *peer_prev(struct tipc_peer *peer)
-- 
2.35.1



