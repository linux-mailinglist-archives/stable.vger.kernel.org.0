Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 589A64F41F7
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 23:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382678AbiDEMQa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:16:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243864AbiDEKhs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:37:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F0736E7BD;
        Tue,  5 Apr 2022 03:23:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A13B1616D7;
        Tue,  5 Apr 2022 10:23:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2F31C385A1;
        Tue,  5 Apr 2022 10:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649154198;
        bh=/GE3itW8H5N1d3k8ul41yxIrIxzjmHcnGvC2im5uJmY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HysIdRe8YRr0UntGqx9CnHowacZ0zBqf686fI7fUqQohcUcDOPnVrcsU68HblCprz
         yaOevwpI5YT5dphRRVTTj1lUruynEJc0SoexiEo1HbxDDsPT/+OcQYv0Lh/QPupnXx
         mOtDARo6LZguLHKckjyLGkWZZd/0Y1WdPIOGou2I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 445/599] net: dsa: bcm_sf2_cfp: fix an incorrect NULL check on list iterator
Date:   Tue,  5 Apr 2022 09:32:19 +0200
Message-Id: <20220405070312.073422957@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Xiaomeng Tong <xiam0nd.tong@gmail.com>

[ Upstream commit 6da69b1da130e7d96766042750cd9f902e890eba ]

The bug is here:
	return rule;

The list iterator value 'rule' will *always* be set and non-NULL
by list_for_each_entry(), so it is incorrect to assume that the
iterator value will be NULL if the list is empty or no element
is found.

To fix the bug, return 'rule' when found, otherwise return NULL.

Fixes: ae7a5aff783c7 ("net: dsa: bcm_sf2: Keep copy of inserted rules")
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
Link: https://lore.kernel.org/r/20220328032431.22538-1-xiam0nd.tong@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/bcm_sf2_cfp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/bcm_sf2_cfp.c b/drivers/net/dsa/bcm_sf2_cfp.c
index d82cee5d9202..cbf44fc7d03a 100644
--- a/drivers/net/dsa/bcm_sf2_cfp.c
+++ b/drivers/net/dsa/bcm_sf2_cfp.c
@@ -567,14 +567,14 @@ static void bcm_sf2_cfp_slice_ipv6(struct bcm_sf2_priv *priv,
 static struct cfp_rule *bcm_sf2_cfp_rule_find(struct bcm_sf2_priv *priv,
 					      int port, u32 location)
 {
-	struct cfp_rule *rule = NULL;
+	struct cfp_rule *rule;
 
 	list_for_each_entry(rule, &priv->cfp.rules_list, next) {
 		if (rule->port == port && rule->fs.location == location)
-			break;
+			return rule;
 	}
 
-	return rule;
+	return NULL;
 }
 
 static int bcm_sf2_cfp_rule_cmp(struct bcm_sf2_priv *priv, int port,
-- 
2.34.1



