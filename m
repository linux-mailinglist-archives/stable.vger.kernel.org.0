Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E453C54914E
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355122AbiFMLkF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:40:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355645AbiFMLjV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:39:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 715A4240A6;
        Mon, 13 Jun 2022 03:49:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E759611B3;
        Mon, 13 Jun 2022 10:49:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B394C34114;
        Mon, 13 Jun 2022 10:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655117369;
        bh=T611AqZoiFQfWYPVYPb48WSKnnpat4kjd96H237bCno=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wfceS2p5lFmoENd4fDvAFfJJ6bdPTWP2urDGwB3acUHxxoU2XQhatX333OUOh2DHJ
         R3iBBa+EyVVRL/WYOtJDiWsFDRXJH6NGOfYzljn7IECFam+ikd/GZAbuxGiz+T8FMD
         SSX0imyHesfzvThY1onvAAMekTa8PwNbE7eKRee8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 354/411] net: dsa: lantiq_gswip: Fix refcount leak in gswip_gphy_fw_list
Date:   Mon, 13 Jun 2022 12:10:27 +0200
Message-Id: <20220613094939.315586047@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
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
index 0c191d395f8f..b546002e5fd4 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -1958,8 +1958,10 @@ static int gswip_gphy_fw_list(struct gswip_priv *priv,
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



