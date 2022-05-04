Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0E0251A786
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343861AbiEDRG6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:06:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355959AbiEDREs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:04:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 051C64F46F;
        Wed,  4 May 2022 09:53:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB645617DE;
        Wed,  4 May 2022 16:53:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BF11C385AA;
        Wed,  4 May 2022 16:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683215;
        bh=Ar5oqbUC5hoxxIpXqcghvo8zzA6Nwxw+7dgjprTBSD0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FkxnUdjeM8A8zAV/HaP6nz/gI4YumFtbvowdjodK+iRFBZiBjgSaeIv6kzFc6nLEH
         Z678/X9DpI50FM9xFNpG+4lj04q2sl9hdOY1SPul7nnOP2ijmu7STERQ60Li/1xW/L
         bHBsgyRhzQGrMIPrTi7AZFTFlA2ww4bbQGsKO+Kk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 080/177] net: dsa: Add missing of_node_put() in dsa_port_link_register_of
Date:   Wed,  4 May 2022 18:44:33 +0200
Message-Id: <20220504153100.227369061@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153053.873100034@linuxfoundation.org>
References: <20220504153053.873100034@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit fc06b2867f4cea543505acfb194c2be4ebf0c7d3 ]

The device_node pointer is returned by of_parse_phandle()  with refcount
incremented. We should use of_node_put() on it when done.
of_node_put() will check for NULL value.

Fixes: a20f997010c4 ("net: dsa: Don't instantiate phylink for CPU/DSA ports unless needed")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/port.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index 616330a16d31..63e88de96393 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -1201,8 +1201,10 @@ int dsa_port_link_register_of(struct dsa_port *dp)
 			if (ds->ops->phylink_mac_link_down)
 				ds->ops->phylink_mac_link_down(ds, port,
 					MLO_AN_FIXED, PHY_INTERFACE_MODE_NA);
+			of_node_put(phy_np);
 			return dsa_port_phylink_register(dp);
 		}
+		of_node_put(phy_np);
 		return 0;
 	}
 
-- 
2.35.1



