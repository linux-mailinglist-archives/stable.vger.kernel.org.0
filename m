Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB0B35014DE
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344886AbiDNNtn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:49:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344286AbiDNNkh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:40:37 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5603D120;
        Thu, 14 Apr 2022 06:38:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C43D6CE296C;
        Thu, 14 Apr 2022 13:38:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0A59C385A1;
        Thu, 14 Apr 2022 13:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943490;
        bh=aBLnrYbFg0SEzV9XqSQqHdOnr+QHRmjllQIhQ/14OPk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EtWjaql7171t0YQRxBnMbw7uhmdiuY/9OZ+08kwV8GVOvQl8VQvoc4UA2GiCm1zhv
         m4j5MRxZajG/9PXm7FaiGKuf48ll8M/yooCtM7pTOG85mN7gmlklD0JecobCO9FIos
         gOAxK1y7NM8fT/R0CplRLOoTcgqzTFN65FHfuIUM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tobias Waldekranz <tobias@waldekranz.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 172/475] net: dsa: mv88e6xxx: Enable port policy support on 6097
Date:   Thu, 14 Apr 2022 15:09:17 +0200
Message-Id: <20220414110859.950098375@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
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
index 40b105daaf9e..87d28ef82559 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3062,6 +3062,7 @@ static const struct mv88e6xxx_ops mv88e6097_ops = {
 	.port_set_duplex = mv88e6xxx_port_set_duplex,
 	.port_set_speed = mv88e6185_port_set_speed,
 	.port_tag_remap = mv88e6095_port_tag_remap,
+	.port_set_policy = mv88e6352_port_set_policy,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
 	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
 	.port_set_ether_type = mv88e6351_port_set_ether_type,
-- 
2.34.1



