Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 332C25B7480
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236078AbiIMPVF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:21:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235782AbiIMPTW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:19:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33E337AC37;
        Tue, 13 Sep 2022 07:36:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5DA43B80F9D;
        Tue, 13 Sep 2022 14:34:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A263FC433C1;
        Tue, 13 Sep 2022 14:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079661;
        bh=fl+1UOIJlFEE2wyNt2W4lBZHymVKH/kugNQe66C4Z6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qw0qJYEyS/kEYm8morrU2ImrdBBQJeOI4dcoigJHY3AIN3ysKukEg0QjJG+V+WWb3
         Z3eHrYpAyNAcOb5CQ/hVg/LKQwM+WiqR4k8GkYpvp+B23I1v9D/XgXJcx4f31e5gID
         Ss+9f+m4hKSKyOS4xEv1ZpN7rNZ8lvbHFNl4L3hM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Duoming Zhou <duoming@zju.edu.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 07/61] ethernet: rocker: fix sleep in atomic context bug in neigh_timer_handler
Date:   Tue, 13 Sep 2022 16:07:09 +0200
Message-Id: <20220913140346.835357179@linuxfoundation.org>
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
index 0653b70723a34..5dad40257e12e 100644
--- a/drivers/net/ethernet/rocker/rocker_ofdpa.c
+++ b/drivers/net/ethernet/rocker/rocker_ofdpa.c
@@ -1277,7 +1277,7 @@ static int ofdpa_port_ipv4_neigh(struct ofdpa_port *ofdpa_port,
 	bool removing;
 	int err = 0;
 
-	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
+	entry = kzalloc(sizeof(*entry), GFP_ATOMIC);
 	if (!entry)
 		return -ENOMEM;
 
-- 
2.35.1



