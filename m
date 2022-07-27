Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF84058302D
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241826AbiG0RfK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:35:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242506AbiG0ReR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:34:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF28083205;
        Wed, 27 Jul 2022 09:49:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1BA6C616FA;
        Wed, 27 Jul 2022 16:49:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26A67C433D6;
        Wed, 27 Jul 2022 16:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940548;
        bh=w5sWh8F8n0FEZ5hPRhjKnS9zIrHd3MtT9EMOxialx48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vya4sr97ExJgtObazu/zkqH4UnikZnwe2RnmQW2baIqWWEc7SE3AwF47tETNYubhV
         TMDoTZHUfTeS1bZYpeVkcqiJHn93KnJdy7frUKIbvZi5QUegpdgm+9pApDrT7/LYLI
         CViI8y2T8TSEq6TKAx9We3JsRL/nihfZNJWvYIu4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Maksym Glubokiy <maksym.glubokiy@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 061/158] net: prestera: acl: use proper mask for port selector
Date:   Wed, 27 Jul 2022 18:12:05 +0200
Message-Id: <20220727161023.950555886@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
References: <20220727161021.428340041@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maksym Glubokiy <maksym.glubokiy@plvision.eu>

[ Upstream commit 1e20904e417738066b26490de2daf7ef3ed34483 ]

Adjusted as per packet processor documentation.
This allows to properly match 'indev' for clsact rules.

Fixes: 47327e198d42 ("net: prestera: acl: migrate to new vTCAM api")

Signed-off-by: Maksym Glubokiy <maksym.glubokiy@plvision.eu>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/prestera/prestera_flower.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_flower.c b/drivers/net/ethernet/marvell/prestera/prestera_flower.c
index 921959a980ee..d8cfa4a7de0f 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_flower.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_flower.c
@@ -139,12 +139,12 @@ static int prestera_flower_parse_meta(struct prestera_acl_rule *rule,
 	}
 	port = netdev_priv(ingress_dev);
 
-	mask = htons(0x1FFF);
-	key = htons(port->hw_id);
+	mask = htons(0x1FFF << 3);
+	key = htons(port->hw_id << 3);
 	rule_match_set(r_match->key, SYS_PORT, key);
 	rule_match_set(r_match->mask, SYS_PORT, mask);
 
-	mask = htons(0x1FF);
+	mask = htons(0x3FF);
 	key = htons(port->dev_id);
 	rule_match_set(r_match->key, SYS_DEV, key);
 	rule_match_set(r_match->mask, SYS_DEV, mask);
-- 
2.35.1



