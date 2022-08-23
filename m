Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBCBB59D658
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243601AbiHWJD5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:03:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240492AbiHWJCw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:02:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4A796CF49;
        Tue, 23 Aug 2022 01:28:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1359B81C35;
        Tue, 23 Aug 2022 08:27:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 368B3C433D6;
        Tue, 23 Aug 2022 08:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243261;
        bh=3agTiGGPSeveg7MES/sVEGH2c78Dw29TGthGj9XVZyo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d1I/IlwyiWsNRT69Lz+GcnSoR4ewM2DulbNkmv8PlPB1Kjk9Jq2gJFn/xvsk4Nj4t
         hjyTDWNVi8+ZUPjHLipjH+wyrV3OW0mW/uqIpt3NqrFQIIOD1diy/KctnQ9H/hEA/G
         rr5Q1NSSbv8Kwa4S0783itwE2737UOJB4g57k34Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rustam Subkhankulov <subkhankulov@ispras.ru>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.19 220/365] net: dsa: sja1105: fix buffer overflow in sja1105_setup_devlink_regions()
Date:   Tue, 23 Aug 2022 10:02:01 +0200
Message-Id: <20220823080127.381447830@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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
 drivers/net/dsa/sja1105/sja1105_devlink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/dsa/sja1105/sja1105_devlink.c
+++ b/drivers/net/dsa/sja1105/sja1105_devlink.c
@@ -93,7 +93,7 @@ static int sja1105_setup_devlink_regions
 
 		region = dsa_devlink_region_create(ds, ops, 1, size);
 		if (IS_ERR(region)) {
-			while (i-- >= 0)
+			while (--i >= 0)
 				dsa_devlink_region_destroy(priv->regions[i]);
 			return PTR_ERR(region);
 		}


