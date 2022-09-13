Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16E9C5B74ED
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232311AbiIMP0Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:26:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233851AbiIMPY1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:24:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 482B77CB7E;
        Tue, 13 Sep 2022 07:38:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80A9CB80FCD;
        Tue, 13 Sep 2022 14:35:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D21E9C433C1;
        Tue, 13 Sep 2022 14:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079755;
        bh=zqlOfWX73AmjTePBYnE+j8JGEab2NFElMuX9jcJyyMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AhyWMiWiFKiqr5LwksiuQctP7ZUmdL8GeX01x4+o4QO0BsLQwtwjsRmNcIg4OIHJK
         Csn3adAcvWwnSd6ZSBViPMySmqTv5eQgCOgt5qB9LOWaWriWf4g7JNaHQowDmf9VUQ
         q1fzQ1d/OHOvxJ3cqL0j1/F2ZCH0PgHS72gr35jk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 53/61] tipc: fix shift wrapping bug in map_get()
Date:   Tue, 13 Sep 2022 16:07:55 +0200
Message-Id: <20220913140349.109992928@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140346.422813036@linuxfoundation.org>
References: <20220913140346.422813036@linuxfoundation.org>
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
index c6496da9392d7..cf6dd3546c53c 100644
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



