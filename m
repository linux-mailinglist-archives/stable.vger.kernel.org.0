Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 713846D4995
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233742AbjDCOjU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:39:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233728AbjDCOjT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:39:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DDA61BF50
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:39:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A531061EB8
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:39:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA223C433D2;
        Mon,  3 Apr 2023 14:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532756;
        bh=XqCYsBqcdS3JoSuA8/wHHStjQJ0Lc+gJQ3obvfy4Esw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0MSG16PhDndKZknkSG0UiCBpPUVhybvkHsUT+e/JsTDchn/3kU3PzsZbVxz015CZ5
         fs1XglvD1ZIZbWQmSP76Rn/6pl2rd77cNyP3r/NKbjniMOTEaX366j/KKz4glTOdqm
         /ctU62I96SyzoE4gzlQUfhEWN2KlC75347I1ydrs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sven Auhagen <sven.auhagen@voleatech.de>,
        Marcin Wojtas <mw@semihalf.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 104/181] net: mvpp2: parser fix QinQ
Date:   Mon,  3 Apr 2023 16:08:59 +0200
Message-Id: <20230403140418.484161808@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
References: <20230403140415.090615502@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Auhagen <sven.auhagen@voleatech.de>

[ Upstream commit a587a84813b90372cb0a7565e201a4075da67919 ]

The mvpp2 parser entry for QinQ has the inner and outer VLAN
in the wrong order.
Fix the problem by swapping them.

Fixes: 3f518509dedc ("ethernet: Add new driver for Marvell Armada 375 network unit")
Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
Reviewed-by: Marcin Wojtas <mw@semihalf.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
index 75ba57bd1d46d..ed8be396428b9 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
@@ -1539,8 +1539,8 @@ static int mvpp2_prs_vlan_init(struct platform_device *pdev, struct mvpp2 *priv)
 	if (!priv->prs_double_vlans)
 		return -ENOMEM;
 
-	/* Double VLAN: 0x8100, 0x88A8 */
-	err = mvpp2_prs_double_vlan_add(priv, ETH_P_8021Q, ETH_P_8021AD,
+	/* Double VLAN: 0x88A8, 0x8100 */
+	err = mvpp2_prs_double_vlan_add(priv, ETH_P_8021AD, ETH_P_8021Q,
 					MVPP2_PRS_PORT_MASK);
 	if (err)
 		return err;
-- 
2.39.2



