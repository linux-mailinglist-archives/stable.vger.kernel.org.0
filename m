Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 632F8635847
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:54:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236927AbiKWJyD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:54:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237050AbiKWJwd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:52:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A444CE634E
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:49:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F61F61B22
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:49:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28FEDC433D6;
        Wed, 23 Nov 2022 09:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196969;
        bh=5PZ/evlJ9AABUGDOl7l32/xBqIDTrHueOeWbx50iCbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZZAcigLXIxNxsBHcMcoFqKOEKfBsOxG4EcZCQ90hHGZStDg5o4L+UhM+xP21G3tuk
         O5j8uooaD4ktrW0K7+YJyiDsR3SREyvTYseHAJ8VJcdHjNusFxcsbpgMpLeegaNAPh
         q9JQVSufpfmTbm+ypiStYI68c/sKbcS+uYRwQSLI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Ziyang Xuan <william.xuanziyang@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 161/314] octeon_ep: ensure octep_get_link_status() successfully before octep_link_up()
Date:   Wed, 23 Nov 2022 09:50:06 +0100
Message-Id: <20221123084632.870928021@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ziyang Xuan <william.xuanziyang@huawei.com>

[ Upstream commit 9d3ff7131877fb092185c369fbb14b57ac4e7cec ]

octep_get_link_status() can fail because send mbox message failed, then
octep_get_link_status() will return ret less than 0. Excute octep_link_up()
as long as ret is not equal to 0 in octep_open() now. That is not correct.

The value type of link.state is enum octep_ctrl_net_state. Positive value
represents up. Excute octep_link_up() when ret is bigger than 0.

Fixes: 862cd659a6fb ("octeon_ep: Add driver framework and device initialization")
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeon_ep/octep_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
index 7083c995d0c1..92ca3e502465 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
@@ -521,7 +521,7 @@ static int octep_open(struct net_device *netdev)
 	octep_oq_dbell_init(oct);
 
 	ret = octep_get_link_status(oct);
-	if (ret)
+	if (ret > 0)
 		octep_link_up(netdev);
 
 	return 0;
-- 
2.35.1



