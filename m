Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7638E4F2E33
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236625AbiDEI2P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239596AbiDEIUP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:20:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EBE5107;
        Tue,  5 Apr 2022 01:17:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF1B860B0A;
        Tue,  5 Apr 2022 08:17:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECEA3C385A0;
        Tue,  5 Apr 2022 08:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146621;
        bh=gSKk94JlnT76nQt2YzGKXOMGeTex5ODG6i1MtGdF5n0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YLtVEX8bETOpFdCILI0d+RlxCjZB+wGSFjP2xB3YSbkd8jDSD6SNg/DnVGFPrraOZ
         CfXY4xhkVV6btlvzaFp5bOwzBy+tcourC71grMoORZcgNtGbgSP+93Hm/WUL9dF01T
         6iOEqwcsFFT0Fh4OqoL5FwVaTz5+I6NkDstuUKfE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0829/1126] net: dsa: bcm_sf2_cfp: fix an incorrect NULL check on list iterator
Date:   Tue,  5 Apr 2022 09:26:16 +0200
Message-Id: <20220405070431.894152817@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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
index a7e2fcf2df2c..edbe5e7f1cb6 100644
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



