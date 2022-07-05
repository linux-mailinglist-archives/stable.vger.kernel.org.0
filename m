Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22CC6566D54
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236853AbiGEMWR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:22:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237664AbiGEMTe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:19:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B38D1AF20;
        Tue,  5 Jul 2022 05:16:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2AC0561A98;
        Tue,  5 Jul 2022 12:16:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32ED4C341C7;
        Tue,  5 Jul 2022 12:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023360;
        bh=AzEppktl3iMXpKZKusDV5yRb60MSK4FbE+GTaPKMriY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rAVPffiHjhXA73R6fPBwDqZjafyUugLz/rCQXRoeKgPtu7zWNVHPljPzXaus5ZlFv
         dLhO5Bn6EYaGMnxegYpwZyHvr40dhtRI0goaAOCG7ieP1D6cyvQUOKuUWYCzbUCKrR
         EUnq+jZJjj/T2+nyyrLCdwzGTe6N58ZDwexeJTxY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.18 031/102] net: dp83822: disable false carrier interrupt
Date:   Tue,  5 Jul 2022 13:57:57 +0200
Message-Id: <20220705115619.299386367@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115618.410217782@linuxfoundation.org>
References: <20220705115618.410217782@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Enguerrand de Ribaucourt <enguerrand.de-ribaucourt@savoirfairelinux.com>

commit c96614eeab663646f57f67aa591e015abd8bd0ba upstream.

When unplugging an Ethernet cable, false carrier events were produced by
the PHY at a very high rate. Once the false carrier counter full, an
interrupt was triggered every few clock cycles until the cable was
replugged. This resulted in approximately 10k/s interrupts.

Since the false carrier counter (FCSCR) is never used, we can safely
disable this interrupt.

In addition to improving performance, this also solved MDIO read
timeouts I was randomly encountering with an i.MX8 fec MAC because of
the interrupt flood. The interrupt count and MDIO timeout fix were
tested on a v5.4.110 kernel.

Fixes: 87461f7a58ab ("net: phy: DP83822 initial driver submission")
Signed-off-by: Enguerrand de Ribaucourt <enguerrand.de-ribaucourt@savoirfairelinux.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/dp83822.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/net/phy/dp83822.c
+++ b/drivers/net/phy/dp83822.c
@@ -229,7 +229,6 @@ static int dp83822_config_intr(struct ph
 			return misr_status;
 
 		misr_status |= (DP83822_RX_ERR_HF_INT_EN |
-				DP83822_FALSE_CARRIER_HF_INT_EN |
 				DP83822_LINK_STAT_INT_EN |
 				DP83822_ENERGY_DET_INT_EN |
 				DP83822_LINK_QUAL_INT_EN);


