Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 917875B700D
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233073AbiIMOUh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:20:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233638AbiIMOTb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:19:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8406E6050C;
        Tue, 13 Sep 2022 07:14:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C24DB80EF6;
        Tue, 13 Sep 2022 14:12:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBC5CC433D7;
        Tue, 13 Sep 2022 14:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078377;
        bh=912U8sWTW3D65FKaT9SuRv8+/rqOP3h0n2tF1A8FDVw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EKBo4XvOsUs2TPrY/eySwK9nPmg3+uyRILUZlKcxO64wB89deEcXakqnO9ju9agqZ
         MaRbzOzqKf5Kv1Fi63VwfemTH1kZrPDqroRTs9T/qLsPNDrOEM9TKtpEUfwTKm4YGB
         nZ8Tdv4/5lQkBAjrq6uSJPvAxi5jOcyNdTQL8y48=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 116/192] tipc: fix shift wrapping bug in map_get()
Date:   Tue, 13 Sep 2022 16:03:42 +0200
Message-Id: <20220913140415.758336625@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
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



