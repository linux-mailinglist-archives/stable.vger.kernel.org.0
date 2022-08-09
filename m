Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E003C58DDB4
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 20:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344634AbiHISEL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 14:04:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344499AbiHISDd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 14:03:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BA89275D0;
        Tue,  9 Aug 2022 11:02:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D0C6A61028;
        Tue,  9 Aug 2022 18:01:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D803AC433D6;
        Tue,  9 Aug 2022 18:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660068119;
        bh=3SEtrh6MNpXnvKk3vVEPj7E7RPsWRJCj7UxewlvKznA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dqmY4VjtsHshm4Euv5YV1OEJo8VFyErs53U6z1HKOKwvG4l3duI5Z3HATZ7Ozvl0p
         RDKxkK6keoHlPtsjBBEm7x78wYWbO6PR3/kKRVMphkmEQRkLrduBdfwKVGIOfjET14
         BGebXetERLyX90hLzwMYYH5faWcgLMp7yk9yNtKQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 13/32] net: sungem_phy: Add of_node_put() for reference returned by of_get_parent()
Date:   Tue,  9 Aug 2022 20:00:04 +0200
Message-Id: <20220809175513.511637160@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220809175513.082573955@linuxfoundation.org>
References: <20220809175513.082573955@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liang He <windhl@126.com>

[ Upstream commit ebbbe23fdf6070e31509638df3321688358cc211 ]

In bcm5421_init(), we should call of_node_put() for the reference
returned by of_get_parent() which has increased the refcount.

Fixes: 3c326fe9cb7a ("[PATCH] ppc64: Add new PHY to sungem")
Signed-off-by: Liang He <windhl@126.com>
Link: https://lore.kernel.org/r/20220720131003.1287426-1-windhl@126.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/sungem_phy.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/sungem_phy.c b/drivers/net/sungem_phy.c
index 63a8ff816e59..e556b00dfed2 100644
--- a/drivers/net/sungem_phy.c
+++ b/drivers/net/sungem_phy.c
@@ -453,6 +453,7 @@ static int bcm5421_init(struct mii_phy* phy)
 		int can_low_power = 1;
 		if (np == NULL || of_get_property(np, "no-autolowpower", NULL))
 			can_low_power = 0;
+		of_node_put(np);
 		if (can_low_power) {
 			/* Enable automatic low-power */
 			sungem_phy_write(phy, 0x1c, 0x9002);
-- 
2.35.1



