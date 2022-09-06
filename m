Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2D3A5AEA2B
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 15:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233245AbiIFNmA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:42:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233371AbiIFNkn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:40:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EA0A7B790;
        Tue,  6 Sep 2022 06:37:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF17DB816A0;
        Tue,  6 Sep 2022 13:36:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F2C4C433D7;
        Tue,  6 Sep 2022 13:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471360;
        bh=4i5sYG49tf9dNz8KHpFIUCVSBk6MKdxITrMG9BQRhAw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MlzPyB5ubxp+Gz/ZWyId053Kxi7c3nGcldE7Iq8R/sCiJcc/kUZMi9N41St//ZUx7
         eJBcb3OW8+9VQLvymr9sHeQjZ4rOJYuyHpqhFP0vlLEJv5814Y/vNq1W2CxTtKrI4T
         +e/Az7RXX4GD14Exw9OuZ5hobgnCl5dl4gVYQCNU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Ranquet <granquet@baylibre.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Pablo Sun <pablo.sun@mediatek.com>,
        Macpaul Lin <macpaul.lin@mediatek.com>
Subject: [PATCH 5.10 56/80] usb: typec: altmodes/displayport: correct pin assignment for UFP receptacles
Date:   Tue,  6 Sep 2022 15:30:53 +0200
Message-Id: <20220906132819.395576458@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132816.936069583@linuxfoundation.org>
References: <20220906132816.936069583@linuxfoundation.org>
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

From: Pablo Sun <pablo.sun@mediatek.com>

commit c1e5c2f0cb8a22ec2e14af92afc7006491bebabb upstream.

Fix incorrect pin assignment values when connecting to a monitor with
Type-C receptacle instead of a plug.

According to specification, an UFP_D receptacle's pin assignment
should came from the UFP_D pin assignments field (bit 23:16), while
an UFP_D plug's assignments are described in the DFP_D pin assignments
(bit 15:8) during Mode Discovery.

For example the LG 27 UL850-W is a monitor with Type-C receptacle.
The monitor responds to MODE DISCOVERY command with following
DisplayPort Capability flag:

        dp->alt->vdo=0x140045

The existing logic only take cares of UPF_D plug case,
and would take the bit 15:8 for this 0x140045 case.

This results in an non-existing pin assignment 0x0 in
dp_altmode_configure.

To fix this problem a new set of macros are introduced
to take plug/receptacle differences into consideration.

Fixes: 0e3bb7d6894d ("usb: typec: Add driver for DisplayPort alternate mode")
Cc: stable@vger.kernel.org
Co-developed-by: Pablo Sun <pablo.sun@mediatek.com>
Co-developed-by: Macpaul Lin <macpaul.lin@mediatek.com>
Reviewed-by: Guillaume Ranquet <granquet@baylibre.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Pablo Sun <pablo.sun@mediatek.com>
Signed-off-by: Macpaul Lin <macpaul.lin@mediatek.com>
Link: https://lore.kernel.org/r/20220804034803.19486-1-macpaul.lin@mediatek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/altmodes/displayport.c |    4 ++--
 include/linux/usb/typec_dp.h             |    5 +++++
 2 files changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/usb/typec/altmodes/displayport.c
+++ b/drivers/usb/typec/altmodes/displayport.c
@@ -88,8 +88,8 @@ static int dp_altmode_configure(struct d
 	case DP_STATUS_CON_UFP_D:
 	case DP_STATUS_CON_BOTH: /* NOTE: First acting as DP source */
 		conf |= DP_CONF_UFP_U_AS_UFP_D;
-		pin_assign = DP_CAP_DFP_D_PIN_ASSIGN(dp->alt->vdo) &
-			     DP_CAP_UFP_D_PIN_ASSIGN(dp->port->vdo);
+		pin_assign = DP_CAP_PIN_ASSIGN_UFP_D(dp->alt->vdo) &
+				 DP_CAP_PIN_ASSIGN_DFP_D(dp->port->vdo);
 		break;
 	default:
 		break;
--- a/include/linux/usb/typec_dp.h
+++ b/include/linux/usb/typec_dp.h
@@ -73,6 +73,11 @@ enum {
 #define DP_CAP_USB			BIT(7)
 #define DP_CAP_DFP_D_PIN_ASSIGN(_cap_)	(((_cap_) & GENMASK(15, 8)) >> 8)
 #define DP_CAP_UFP_D_PIN_ASSIGN(_cap_)	(((_cap_) & GENMASK(23, 16)) >> 16)
+/* Get pin assignment taking plug & receptacle into consideration */
+#define DP_CAP_PIN_ASSIGN_UFP_D(_cap_) ((_cap_ & DP_CAP_RECEPTACLE) ? \
+			DP_CAP_UFP_D_PIN_ASSIGN(_cap_) : DP_CAP_DFP_D_PIN_ASSIGN(_cap_))
+#define DP_CAP_PIN_ASSIGN_DFP_D(_cap_) ((_cap_ & DP_CAP_RECEPTACLE) ? \
+			DP_CAP_DFP_D_PIN_ASSIGN(_cap_) : DP_CAP_UFP_D_PIN_ASSIGN(_cap_))
 
 /* DisplayPort Status Update VDO bits */
 #define DP_STATUS_CONNECTION(_status_)	((_status_) & 3)


