Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02C656D4994
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233744AbjDCOjU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:39:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233746AbjDCOjS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:39:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8009331988
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:39:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CAF5BB81CA8
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:39:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32F86C4339B;
        Mon,  3 Apr 2023 14:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532753;
        bh=a6mG5FKb02q1bL/eeUGR4r4kXmqIN29jjEwlBJPRBmQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b2aHHphisj3y5q53w/id63YTgTX/0/XQIzwf0UQwiHDr5358DpVmzWUEdXWQiAXF8
         wHwtcx1A8uZcdvEp1QVkDjdNiTmrGUAJ+pguHUoe9c2Ym0WvxSFeGuq8F4+pWErX/L
         DvKephEy7rPS3KbsNgSsypB0HxtHq7zc4Y1oplRk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sven Auhagen <sven.auhagen@voleatech.de>,
        Marcin Wojtas <mw@semihalf.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 103/181] net: mvpp2: classifier flow fix fragmentation flags
Date:   Mon,  3 Apr 2023 16:08:58 +0200
Message-Id: <20230403140418.455667676@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
References: <20230403140415.090615502@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,UPPERCASE_50_75 autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Auhagen <sven.auhagen@voleatech.de>

[ Upstream commit 9a251cae51d57289908222e6c322ca61fccc25fd ]

Add missing IP Fragmentation Flag.

Fixes: f9358e12a0af ("net: mvpp2: split ingress traffic into multiple flows")
Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
Reviewed-by: Marcin Wojtas <mw@semihalf.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/marvell/mvpp2/mvpp2_cls.c    | 30 +++++++++++--------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
index 41d935d1aaf6f..40aeaa7bd739f 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
@@ -62,35 +62,38 @@ static const struct mvpp2_cls_flow cls_flows[MVPP2_N_PRS_FLOWS] = {
 	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_FRAG_UNTAG,
 		       MVPP22_CLS_HEK_IP4_2T,
 		       MVPP2_PRS_RI_VLAN_NONE | MVPP2_PRS_RI_L3_IP4 |
-		       MVPP2_PRS_RI_L4_TCP,
+		       MVPP2_PRS_RI_IP_FRAG_TRUE | MVPP2_PRS_RI_L4_TCP,
 		       MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
 
 	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_FRAG_UNTAG,
 		       MVPP22_CLS_HEK_IP4_2T,
 		       MVPP2_PRS_RI_VLAN_NONE | MVPP2_PRS_RI_L3_IP4_OPT |
-		       MVPP2_PRS_RI_L4_TCP,
+		       MVPP2_PRS_RI_IP_FRAG_TRUE | MVPP2_PRS_RI_L4_TCP,
 		       MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
 
 	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_FRAG_UNTAG,
 		       MVPP22_CLS_HEK_IP4_2T,
 		       MVPP2_PRS_RI_VLAN_NONE | MVPP2_PRS_RI_L3_IP4_OTHER |
-		       MVPP2_PRS_RI_L4_TCP,
+		       MVPP2_PRS_RI_IP_FRAG_TRUE | MVPP2_PRS_RI_L4_TCP,
 		       MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
 
 	/* TCP over IPv4 flows, fragmented, with vlan tag */
 	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_FRAG_TAG,
 		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_TAGGED,
-		       MVPP2_PRS_RI_L3_IP4 | MVPP2_PRS_RI_L4_TCP,
+		       MVPP2_PRS_RI_L3_IP4 | MVPP2_PRS_RI_IP_FRAG_TRUE |
+			   MVPP2_PRS_RI_L4_TCP,
 		       MVPP2_PRS_IP_MASK),
 
 	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_FRAG_TAG,
 		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_TAGGED,
-		       MVPP2_PRS_RI_L3_IP4_OPT | MVPP2_PRS_RI_L4_TCP,
+		       MVPP2_PRS_RI_L3_IP4_OPT | MVPP2_PRS_RI_IP_FRAG_TRUE |
+			   MVPP2_PRS_RI_L4_TCP,
 		       MVPP2_PRS_IP_MASK),
 
 	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_FRAG_TAG,
 		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_TAGGED,
-		       MVPP2_PRS_RI_L3_IP4_OTHER | MVPP2_PRS_RI_L4_TCP,
+		       MVPP2_PRS_RI_L3_IP4_OTHER | MVPP2_PRS_RI_IP_FRAG_TRUE |
+			   MVPP2_PRS_RI_L4_TCP,
 		       MVPP2_PRS_IP_MASK),
 
 	/* UDP over IPv4 flows, Not fragmented, no vlan tag */
@@ -132,35 +135,38 @@ static const struct mvpp2_cls_flow cls_flows[MVPP2_N_PRS_FLOWS] = {
 	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_FRAG_UNTAG,
 		       MVPP22_CLS_HEK_IP4_2T,
 		       MVPP2_PRS_RI_VLAN_NONE | MVPP2_PRS_RI_L3_IP4 |
-		       MVPP2_PRS_RI_L4_UDP,
+		       MVPP2_PRS_RI_IP_FRAG_TRUE | MVPP2_PRS_RI_L4_UDP,
 		       MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
 
 	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_FRAG_UNTAG,
 		       MVPP22_CLS_HEK_IP4_2T,
 		       MVPP2_PRS_RI_VLAN_NONE | MVPP2_PRS_RI_L3_IP4_OPT |
-		       MVPP2_PRS_RI_L4_UDP,
+		       MVPP2_PRS_RI_IP_FRAG_TRUE | MVPP2_PRS_RI_L4_UDP,
 		       MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
 
 	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_FRAG_UNTAG,
 		       MVPP22_CLS_HEK_IP4_2T,
 		       MVPP2_PRS_RI_VLAN_NONE | MVPP2_PRS_RI_L3_IP4_OTHER |
-		       MVPP2_PRS_RI_L4_UDP,
+		       MVPP2_PRS_RI_IP_FRAG_TRUE | MVPP2_PRS_RI_L4_UDP,
 		       MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
 
 	/* UDP over IPv4 flows, fragmented, with vlan tag */
 	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_FRAG_TAG,
 		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_TAGGED,
-		       MVPP2_PRS_RI_L3_IP4 | MVPP2_PRS_RI_L4_UDP,
+		       MVPP2_PRS_RI_L3_IP4 | MVPP2_PRS_RI_IP_FRAG_TRUE |
+			   MVPP2_PRS_RI_L4_UDP,
 		       MVPP2_PRS_IP_MASK),
 
 	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_FRAG_TAG,
 		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_TAGGED,
-		       MVPP2_PRS_RI_L3_IP4_OPT | MVPP2_PRS_RI_L4_UDP,
+		       MVPP2_PRS_RI_L3_IP4_OPT | MVPP2_PRS_RI_IP_FRAG_TRUE |
+			   MVPP2_PRS_RI_L4_UDP,
 		       MVPP2_PRS_IP_MASK),
 
 	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_FRAG_TAG,
 		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_TAGGED,
-		       MVPP2_PRS_RI_L3_IP4_OTHER | MVPP2_PRS_RI_L4_UDP,
+		       MVPP2_PRS_RI_L3_IP4_OTHER | MVPP2_PRS_RI_IP_FRAG_TRUE |
+			   MVPP2_PRS_RI_L4_UDP,
 		       MVPP2_PRS_IP_MASK),
 
 	/* TCP over IPv6 flows, not fragmented, no vlan tag */
-- 
2.39.2



