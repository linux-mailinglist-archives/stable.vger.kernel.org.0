Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E17BD4F24CC
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231728AbiDEHld (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:41:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231894AbiDEHl3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:41:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C84E2E9D0;
        Tue,  5 Apr 2022 00:39:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D653D6150D;
        Tue,  5 Apr 2022 07:39:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8A85C340EE;
        Tue,  5 Apr 2022 07:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144370;
        bh=iNiqVVs3RFLMStxPJaJA1NO2p1BzNFd9jBlWtITpKTY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fVIdhMKZiIlRTtHi0xfZ5TtvU11YJIvgECZzbBJeuIEm0MyZeDszka3Xl8ZJYEM0i
         9rSq9f6mPe2OdtJpbXQiK1Fva7152PWRpzjM+FSnJZKRISvy7CMM7918KOksyPzHaw
         LjjxGMoaBudvLNfRf22t5uxYV4KMhF/lNZXfGGgI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sven Peter <sven@svenpeter.dev>
Subject: [PATCH 5.17 0013/1126] usb: typec: tipd: Forward plug orientation to typec subsystem
Date:   Tue,  5 Apr 2022 09:12:40 +0200
Message-Id: <20220405070407.929240198@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

From: Sven Peter <sven@svenpeter.dev>

commit 676748389f5db74e7d28f9d630eebd75cb8a11b4 upstream.

In order to bring up the USB3 PHY on the Apple M1 we need to know the
orientation of the Type-C cable. Extract it from the status register and
forward it to the typec subsystem.

Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Sven Peter <sven@svenpeter.dev>
Link: https://lore.kernel.org/r/20220226125912.59828-1-sven@svenpeter.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tipd/core.c     |    5 +++++
 drivers/usb/typec/tipd/tps6598x.h |    1 +
 2 files changed, 6 insertions(+)

--- a/drivers/usb/typec/tipd/core.c
+++ b/drivers/usb/typec/tipd/core.c
@@ -256,6 +256,10 @@ static int tps6598x_connect(struct tps65
 	typec_set_pwr_opmode(tps->port, mode);
 	typec_set_pwr_role(tps->port, TPS_STATUS_TO_TYPEC_PORTROLE(status));
 	typec_set_vconn_role(tps->port, TPS_STATUS_TO_TYPEC_VCONN(status));
+	if (TPS_STATUS_TO_UPSIDE_DOWN(status))
+		typec_set_orientation(tps->port, TYPEC_ORIENTATION_REVERSE);
+	else
+		typec_set_orientation(tps->port, TYPEC_ORIENTATION_NORMAL);
 	tps6598x_set_data_role(tps, TPS_STATUS_TO_TYPEC_DATAROLE(status), true);
 
 	tps->partner = typec_register_partner(tps->port, &desc);
@@ -278,6 +282,7 @@ static void tps6598x_disconnect(struct t
 	typec_set_pwr_opmode(tps->port, TYPEC_PWR_MODE_USB);
 	typec_set_pwr_role(tps->port, TPS_STATUS_TO_TYPEC_PORTROLE(status));
 	typec_set_vconn_role(tps->port, TPS_STATUS_TO_TYPEC_VCONN(status));
+	typec_set_orientation(tps->port, TYPEC_ORIENTATION_NONE);
 	tps6598x_set_data_role(tps, TPS_STATUS_TO_TYPEC_DATAROLE(status), false);
 
 	power_supply_changed(tps->psy);
--- a/drivers/usb/typec/tipd/tps6598x.h
+++ b/drivers/usb/typec/tipd/tps6598x.h
@@ -17,6 +17,7 @@
 /* TPS_REG_STATUS bits */
 #define TPS_STATUS_PLUG_PRESENT		BIT(0)
 #define TPS_STATUS_PLUG_UPSIDE_DOWN	BIT(4)
+#define TPS_STATUS_TO_UPSIDE_DOWN(s)	(!!((s) & TPS_STATUS_PLUG_UPSIDE_DOWN))
 #define TPS_STATUS_PORTROLE		BIT(5)
 #define TPS_STATUS_TO_TYPEC_PORTROLE(s) (!!((s) & TPS_STATUS_PORTROLE))
 #define TPS_STATUS_DATAROLE		BIT(6)


