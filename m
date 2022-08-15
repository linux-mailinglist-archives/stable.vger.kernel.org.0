Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67319593F65
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243563AbiHOVI6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:08:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347080AbiHOVGm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:06:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5FC063C9;
        Mon, 15 Aug 2022 12:15:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5CCAD60FAD;
        Mon, 15 Aug 2022 19:15:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64604C433D7;
        Mon, 15 Aug 2022 19:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590929;
        bh=nCWO8YIu1PEBiyHOTBnU4ZCYz8V+EBt7GoQJfXewjfw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GW5mQoB6La+JbS3RDSb92X4gcetEorChrPHRUZMHiMcRgMTPZTEFXaKq8DJNcnqzm
         uJx0fVbgLTPq/FVYbajHUuQpVIhRsifPdUjVRkN+FQBoNZYM0bjHoORgYfI2BsSyyp
         Ty3xYMfTnBlTU4jk3/BgSkRvFGPG9IGg82kln34Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0416/1095] net: dsa: felix: build as module when tc-taprio is module
Date:   Mon, 15 Aug 2022 19:56:55 +0200
Message-Id: <20220815180446.915381685@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 10ed11ab6399813eb652137db9c378433c28a95c ]

felix_vsc9959.c calls taprio_offload_get() and taprio_offload_free(),
symbols exported by net/sched/sch_taprio.c. As such, we must disallow
building the Felix driver as built-in when the symbol exported by
tc-taprio isn't present in the kernel image.

Fixes: 1c9017e44af2 ("net: dsa: felix: keep reference on entire tc-taprio config")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://lore.kernel.org/r/20220704190241.1288847-2-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/ocelot/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/ocelot/Kconfig b/drivers/net/dsa/ocelot/Kconfig
index 220b0b027b55..08db9cf76818 100644
--- a/drivers/net/dsa/ocelot/Kconfig
+++ b/drivers/net/dsa/ocelot/Kconfig
@@ -6,6 +6,7 @@ config NET_DSA_MSCC_FELIX
 	depends on NET_VENDOR_FREESCALE
 	depends on HAS_IOMEM
 	depends on PTP_1588_CLOCK_OPTIONAL
+	depends on NET_SCH_TAPRIO || NET_SCH_TAPRIO=n
 	select MSCC_OCELOT_SWITCH_LIB
 	select NET_DSA_TAG_OCELOT_8021Q
 	select NET_DSA_TAG_OCELOT
-- 
2.35.1



