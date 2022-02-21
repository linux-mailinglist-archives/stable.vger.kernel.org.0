Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E53B74BE083
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:52:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347858AbiBUJOr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:14:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350060AbiBUJNL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:13:11 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFC462E0A8;
        Mon, 21 Feb 2022 01:06:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 56B92CE0E8B;
        Mon, 21 Feb 2022 09:06:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ED4EC340E9;
        Mon, 21 Feb 2022 09:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434380;
        bh=In4AzKn1wxAe9eTmNKIelQ3WOTNBZ/W4/QZ6HsBrqyA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YrLu5cBEwqoiG+zB4Fsq40faOx1PAXDAHSCTULj1c5RTqdL/6Cedb/XcxBOD9SEt8
         uN448QJmb/yDsH2CCsNAqnUFsN+9gCAZkKRVEk5B33R++laXAUO4NBTxQw8CB/zTX3
         uaJXWXspkJsxY7kAkc1og/D8nULDBuOLfIE8vwQQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wan Jiabing <wanjiabing@vivo.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 092/121] ARM: OMAP2+: hwmod: Add of_node_put() before break
Date:   Mon, 21 Feb 2022 09:49:44 +0100
Message-Id: <20220221084924.307292118@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084921.147454846@linuxfoundation.org>
References: <20220221084921.147454846@linuxfoundation.org>
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

From: Wan Jiabing <wanjiabing@vivo.com>

[ Upstream commit 80c469a0a03763f814715f3d12b6f3964c7423e8 ]

Fix following coccicheck warning:
./arch/arm/mach-omap2/omap_hwmod.c:753:1-23: WARNING: Function
for_each_matching_node should have of_node_put() before break

Early exits from for_each_matching_node should decrement the
node reference counter.

Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap2/omap_hwmod.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/omap_hwmod.c b/arch/arm/mach-omap2/omap_hwmod.c
index 9443f129859b2..1fd67abca055b 100644
--- a/arch/arm/mach-omap2/omap_hwmod.c
+++ b/arch/arm/mach-omap2/omap_hwmod.c
@@ -749,8 +749,10 @@ static int __init _init_clkctrl_providers(void)
 
 	for_each_matching_node(np, ti_clkctrl_match_table) {
 		ret = _setup_clkctrl_provider(np);
-		if (ret)
+		if (ret) {
+			of_node_put(np);
 			break;
+		}
 	}
 
 	return ret;
-- 
2.34.1



