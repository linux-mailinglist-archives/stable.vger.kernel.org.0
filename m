Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D569A5AEBBB
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240314AbiIFOAY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240980AbiIFN7Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:59:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DDD17E30F;
        Tue,  6 Sep 2022 06:43:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B47CC61548;
        Tue,  6 Sep 2022 13:43:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD1A4C43141;
        Tue,  6 Sep 2022 13:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471799;
        bh=9No5lsAw1e6KnJpCa7Pr5sdzACoA6tGPj7TyNWrBArQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D7HaUVSXlsuJS+97RP/tAjBpWE+5GenhH62YQ5TnimPJCzkaC4k9xzV77HfbV48PA
         EvMZwbZdwSNvW32O7Sp9kDiRz54oijyVQrM1KBEreGD+Tvw9bpTy+kRieh3F3LqvUT
         YlXXy2p6j6MhpOAgRyvgtQOutsQr3iFTMQZRvTQY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Duoming Zhou <duoming@zju.edu.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 043/155] ethernet: rocker: fix sleep in atomic context bug in neigh_timer_handler
Date:   Tue,  6 Sep 2022 15:29:51 +0200
Message-Id: <20220906132831.230709577@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
References: <20220906132829.417117002@linuxfoundation.org>
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
index bc70c6abd6a5b..58cf7cc54f408 100644
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



