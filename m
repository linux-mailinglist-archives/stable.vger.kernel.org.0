Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC81B5B732B
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232507AbiIMPEp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:04:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235118AbiIMPCU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:02:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1D935F95;
        Tue, 13 Sep 2022 07:29:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21BD6B80F10;
        Tue, 13 Sep 2022 14:29:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79E48C433D6;
        Tue, 13 Sep 2022 14:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079346;
        bh=l2Y0NOKoGjP98oa7oYdznhLq9Zo2CQE2x2Ll+Oz0zcA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bgzfg4/5BMFGXgIdfmiBO725Ysyv+pxrIHDSPC6AYvgvqnzBIatCkPFWxLEKJHisE
         mjwVi14jfHJi1bSKS8TbaKeoqiIqjiTF/k20C/cGHD15bINdKK8TRmR/Y+x6XpXbu0
         whpanCTjt1E7yGigJomXwKv6pcqw5qPUY8LndwvI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 099/108] tipc: fix shift wrapping bug in map_get()
Date:   Tue, 13 Sep 2022 16:07:10 +0200
Message-Id: <20220913140357.873994836@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140353.549108748@linuxfoundation.org>
References: <20220913140353.549108748@linuxfoundation.org>
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
index e7155a7743001..0b9ad3b5ff18a 100644
--- a/net/tipc/monitor.c
+++ b/net/tipc/monitor.c
@@ -130,7 +130,7 @@ static void map_set(u64 *up_map, int i, unsigned int v)
 
 static int map_get(u64 up_map, int i)
 {
-	return (up_map & (1 << i)) >> i;
+	return (up_map & (1ULL << i)) >> i;
 }
 
 static struct tipc_peer *peer_prev(struct tipc_peer *peer)
-- 
2.35.1



