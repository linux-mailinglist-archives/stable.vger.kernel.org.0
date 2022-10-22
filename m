Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1E016085C7
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbiJVHjH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:39:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230440AbiJVHii (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:38:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE4DB25CDA8;
        Sat, 22 Oct 2022 00:36:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A18660ADD;
        Sat, 22 Oct 2022 07:36:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FC1EC433C1;
        Sat, 22 Oct 2022 07:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424159;
        bh=pz2UwXMRKNrNA4L+NtDLBqs3w52XvYBv/P4Jt38nelM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=puq8u2MLIYdvKdQwLvc8YMM1kEXdx6mkNQYpECwLUd6BQUxYXz3gfyn+ANDsIZTjU
         pQlniGL1BUlSkFIkP0Gt/yhqLKhshFLaC0pmxDvrITPZRK5KpUaBbAbSuvXTCkFao0
         FwawAg9R+h0bb5CabbEr1FapBDqSNbfK8ttfRWmI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Mengda Chen <chenmengda2009@163.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.19 046/717] hwmon: (gsc-hwmon) Call of_node_get() before of_find_xxx API
Date:   Sat, 22 Oct 2022 09:18:45 +0200
Message-Id: <20221022072423.257748921@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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


