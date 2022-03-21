Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF76B4E298B
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 15:04:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348806AbiCUOFh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 10:05:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348939AbiCUOEO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 10:04:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53ED318116C;
        Mon, 21 Mar 2022 07:01:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93F3361331;
        Mon, 21 Mar 2022 14:01:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98E96C340F4;
        Mon, 21 Mar 2022 14:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647871279;
        bh=UVpzg8vkB+appVM0yGsFhEW2xTZ4hJwU+sV8X/KCqV4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q4dmZsjxLT1mkKXhLxeo4kBgQ++/p7BbCQVZD0B8kG42fflA+D2EtrIwy6WpZVO+g
         taVKWrxB81MgQu4dnftWDQvNZTspXeE+Q+fEftcvNtifo+y9i+S60yzGWL4OSA4srF
         OaJkjeqXRPMRRKhqaCB0hG3uZwhAZs37ZYwLKaPg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Niels Dossche <dossche.niels@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 07/32] alx: acquire mutex for alx_reinit in alx_change_mtu
Date:   Mon, 21 Mar 2022 14:52:43 +0100
Message-Id: <20220321133220.776790538@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220321133220.559554263@linuxfoundation.org>
References: <20220321133220.559554263@linuxfoundation.org>
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

From: Niels Dossche <dossche.niels@gmail.com>

[ Upstream commit 46b348fd2d81a341b15fb3f3f986204b038f5c42 ]

alx_reinit has a lockdep assertion that the alx->mtx mutex must be held.
alx_reinit is called from two places: alx_reset and alx_change_mtu.
alx_reset does acquire alx->mtx before calling alx_reinit.
alx_change_mtu does not acquire this mutex, nor do its callers or any
path towards alx_change_mtu.
Acquire the mutex in alx_change_mtu.

The issue was introduced when the fine-grained locking was introduced
to the code to replace the RTNL. The same commit also introduced the
lockdep assertion.

Fixes: 4a5fe57e7751 ("alx: use fine-grained locking instead of RTNL")
Signed-off-by: Niels Dossche <dossche.niels@gmail.com>
Link: https://lore.kernel.org/r/20220310232707.44251-1-dossche.niels@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/atheros/alx/main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/atheros/alx/main.c b/drivers/net/ethernet/atheros/alx/main.c
index 4ea157efca86..98a8698a3201 100644
--- a/drivers/net/ethernet/atheros/alx/main.c
+++ b/drivers/net/ethernet/atheros/alx/main.c
@@ -1181,8 +1181,11 @@ static int alx_change_mtu(struct net_device *netdev, int mtu)
 	alx->hw.mtu = mtu;
 	alx->rxbuf_size = max(max_frame, ALX_DEF_RXBUF_SIZE);
 	netdev_update_features(netdev);
-	if (netif_running(netdev))
+	if (netif_running(netdev)) {
+		mutex_lock(&alx->mtx);
 		alx_reinit(alx);
+		mutex_unlock(&alx->mtx);
+	}
 	return 0;
 }
 
-- 
2.34.1



