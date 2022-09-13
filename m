Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A48F75B6F6C
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232532AbiIMONx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:13:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232705AbiIMOM6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:12:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC0565AA2C;
        Tue, 13 Sep 2022 07:10:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1DBFAB80EFC;
        Tue, 13 Sep 2022 14:10:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B83CC433C1;
        Tue, 13 Sep 2022 14:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078206;
        bh=MUCm6y82PpyUWpOBizM5CO4R92B4DSw/MWs73QLkUos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L91An4fUmaaZ6PTlBAU5dpblcINi/OgUl9a1A2msBAuJZ6RHEj//tp2lFWlRzcyqr
         j9ZzAjYeSpQbzV1DZhAIFdDUjE6QHGdokd3qk/GNOeYApEhwwmD4BVrpVOiYD4lPpU
         2Ss8IV+CwVNREKiOfcQHRzCkzd6kRYNcpNFdradg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        stable <stable@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Huisong Li <lihuisong@huawei.com>
Subject: [PATCH 5.19 053/192] driver core: fix driver_set_override() issue with empty strings
Date:   Tue, 13 Sep 2022 16:02:39 +0200
Message-Id: <20220913140412.581153564@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 5666a274a6d54372d6b79b1f78682a9d827e679e upstream.

Python likes to send an empty string for some sysfs files, including the
driver_override field.  When commit 23d99baf9d72 ("PCI: Use
driver_set_override() instead of open-coding") moved the PCI core to use
the driver core function instead of hand-rolling their own handler, this
showed up as a regression from some userspace tools, like DPDK.

Fix this up by actually looking at the length of the string first
instead of trusting that userspace got it correct.

Fixes: 23d99baf9d72 ("PCI: Use driver_set_override() instead of open-coding")
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: stable <stable@kernel.org>
Reported-by: Stephen Hemminger <stephen@networkplumber.org>
Tested-by: Huisong Li <lihuisong@huawei.com>
Reviewed-by: Stephen Hemminger <stephen@networkplumber.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20220901163734.3583106-1-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/driver.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/base/driver.c
+++ b/drivers/base/driver.c
@@ -63,6 +63,12 @@ int driver_set_override(struct device *d
 	if (len >= (PAGE_SIZE - 1))
 		return -EINVAL;
 
+	/*
+	 * Compute the real length of the string in case userspace sends us a
+	 * bunch of \0 characters like python likes to do.
+	 */
+	len = strlen(s);
+
 	if (!len) {
 		/* Empty string passed - clear override */
 		device_lock(dev);


