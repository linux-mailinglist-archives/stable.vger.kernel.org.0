Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 099F55AEBB6
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241377AbiIFOQG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:16:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241394AbiIFOOh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 10:14:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D7CA79A78;
        Tue,  6 Sep 2022 06:49:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1B6D0B818CB;
        Tue,  6 Sep 2022 13:47:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 713C4C433C1;
        Tue,  6 Sep 2022 13:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662472067;
        bh=Iuy7BZ0X0UGXwqnlqbPz/nd5nuA2OnCTcw//Ec+dP1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y6+002eVTqzbOn/wHKZxRNZVhz1YEDIOv1A4FQx136TQOAIP/CxmNEY2KbSN9k1KN
         AZWfn3LzQ6YFHpIuhHNxAmGW/Uj4TNIdukOZ2ysXVeo14s3PmqWZx4ERv4goEEzaZj
         LT2MV3TvuEPN7euVhE5p/cnj12xDAaDAtCNugPqA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 5.19 106/155] thunderbolt: Check router generation before connecting xHCI
Date:   Tue,  6 Sep 2022 15:30:54 +0200
Message-Id: <20220906132833.953858129@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
References: <20220906132829.417117002@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit 93a3c0d4e8bfbb15145e5dd7da68a3de4b904aba upstream.

Only Thunderbolt 3 routers need the xHCI connection flow. This also
ensures the router actually has both lane adapters (1 and 3). While
there move declaration of the boolean variables inside the block where
they are being used.

Fixes: 30a4eca69b76 ("thunderbolt: Add internal xHCI connect flows for Thunderbolt 3 devices")
Cc: stable@vger.kernel.org
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/switch.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/thunderbolt/switch.c
+++ b/drivers/thunderbolt/switch.c
@@ -3781,14 +3781,18 @@ int tb_switch_pcie_l1_enable(struct tb_s
  */
 int tb_switch_xhci_connect(struct tb_switch *sw)
 {
-	bool usb_port1, usb_port3, xhci_port1, xhci_port3;
 	struct tb_port *port1, *port3;
 	int ret;
 
+	if (sw->generation != 3)
+		return 0;
+
 	port1 = &sw->ports[1];
 	port3 = &sw->ports[3];
 
 	if (tb_switch_is_alpine_ridge(sw)) {
+		bool usb_port1, usb_port3, xhci_port1, xhci_port3;
+
 		usb_port1 = tb_lc_is_usb_plugged(port1);
 		usb_port3 = tb_lc_is_usb_plugged(port3);
 		xhci_port1 = tb_lc_is_xhci_connected(port1);


