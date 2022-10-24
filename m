Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E120260B11D
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 18:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231566AbiJXQP7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 12:15:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234809AbiJXQPN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 12:15:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA8B7459AA;
        Mon, 24 Oct 2022 08:03:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B8C4B81597;
        Mon, 24 Oct 2022 12:17:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A12A1C433B5;
        Mon, 24 Oct 2022 12:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613829;
        bh=pz2UwXMRKNrNA4L+NtDLBqs3w52XvYBv/P4Jt38nelM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pw2sbVyDktc00PH/ZqggElW8sSdFG0Pe6Ecj8hdM7FRLRTran1NWYy8BJl28mohXP
         srQsXG12GZyn1PUUjkTeDNLjHtOPeUcZ2O6qRuceVqj8oSk6ExD6LWD4mvEQtVz+zR
         pKXwEBWEgKTS1PL0Z7o5S3BvZTvhjdVS+ho8nf/c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Mengda Chen <chenmengda2009@163.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.10 030/390] hwmon: (gsc-hwmon) Call of_node_get() before of_find_xxx API
Date:   Mon, 24 Oct 2022 13:27:07 +0200
Message-Id: <20221024113023.875915601@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liang He <windhl@126.com>

commit 7f62cf781e6567d59c8935dc8c6068ce2bb904b7 upstream.

In gsc_hwmon_get_devtree_pdata(), we should call of_node_get() before
the of_find_compatible_node() which will automatically call
of_node_put() for the 'from' argument.

Fixes: 3bce5377ef66 ("hwmon: Add Gateworks System Controller support")
Signed-off-by: Liang He <windhl@126.com>
Co-developed-by: Mengda Chen <chenmengda2009@163.com>
Signed-off-by: Mengda Chen <chenmengda2009@163.com>
Link: https://lore.kernel.org/r/20220916154708.3084515-1-chenmengda2009@163.com
Cc: stable@vger.kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/gsc-hwmon.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/hwmon/gsc-hwmon.c
+++ b/drivers/hwmon/gsc-hwmon.c
@@ -267,6 +267,7 @@ gsc_hwmon_get_devtree_pdata(struct devic
 	pdata->nchannels = nchannels;
 
 	/* fan controller base address */
+	of_node_get(dev->parent->of_node);
 	fan = of_find_compatible_node(dev->parent->of_node, NULL, "gw,gsc-fan");
 	if (fan && of_property_read_u32(fan, "reg", &pdata->fan_base)) {
 		dev_err(dev, "fan node without base\n");


