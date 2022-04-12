Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ECCB4FD8A0
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377234AbiDLHtO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:49:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357957AbiDLHk4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:40:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB93E3B023;
        Tue, 12 Apr 2022 00:17:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F37F6171C;
        Tue, 12 Apr 2022 07:17:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EAC4C385A1;
        Tue, 12 Apr 2022 07:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747827;
        bh=LBlGdq6vz+9VNDx+bAUfEJCL60i/v7PjWpnupljX3dY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YsvDVCX2/SN5A6ScWd1L/Km9b1SnzQplGLlcW/T1CzmEjBUuvnfbwfFuYkXv7Ee1U
         GRRd2HGjZYu5/19Z63K6Q4oPw6o1vw90ZvaeuLPR3lQHlrJ08MgH07dVQtsRLToHMs
         +2yZdNpjVyuc0tK+3vfNtgMyzSItfe3tqIBAeVjM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Axel Lin <axel.lin@ingics.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 220/343] regulator: atc260x: Fix missing active_discharge_on setting
Date:   Tue, 12 Apr 2022 08:30:38 +0200
Message-Id: <20220412062957.690976788@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
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

From: Axel Lin <axel.lin@ingics.com>

[ Upstream commit 2316f0fc0ad2aa87a568ceaf3d76be983ee555c3 ]

Without active_discharge_on setting, the SWITCH1 discharge enable control
is always disabled. Fix it.

Fixes: 3b15ccac161a ("regulator: Add regulator driver for ATC260x PMICs")
Signed-off-by: Axel Lin <axel.lin@ingics.com>
Link: https://lore.kernel.org/r/20220403132235.123727-1-axel.lin@ingics.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/atc260x-regulator.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/atc260x-regulator.c b/drivers/regulator/atc260x-regulator.c
index 05147d2c3842..485e58b264c0 100644
--- a/drivers/regulator/atc260x-regulator.c
+++ b/drivers/regulator/atc260x-regulator.c
@@ -292,6 +292,7 @@ enum atc2603c_reg_ids {
 	.bypass_mask = BIT(5), \
 	.active_discharge_reg = ATC2603C_PMU_SWITCH_CTL, \
 	.active_discharge_mask = BIT(1), \
+	.active_discharge_on = BIT(1), \
 	.owner = THIS_MODULE, \
 }
 
-- 
2.35.1



