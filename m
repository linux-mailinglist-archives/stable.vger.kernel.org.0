Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 354545B73C5
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235279AbiIMPJi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:09:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235586AbiIMPIr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:08:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10C4676749;
        Tue, 13 Sep 2022 07:31:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76AA1614E7;
        Tue, 13 Sep 2022 14:30:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86388C433D6;
        Tue, 13 Sep 2022 14:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079406;
        bh=F7eNZoNKrqXsRar6frmRBa5KEyH/yBkWG+Jmxl7oVps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rlkPbHByglUcvZq96wHSfAFn9AUedsLUDLcfk1j82HMoTlYyW0i2j/bGa4OkjxrKw
         2AK8nVP6qblVOzkwoLRblkbHT2qulXw9E6zutlie+MwyxODRqsHjKfwQW7R2Q9UT4L
         6jsRlXxSYrmfLFPYD0YV5o5J6z4Zvv2IC34QXVrA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Duoming Zhou <duoming@zju.edu.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 14/79] ethernet: rocker: fix sleep in atomic context bug in neigh_timer_handler
Date:   Tue, 13 Sep 2022 16:06:32 +0200
Message-Id: <20220913140349.548343910@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140348.835121645@linuxfoundation.org>
References: <20220913140348.835121645@linuxfoundation.org>
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
index 6473cc68c2d5c..4039e1fc6e92a 100644
--- a/drivers/net/ethernet/rocker/rocker_ofdpa.c
+++ b/drivers/net/ethernet/rocker/rocker_ofdpa.c
@@ -1276,7 +1276,7 @@ static int ofdpa_port_ipv4_neigh(struct ofdpa_port *ofdpa_port,
 	bool removing;
 	int err = 0;
 
-	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
+	entry = kzalloc(sizeof(*entry), GFP_ATOMIC);
 	if (!entry)
 		return -ENOMEM;
 
-- 
2.35.1



