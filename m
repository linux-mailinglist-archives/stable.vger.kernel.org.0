Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7070256C7EA
	for <lists+stable@lfdr.de>; Sat,  9 Jul 2022 10:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbiGIIS1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Jul 2022 04:18:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiGIIS0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Jul 2022 04:18:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76149747A7
        for <stable@vger.kernel.org>; Sat,  9 Jul 2022 01:18:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 237EEB818C8
        for <stable@vger.kernel.org>; Sat,  9 Jul 2022 08:18:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64977C3411C;
        Sat,  9 Jul 2022 08:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657354702;
        bh=EDIIA5bHBKdpEEoDeNkUK+e2gji4GB7rxO0SrpyfqA0=;
        h=Subject:To:Cc:From:Date:From;
        b=0i74muu4FNNmHJ5K4WVEioGaqiK8Zz3T6RC+Jhpnd05QHONZuVU+mJXruovf8rAP2
         H2QUn3mD3s0KjQUeRN2IPOCUBDvygbrgcqlgWyLHEb07TDz/jnijfRPEgKvTpTPt4U
         lhtNnvBcH3OfvaMgOpIv9snoItTe1d6HgpHfCQi0=
Subject: FAILED: patch "[PATCH] PM / devfreq: exynos-bus: Fix NULL pointer dereference" failed to apply to 5.18-stable tree
To:     ansuelsmth@gmail.com, cw00.choi@samsung.com,
        m.szyprowski@samsung.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 09 Jul 2022 10:18:20 +0200
Message-ID: <165735470099205@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.18-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c8934e4e348915caac54085c01fd9d04fa16134a Mon Sep 17 00:00:00 2001
From: Christian Marangi <ansuelsmth@gmail.com>
Date: Fri, 1 Jul 2022 15:31:26 +0200
Subject: [PATCH] PM / devfreq: exynos-bus: Fix NULL pointer dereference

Fix exynos-bus NULL pointer dereference by correctly using the local
generated freq_table to output the debug values instead of using the
profile freq_table that is not used in the driver.

Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Fixes: b5d281f6c16d ("PM / devfreq: Rework freq_table to be local to devfreq struct")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>

diff --git a/drivers/devfreq/exynos-bus.c b/drivers/devfreq/exynos-bus.c
index e689101abc93..f7dcc44f9414 100644
--- a/drivers/devfreq/exynos-bus.c
+++ b/drivers/devfreq/exynos-bus.c
@@ -447,9 +447,9 @@ static int exynos_bus_probe(struct platform_device *pdev)
 		}
 	}
 
-	max_state = bus->devfreq->profile->max_state;
-	min_freq = (bus->devfreq->profile->freq_table[0] / 1000);
-	max_freq = (bus->devfreq->profile->freq_table[max_state - 1] / 1000);
+	max_state = bus->devfreq->max_state;
+	min_freq = (bus->devfreq->freq_table[0] / 1000);
+	max_freq = (bus->devfreq->freq_table[max_state - 1] / 1000);
 	pr_info("exynos-bus: new bus device registered: %s (%6ld KHz ~ %6ld KHz)\n",
 			dev_name(dev), min_freq, max_freq);
 

