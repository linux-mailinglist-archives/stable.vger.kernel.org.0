Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33B005290AB
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346452AbiEPTyJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 15:54:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347511AbiEPTwK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:52:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86FD241F8C;
        Mon, 16 May 2022 12:47:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE769B81612;
        Mon, 16 May 2022 19:47:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28483C385AA;
        Mon, 16 May 2022 19:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730454;
        bh=DMfk2C4x4pFjrWAncW3ibnLRZMa9P+J5sL+rXn/mBoE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JTC5kbKyeUrhzQUKNLCF5Eb8ts87J8myjJDhWLrH+X98ghC2KWtlNBWj8ars5O0CW
         HdsLRqE7aStopY9fDAEHLHAvEP/EbGU5vycSU65BfFZh4BaT8SogfQt9ljXg60sZgs
         La4mWPz2mfT1L3FLfnR1s6KSNz+xkYWRHY2bikDE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthew Hagan <mnhagan88@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 37/66] net: sfp: Add tx-fault workaround for Huawei MA5671A SFP ONT
Date:   Mon, 16 May 2022 21:36:37 +0200
Message-Id: <20220516193620.487852712@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193619.400083785@linuxfoundation.org>
References: <20220516193619.400083785@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Hagan <mnhagan88@gmail.com>

[ Upstream commit 2069624dac19d62c558bb6468fe03678553ab01d ]

As noted elsewhere, various GPON SFP modules exhibit non-standard
TX-fault behaviour. In the tested case, the Huawei MA5671A, when used
in combination with a Marvell mv88e6085 switch, was found to
persistently assert TX-fault, resulting in the module being disabled.

This patch adds a quirk to ignore the SFP_F_TX_FAULT state, allowing the
module to function.

Change from v1: removal of erroneous return statment (Andrew Lunn)

Signed-off-by: Matthew Hagan <mnhagan88@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20220502223315.1973376-1-mnhagan88@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/sfp.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index efffa65f8214..96068e0d841a 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -249,6 +249,7 @@ struct sfp {
 	struct sfp_eeprom_id id;
 	unsigned int module_power_mW;
 	unsigned int module_t_start_up;
+	bool tx_fault_ignore;
 
 #if IS_ENABLED(CONFIG_HWMON)
 	struct sfp_diag diag;
@@ -1893,6 +1894,12 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
 	else
 		sfp->module_t_start_up = T_START_UP;
 
+	if (!memcmp(id.base.vendor_name, "HUAWEI          ", 16) &&
+	    !memcmp(id.base.vendor_pn, "MA5671A         ", 16))
+		sfp->tx_fault_ignore = true;
+	else
+		sfp->tx_fault_ignore = false;
+
 	return 0;
 }
 
@@ -2320,7 +2327,10 @@ static void sfp_check_state(struct sfp *sfp)
 	mutex_lock(&sfp->st_mutex);
 	state = sfp_get_state(sfp);
 	changed = state ^ sfp->state;
-	changed &= SFP_F_PRESENT | SFP_F_LOS | SFP_F_TX_FAULT;
+	if (sfp->tx_fault_ignore)
+		changed &= SFP_F_PRESENT | SFP_F_LOS;
+	else
+		changed &= SFP_F_PRESENT | SFP_F_LOS | SFP_F_TX_FAULT;
 
 	for (i = 0; i < GPIO_MAX; i++)
 		if (changed & BIT(i))
-- 
2.35.1



