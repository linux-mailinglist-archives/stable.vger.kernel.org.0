Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF2A7603C17
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231194AbiJSInP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:43:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231189AbiJSImW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:42:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD8F042AD9;
        Wed, 19 Oct 2022 01:39:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 757E7B82234;
        Wed, 19 Oct 2022 08:39:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD57BC433C1;
        Wed, 19 Oct 2022 08:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666168784;
        bh=p5/X/8K03kH+hgzQsYC4VASRtCEOfafEweUf2IKRMd4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vdc6q2bO5agx1VQa4q/2GrYsfBcNvkOEac1nQGJt214SW2j/GwUY715+dGDTeAsej
         UNV/3LUODO9kdRqjquYKxdm7JgvzjjhZik1g9sJgcGsNSqo/tLyAYAhyj8qj6C+1Wl
         a67dE1DW7k6cOT9lspRNwfDWmiLeLuQa44eTog00=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Mengda Chen <chenmengda2009@163.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.0 052/862] hwmon: (gsc-hwmon) Call of_node_get() before of_find_xxx API
Date:   Wed, 19 Oct 2022 10:22:19 +0200
Message-Id: <20221019083252.285526333@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 		of_node_put(fan);


