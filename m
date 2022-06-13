Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3FBC5494B9
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359406AbiFMNNO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:13:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357254AbiFMNHR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:07:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCE9B381B2;
        Mon, 13 Jun 2022 04:18:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32D73B80EAB;
        Mon, 13 Jun 2022 11:18:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B58AC34114;
        Mon, 13 Jun 2022 11:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119114;
        bh=dwTBRByocbJ8UGwNR2U6VMjbYtsFF+Xh/didYYZH2vY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a5oauioiUeuvR6wojwPaBI6JCKUywCnduvNX/Va1ovOxodP6uuCcI/oo/MU0VaUdA
         oaxu/PNERWil/65WAp1LAo8uyIVaF13rbg77NO36XTX6XVj6jrgJ3AIPObHJXCb4eh
         y59wHWqtstgFpVieFDpDiX9ZlXBYseGJrTOREfbU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 146/247] net: dsa: lantiq_gswip: Fix refcount leak in gswip_gphy_fw_list
Date:   Mon, 13 Jun 2022 12:10:48 +0200
Message-Id: <20220613094927.384042771@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094922.843438024@linuxfoundation.org>
References: <20220613094922.843438024@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 0737e018a05e2aa352828c52bdeed3b02cff2930 ]

Every iteration of for_each_available_child_of_node() decrements
the reference count of the previous node.
when breaking early from a for_each_available_child_of_node() loop,
we need to explicitly call of_node_put() on the gphy_fw_np.
Add missing of_node_put() to avoid refcount leak.

Fixes: 14fceff4771e ("net: dsa: Add Lantiq / Intel DSA driver for vrx200")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20220605072335.11257-1-linmq006@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/lantiq_gswip.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 8a8f392813d8..2240a3d35122 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -2047,8 +2047,10 @@ static int gswip_gphy_fw_list(struct gswip_priv *priv,
 	for_each_available_child_of_node(gphy_fw_list_np, gphy_fw_np) {
 		err = gswip_gphy_fw_probe(priv, &priv->gphy_fw[i],
 					  gphy_fw_np, i);
-		if (err)
+		if (err) {
+			of_node_put(gphy_fw_np);
 			goto remove_gphy;
+		}
 		i++;
 	}
 
-- 
2.35.1



