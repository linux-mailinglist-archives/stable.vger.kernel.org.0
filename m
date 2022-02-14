Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21FDC4B4B55
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:41:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244326AbiBNKbf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:31:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348928AbiBNKbM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:31:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDFF5216;
        Mon, 14 Feb 2022 01:59:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 24A4A60921;
        Mon, 14 Feb 2022 09:59:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A553C340E9;
        Mon, 14 Feb 2022 09:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832785;
        bh=aJUAwIrosiZGWRzf6yXVGdTcM6ZHiOGnt5DM2fqHz2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ViRjUuN76qrmULet0l4daaRHMQwdGzppKLxJ8rGOxt6hJLs3HM6hKZN2BusPCxO6t
         lcdHb1NCcwiLl5nm/2VJx8R7ecfywjtGv+kzIBDs4jZyDuWaW3Xq4RBIXx/Zq/0+fu
         uk7nfWXBV1MzU32NGsZ2q4CccECv8hVZU/euvDD0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 124/203] net: mscc: ocelot: fix all IP traffic getting trapped to CPU with PTP over IP
Date:   Mon, 14 Feb 2022 10:26:08 +0100
Message-Id: <20220214092514.451740366@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 59085208e4a2183998964844f8684fea0378128d ]

The filters for the PTP trap keys are incorrectly configured, in the
sense that is2_entry_set() only looks at trap->key.ipv4.dport or
trap->key.ipv6.dport if trap->key.ipv4.proto or trap->key.ipv6.proto is
set to IPPROTO_TCP or IPPROTO_UDP.

But we don't do that, so is2_entry_set() goes through the "else" branch
of the IP protocol check, and ends up installing a rule for "Any IP
protocol match" (because msk is also 0). The UDP port is ignored.

This means that when we run "ptp4l -i swp0 -4", all IP traffic is
trapped to the CPU, which hinders bridging.

Fix this by specifying the IP protocol in the VCAP IS2 filters for PTP
over UDP.

Fixes: 96ca08c05838 ("net: mscc: ocelot: set up traps for PTP packets")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mscc/ocelot.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 294bb4eb3833f..ac5849436d021 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1292,6 +1292,8 @@ static void
 ocelot_populate_ipv4_ptp_event_trap_key(struct ocelot_vcap_filter *trap)
 {
 	trap->key_type = OCELOT_VCAP_KEY_IPV4;
+	trap->key.ipv4.proto.value[0] = IPPROTO_UDP;
+	trap->key.ipv4.proto.mask[0] = 0xff;
 	trap->key.ipv4.dport.value = PTP_EV_PORT;
 	trap->key.ipv4.dport.mask = 0xffff;
 }
@@ -1300,6 +1302,8 @@ static void
 ocelot_populate_ipv6_ptp_event_trap_key(struct ocelot_vcap_filter *trap)
 {
 	trap->key_type = OCELOT_VCAP_KEY_IPV6;
+	trap->key.ipv4.proto.value[0] = IPPROTO_UDP;
+	trap->key.ipv4.proto.mask[0] = 0xff;
 	trap->key.ipv6.dport.value = PTP_EV_PORT;
 	trap->key.ipv6.dport.mask = 0xffff;
 }
@@ -1308,6 +1312,8 @@ static void
 ocelot_populate_ipv4_ptp_general_trap_key(struct ocelot_vcap_filter *trap)
 {
 	trap->key_type = OCELOT_VCAP_KEY_IPV4;
+	trap->key.ipv4.proto.value[0] = IPPROTO_UDP;
+	trap->key.ipv4.proto.mask[0] = 0xff;
 	trap->key.ipv4.dport.value = PTP_GEN_PORT;
 	trap->key.ipv4.dport.mask = 0xffff;
 }
@@ -1316,6 +1322,8 @@ static void
 ocelot_populate_ipv6_ptp_general_trap_key(struct ocelot_vcap_filter *trap)
 {
 	trap->key_type = OCELOT_VCAP_KEY_IPV6;
+	trap->key.ipv4.proto.value[0] = IPPROTO_UDP;
+	trap->key.ipv4.proto.mask[0] = 0xff;
 	trap->key.ipv6.dport.value = PTP_GEN_PORT;
 	trap->key.ipv6.dport.mask = 0xffff;
 }
-- 
2.34.1



