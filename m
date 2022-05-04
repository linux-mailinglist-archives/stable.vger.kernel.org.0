Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DECC51A6B9
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 18:54:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354477AbiEDQ6R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 12:58:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354079AbiEDQ5O (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 12:57:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2AEA49F9D;
        Wed,  4 May 2022 09:50:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6F3AFB82752;
        Wed,  4 May 2022 16:49:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DFF5C385A4;
        Wed,  4 May 2022 16:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651682998;
        bh=d7FYk8CcoJFVfmacnUDKuqx+IN8JrgInU5TLM/A7XjQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Id3r1cpYu1ff2inQjCx088+M4zaIor5fABM9XBzDAW9nRCIhPIKUHtv9wVDirH2Ud
         ENBcpcNM8Hut59hMONiG05xgTJMBlcDVVGcQnOPNC3/4Qmr/elBdssXRrhVtxtdcpl
         eO8Gvjh0eAn30FPcCEvtQlu4NwHgwzh8L+WAm2x4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable <stable@kernel.org>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH 5.10 027/129] usb: phy: generic: Get the vbus supply
Date:   Wed,  4 May 2022 18:43:39 +0200
Message-Id: <20220504153023.449364787@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153021.299025455@linuxfoundation.org>
References: <20220504153021.299025455@linuxfoundation.org>
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

From: Sean Anderson <sean.anderson@seco.com>

commit 03e607cbb2931374db1825f371e9c7f28526d3f4 upstream.

While support for working with a vbus was added, the regulator was never
actually gotten (despite what was documented). Fix this by actually
getting the supply from the device tree.

Fixes: 7acc9973e3c4 ("usb: phy: generic: add vbus support")
Cc: stable <stable@kernel.org>
Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Link: https://lore.kernel.org/r/20220425171412.1188485-3-sean.anderson@seco.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/phy/phy-generic.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/phy/phy-generic.c
+++ b/drivers/usb/phy/phy-generic.c
@@ -268,6 +268,13 @@ int usb_phy_gen_create_phy(struct device
 			return -EPROBE_DEFER;
 	}
 
+	nop->vbus_draw = devm_regulator_get_exclusive(dev, "vbus");
+	if (PTR_ERR(nop->vbus_draw) == -ENODEV)
+		nop->vbus_draw = NULL;
+	if (IS_ERR(nop->vbus_draw))
+		return dev_err_probe(dev, PTR_ERR(nop->vbus_draw),
+				     "could not get vbus regulator\n");
+
 	nop->dev		= dev;
 	nop->phy.dev		= nop->dev;
 	nop->phy.label		= "nop-xceiv";


