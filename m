Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56D3D283A93
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727473AbgJEPfg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:35:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:34344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728215AbgJEPd6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:33:58 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56ECD208C7;
        Mon,  5 Oct 2020 15:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601912037;
        bh=4H/fR5q1JoOOjC4z3zPdkX31ixnSBx8yrYjHOz3qP/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P3km1637zFgs7QBmZwWSQ5XQYdi+RLckNVmZ5CMmaWw0FK7zxAFp3bjRm2rUmivjV
         BpVbZ8SyE2X0Hx4GFohKmEPiISGm7dDHV0pdQJxyAC1z/NXD1IJHwrzg93lDuKD+WT
         y3C6by6KKPhqdwVVkTc+GgNTGjYhaiELukoexaKE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 46/85] net: dsa: felix: fix some key offsets for IP4_TCP_UDP VCAP IS2 entries
Date:   Mon,  5 Oct 2020 17:26:42 +0200
Message-Id: <20201005142116.942841246@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142114.732094228@linuxfoundation.org>
References: <20201005142114.732094228@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>

[ Upstream commit 8b9e03cd08250c60409099c791e858157838d9eb ]

Some of the IS2 IP4_TCP_UDP keys are not correct, like L4_DPORT,
L4_SPORT and other L4 keys. This prevents offloaded tc-flower rules from
matching on src_port and dst_port for TCP and UDP packets.

Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 1dd9e348152d7..7c167a394b762 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -607,17 +607,17 @@ struct vcap_field vsc9959_vcap_is2_keys[] = {
 	[VCAP_IS2_HK_DIP_EQ_SIP]		= {118,   1},
 	/* IP4_TCP_UDP (TYPE=100) */
 	[VCAP_IS2_HK_TCP]			= {119,   1},
-	[VCAP_IS2_HK_L4_SPORT]			= {120,  16},
-	[VCAP_IS2_HK_L4_DPORT]			= {136,  16},
+	[VCAP_IS2_HK_L4_DPORT]			= {120,  16},
+	[VCAP_IS2_HK_L4_SPORT]			= {136,  16},
 	[VCAP_IS2_HK_L4_RNG]			= {152,   8},
 	[VCAP_IS2_HK_L4_SPORT_EQ_DPORT]		= {160,   1},
 	[VCAP_IS2_HK_L4_SEQUENCE_EQ0]		= {161,   1},
-	[VCAP_IS2_HK_L4_URG]			= {162,   1},
-	[VCAP_IS2_HK_L4_ACK]			= {163,   1},
-	[VCAP_IS2_HK_L4_PSH]			= {164,   1},
-	[VCAP_IS2_HK_L4_RST]			= {165,   1},
-	[VCAP_IS2_HK_L4_SYN]			= {166,   1},
-	[VCAP_IS2_HK_L4_FIN]			= {167,   1},
+	[VCAP_IS2_HK_L4_FIN]			= {162,   1},
+	[VCAP_IS2_HK_L4_SYN]			= {163,   1},
+	[VCAP_IS2_HK_L4_RST]			= {164,   1},
+	[VCAP_IS2_HK_L4_PSH]			= {165,   1},
+	[VCAP_IS2_HK_L4_ACK]			= {166,   1},
+	[VCAP_IS2_HK_L4_URG]			= {167,   1},
 	[VCAP_IS2_HK_L4_1588_DOM]		= {168,   8},
 	[VCAP_IS2_HK_L4_1588_VER]		= {176,   4},
 	/* IP4_OTHER (TYPE=101) */
-- 
2.25.1



