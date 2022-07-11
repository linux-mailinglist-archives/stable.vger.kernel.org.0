Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0744456FDE7
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 12:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234321AbiGKKCK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 06:02:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234369AbiGKKB3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 06:01:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24168B8E9E;
        Mon, 11 Jul 2022 02:28:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8CA886136E;
        Mon, 11 Jul 2022 09:28:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 936F8C34115;
        Mon, 11 Jul 2022 09:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531707;
        bh=J9gjBr0TQqFK/KpB6aju9Ih/fw36Qss8gW2FcaEI0Hw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kAtBgykUXR6gPR9lIBZ35/3un8woDyvMRyS7qk9tOUxGDm9IypagT12tirj9cDBbv
         saFv53xaX5ZwelyNnmOawlWv4ijYJ07gvcwqvi9TWthWExJgKLqwDtRGv3d6hedIjF
         0DFTqmWOXKMnKyH6graij2ajzZXsr8nKNyj/fgtg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mihai Sain <mihai.sain@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 202/230] ARM: at91: fix soc detection for SAM9X60 SiPs
Date:   Mon, 11 Jul 2022 11:07:38 +0200
Message-Id: <20220711090609.835572698@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
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

From: Mihai Sain <mihai.sain@microchip.com>

[ Upstream commit 35074df65a8d8c5328a83e2eea948f7bbc8e6e08 ]

Fix SoC detection for SAM9X60 SiPs:
SAM9X60D5M
SAM9X60D1G
SAM9X60D6K

Fixes: af3a10513cd6 ("drivers: soc: atmel: add per soc id and version match masks")
Signed-off-by: Mihai Sain <mihai.sain@microchip.com>
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/20220616081344.1978664-1-claudiu.beznea@microchip.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/atmel/soc.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/soc/atmel/soc.c b/drivers/soc/atmel/soc.c
index a490ad7e090f..9e3d37011447 100644
--- a/drivers/soc/atmel/soc.c
+++ b/drivers/soc/atmel/soc.c
@@ -91,14 +91,14 @@ static const struct at91_soc socs[] __initconst = {
 	AT91_SOC(SAM9X60_CIDR_MATCH, AT91_CIDR_MATCH_MASK,
 		 AT91_CIDR_VERSION_MASK, SAM9X60_EXID_MATCH,
 		 "sam9x60", "sam9x60"),
-	AT91_SOC(SAM9X60_CIDR_MATCH, SAM9X60_D5M_EXID_MATCH,
-		 AT91_CIDR_VERSION_MASK, SAM9X60_EXID_MATCH,
+	AT91_SOC(SAM9X60_CIDR_MATCH, AT91_CIDR_MATCH_MASK,
+		 AT91_CIDR_VERSION_MASK, SAM9X60_D5M_EXID_MATCH,
 		 "sam9x60 64MiB DDR2 SiP", "sam9x60"),
-	AT91_SOC(SAM9X60_CIDR_MATCH, SAM9X60_D1G_EXID_MATCH,
-		 AT91_CIDR_VERSION_MASK, SAM9X60_EXID_MATCH,
+	AT91_SOC(SAM9X60_CIDR_MATCH, AT91_CIDR_MATCH_MASK,
+		 AT91_CIDR_VERSION_MASK, SAM9X60_D1G_EXID_MATCH,
 		 "sam9x60 128MiB DDR2 SiP", "sam9x60"),
-	AT91_SOC(SAM9X60_CIDR_MATCH, SAM9X60_D6K_EXID_MATCH,
-		 AT91_CIDR_VERSION_MASK, SAM9X60_EXID_MATCH,
+	AT91_SOC(SAM9X60_CIDR_MATCH, AT91_CIDR_MATCH_MASK,
+		 AT91_CIDR_VERSION_MASK, SAM9X60_D6K_EXID_MATCH,
 		 "sam9x60 8MiB SDRAM SiP", "sam9x60"),
 #endif
 #ifdef CONFIG_SOC_SAMA5
-- 
2.35.1



