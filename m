Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 363034F43CD
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 00:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353530AbiDEMIz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:08:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358102AbiDEK16 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:27:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9B2F6C964;
        Tue,  5 Apr 2022 03:15:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 603F1B81B7A;
        Tue,  5 Apr 2022 10:15:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C177FC385A0;
        Tue,  5 Apr 2022 10:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153737;
        bh=jwHVmQzvD3veJPHy4KQUrd9zVR34Jq8Fpe1SDmhZEEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KCnsV6UGaYWIZaaI9LueRvQ5d+qw3MrGSirKM2xMCftps1I13BDtkRuq1Sxr4Mq/y
         DGLBMREzdWltd5SV+GzK9dfyunsexl1LiBcX3hwYsIo3q6nQLi+3IAWvrO9x1fbvKx
         DNJ1xwqxxnnCAqEwkqzRWh2nniU2iV4NMPiHnBXo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tobias Waldekranz <tobias@waldekranz.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 291/599] net: dsa: mv88e6xxx: Enable port policy support on 6097
Date:   Tue,  5 Apr 2022 09:29:45 +0200
Message-Id: <20220405070307.493608537@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
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

From: Tobias Waldekranz <tobias@waldekranz.com>

[ Upstream commit 585d42bb57bb358d48906660a8de273b078810b1 ]

This chip has support for the same per-port policy actions found in
later versions of LinkStreet devices.

Fixes: f3a2cd326e44 ("net: dsa: mv88e6xxx: introduce .port_set_policy")
Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 1992be77522a..e79a808375fc 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3297,6 +3297,7 @@ static const struct mv88e6xxx_ops mv88e6097_ops = {
 	.port_set_link = mv88e6xxx_port_set_link,
 	.port_set_speed_duplex = mv88e6185_port_set_speed_duplex,
 	.port_tag_remap = mv88e6095_port_tag_remap,
+	.port_set_policy = mv88e6352_port_set_policy,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
 	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
 	.port_set_ether_type = mv88e6351_port_set_ether_type,
-- 
2.34.1



