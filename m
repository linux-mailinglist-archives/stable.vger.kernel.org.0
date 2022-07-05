Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5183E566BB3
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234439AbiGEMJb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:09:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234584AbiGEMHn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:07:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB2B3192B1;
        Tue,  5 Jul 2022 05:06:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C15BB817CE;
        Tue,  5 Jul 2022 12:06:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6F5FC341CD;
        Tue,  5 Jul 2022 12:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657022803;
        bh=A3qOj5tL46J93KWO7+54TFWF3EI/YpjYTSY9CkP5LXs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uSxaU/QfHaZJRfSqplfMazNA37qkO1f8+p9OM6zCmccMkzCfvzN/skoDsS7G40lqA
         PyhimIuJHqk/w7wQUjUqzYNK8iIhqrI00uheJRU66Ceo6rsQ+o48zrcr76fTdZ7Ykk
         cy6SWyPii1XR2kkpFHnkyTvwYyo+DyIfq/rqQCjc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 16/84] net: dsa: bcm_sf2: force pause link settings
Date:   Tue,  5 Jul 2022 13:57:39 +0200
Message-Id: <20220705115615.800909329@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115615.323395630@linuxfoundation.org>
References: <20220705115615.323395630@linuxfoundation.org>
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

From: Doug Berger <opendmb@gmail.com>

commit 7c97bc0128b2eecc703106112679a69d446d1a12 upstream.

The pause settings reported by the PHY should also be applied to the GMII port
status override otherwise the switch will not generate pause frames towards the
link partner despite the advertisement saying otherwise.

Fixes: 246d7f773c13 ("net: dsa: add Broadcom SF2 switch driver")
Signed-off-by: Doug Berger <opendmb@gmail.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20220623030204.1966851-1-f.fainelli@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/bcm_sf2.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -774,6 +774,11 @@ static void bcm_sf2_sw_mac_link_up(struc
 		if (duplex == DUPLEX_FULL)
 			reg |= DUPLX_MODE;
 
+		if (tx_pause)
+			reg |= TXFLOW_CNTL;
+		if (rx_pause)
+			reg |= RXFLOW_CNTL;
+
 		core_writel(priv, reg, offset);
 	}
 


