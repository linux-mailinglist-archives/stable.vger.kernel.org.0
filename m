Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0408052919B
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233252AbiEPUJo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:09:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350866AbiEPUBo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 16:01:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5590E44753;
        Mon, 16 May 2022 12:55:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA36F60FD4;
        Mon, 16 May 2022 19:55:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55FE6C385AA;
        Mon, 16 May 2022 19:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730959;
        bh=zAIK8Scdfpm+47u/CP5vmP3dy1T/MXT6kt+ys0EhElw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pjaE8dFzGSUETlCgms0hoooQ5qNulQ7vvqn46zghIICLrfDm26z9wCWUG+9v3a+A2
         Mm6liXQviq0OYbQyX7KNPic0emOFbZpPBFSxxwbltt75oYLBn9WaAZAvVM07sYeiJf
         QCG2474KdrLnEald5mtHbHUX5hIdyaFN1KbCb5ms=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthew Hagan <mnhagan88@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 060/114] net: sfp: Add tx-fault workaround for Huawei MA5671A SFP ONT
Date:   Mon, 16 May 2022 21:36:34 +0200
Message-Id: <20220516193627.217051769@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193625.489108457@linuxfoundation.org>
References: <20220516193625.489108457@linuxfoundation.org>
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
index 4720b24ca51b..90dfefc1f5f8 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -250,6 +250,7 @@ struct sfp {
 	struct sfp_eeprom_id id;
 	unsigned int module_power_mW;
 	unsigned int module_t_start_up;
+	bool tx_fault_ignore;
 
 #if IS_ENABLED(CONFIG_HWMON)
 	struct sfp_diag diag;
@@ -1945,6 +1946,12 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
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
 
@@ -2397,7 +2404,10 @@ static void sfp_check_state(struct sfp *sfp)
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



