Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A34B566B08
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:03:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233440AbiGEMDv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:03:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233403AbiGEMDO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:03:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FD7418374;
        Tue,  5 Jul 2022 05:03:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC283B817D4;
        Tue,  5 Jul 2022 12:03:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2750AC385A2;
        Tue,  5 Jul 2022 12:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657022590;
        bh=QbrYS/RU5R8iMp2wKanbvTD0Py0IUdqsvNxuUk9AJB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AaMWpRZglWL5Zs1L2KiPI4ui63yVr52qlLRMoWHTlIo7qFqesJ4YJ5iwoyVuKvRiK
         3uaX52BvbusZtlgdB9miaMJqt+nc9M58Xpt8QaY6RB/x3YQUK1vqJmQq8rih58vl9Z
         XXQhAOKBypOpUAhQht1oMz++cu/fpP4t0FNmFsHc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 24/33] net: dsa: bcm_sf2: force pause link settings
Date:   Tue,  5 Jul 2022 13:58:16 +0200
Message-Id: <20220705115607.421454267@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115606.709817198@linuxfoundation.org>
References: <20220705115606.709817198@linuxfoundation.org>
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
@@ -599,6 +599,11 @@ force_link:
 		reg |= LINK_STS;
 	if (state->duplex == DUPLEX_FULL)
 		reg |= DUPLX_MODE;
+	if (state->pause & MLO_PAUSE_TXRX_MASK) {
+		if (state->pause & MLO_PAUSE_TX)
+			reg |= TXFLOW_CNTL;
+		reg |= RXFLOW_CNTL;
+	}
 
 	core_writel(priv, reg, offset);
 }


