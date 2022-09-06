Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD0A5AE9A8
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 15:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240477AbiIFNcj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:32:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238052AbiIFNcZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:32:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A42B754AC;
        Tue,  6 Sep 2022 06:32:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D6A7561546;
        Tue,  6 Sep 2022 13:32:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8222C433D6;
        Tue,  6 Sep 2022 13:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471143;
        bh=PIiYXnLiCDUyEahvFa6chU1F97LMMd7JzaS5JBKy+7A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RyM6tV/xZHPXdFY8m1Oiqq/WJq+yDG2GwpmX8AAOlkJgRiqvS6L86SxpbOBqZPO6Y
         EfavLn3vGUpkqwONv0wESaLA9XpbGLM/yP3Ow/9dreL3cCe5+AOVEBTRe9fG6vRWuL
         tgSEImIhXyECRX1gWA7SAbgR92vzX5QsQWJf/RBk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Duoming Zhou <duoming@zju.edu.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 15/80] ethernet: rocker: fix sleep in atomic context bug in neigh_timer_handler
Date:   Tue,  6 Sep 2022 15:30:12 +0200
Message-Id: <20220906132817.574729683@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132816.936069583@linuxfoundation.org>
References: <20220906132816.936069583@linuxfoundation.org>
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

From: Duoming Zhou <duoming@zju.edu.cn>

[ Upstream commit c0955bf957be4bead01fae1d791476260da7325d ]

The function neigh_timer_handler() is a timer handler that runs in an
atomic context. When used by rocker, neigh_timer_handler() calls
"kzalloc(.., GFP_KERNEL)" that may sleep. As a result, the sleep in
atomic context bug will happen. One of the processes is shown below:

ofdpa_fib4_add()
 ...
 neigh_add_timer()

(wait a timer)

neigh_timer_handler()
 neigh_release()
  neigh_destroy()
   rocker_port_neigh_destroy()
    rocker_world_port_neigh_destroy()
     ofdpa_port_neigh_destroy()
      ofdpa_port_ipv4_neigh()
       kzalloc(sizeof(.., GFP_KERNEL) //may sleep

This patch changes the gfp_t parameter of kzalloc() from GFP_KERNEL to
GFP_ATOMIC in order to mitigate the bug.

Fixes: 00fc0c51e35b ("rocker: Change world_ops API and implementation to be switchdev independant")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/rocker/rocker_ofdpa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/rocker/rocker_ofdpa.c b/drivers/net/ethernet/rocker/rocker_ofdpa.c
index 8157666209798..e4d919de7e3fc 100644
--- a/drivers/net/ethernet/rocker/rocker_ofdpa.c
+++ b/drivers/net/ethernet/rocker/rocker_ofdpa.c
@@ -1273,7 +1273,7 @@ static int ofdpa_port_ipv4_neigh(struct ofdpa_port *ofdpa_port,
 	bool removing;
 	int err = 0;
 
-	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
+	entry = kzalloc(sizeof(*entry), GFP_ATOMIC);
 	if (!entry)
 		return -ENOMEM;
 
-- 
2.35.1



