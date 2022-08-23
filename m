Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B613159E347
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:43:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353989AbiHWMSL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 08:18:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356004AbiHWMPk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 08:15:40 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 774B079697;
        Tue, 23 Aug 2022 02:41:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 49880CE1B58;
        Tue, 23 Aug 2022 09:39:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60F61C433C1;
        Tue, 23 Aug 2022 09:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247594;
        bh=jCgrNFOMkzIfQkvmFRUBShrSXcsnNAqOEKWnP3VWncU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JXcRUu1HicTvymdVdM7DRf9O0EpoUaWhuOeR0wcqFVehnsjPhKU1loFhNaf1c3l3K
         ozoXUskWeQer3PrlIfCOj2o0GXuq4L4dgOvcImrAVqWtaXHZab5WzfGm9QBVe2ZMXJ
         Fvu4q7f/GoONM6qX7ARnJ2n23l4g9ltzB/XspN5k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rustam Subkhankulov <subkhankulov@ispras.ru>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 085/158] net: dsa: sja1105: fix buffer overflow in sja1105_setup_devlink_regions()
Date:   Tue, 23 Aug 2022 10:26:57 +0200
Message-Id: <20220823080049.491475845@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080046.056825146@linuxfoundation.org>
References: <20220823080046.056825146@linuxfoundation.org>
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

From: Rustam Subkhankulov <subkhankulov@ispras.ru>

commit fd8e899cdb5ecaf8e8ee73854a99e10807eef1de upstream.

If an error occurs in dsa_devlink_region_create(), then 'priv->regions'
array will be accessed by negative index '-1'.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Rustam Subkhankulov <subkhankulov@ispras.ru>
Fixes: bf425b82059e ("net: dsa: sja1105: expose static config as devlink region")
Link: https://lore.kernel.org/r/20220817003845.389644-1-subkhankulov@ispras.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/sja1105/sja1105_devlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_devlink.c b/drivers/net/dsa/sja1105/sja1105_devlink.c
index 0569ff066634..10c6fea1227f 100644
--- a/drivers/net/dsa/sja1105/sja1105_devlink.c
+++ b/drivers/net/dsa/sja1105/sja1105_devlink.c
@@ -93,7 +93,7 @@ static int sja1105_setup_devlink_regions(struct dsa_switch *ds)
 
 		region = dsa_devlink_region_create(ds, ops, 1, size);
 		if (IS_ERR(region)) {
-			while (i-- >= 0)
+			while (--i >= 0)
 				dsa_devlink_region_destroy(priv->regions[i]);
 			return PTR_ERR(region);
 		}
-- 
2.37.2



