Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5BEA4BDB97
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:40:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245399AbiBUJjY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:39:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351604AbiBUJh3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:37:29 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C744A1D0CD;
        Mon, 21 Feb 2022 01:16:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 574E1CE0E79;
        Mon, 21 Feb 2022 09:16:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DFA7C340E9;
        Mon, 21 Feb 2022 09:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434967;
        bh=siYdtErxRQq6Omyemv47TzjiCPolt1EQ/d8lzU9lmSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a5ht++GHucYzzurRe5feLVQ9xAJShwuJaQ2Q2+c+GANgbgK6cbUjXwjRb317izJGB
         Sevxp+RsZo5FpXjShTHPap+y0GhZLP9Z1B0X/FROoyqe6jtJdZsNL4A7I6ZmtWnMSA
         7L/tjVT3YPEZc9noYVPnD6Tz/bgxoqpc4qq4YI04=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 5.15 195/196] i2c: brcmstb: fix support for DSL and CM variants
Date:   Mon, 21 Feb 2022 09:50:27 +0100
Message-Id: <20220221084937.458786699@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
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

From: Rafał Miłecki <rafal@milecki.pl>

commit 834cea3a252ed4847db076a769ad9efe06afe2d5 upstream.

DSL and CM (Cable Modem) support 8 B max transfer size and have a custom
DT binding for that reason. This driver was checking for a wrong
"compatible" however which resulted in an incorrect setup.

Fixes: e2e5a2c61837 ("i2c: brcmstb: Adding support for CM and DSL SoCs")
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-brcmstb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-brcmstb.c
+++ b/drivers/i2c/busses/i2c-brcmstb.c
@@ -673,7 +673,7 @@ static int brcmstb_i2c_probe(struct plat
 
 	/* set the data in/out register size for compatible SoCs */
 	if (of_device_is_compatible(dev->device->of_node,
-				    "brcmstb,brcmper-i2c"))
+				    "brcm,brcmper-i2c"))
 		dev->data_regsz = sizeof(u8);
 	else
 		dev->data_regsz = sizeof(u32);


