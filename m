Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 644105656AA
	for <lists+stable@lfdr.de>; Mon,  4 Jul 2022 15:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233758AbiGDNN2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jul 2022 09:13:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234662AbiGDNN1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jul 2022 09:13:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CD61F19
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 06:13:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D87C3B80EEB
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 13:13:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47088C341C7;
        Mon,  4 Jul 2022 13:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656940400;
        bh=xF73XFwYhKaga6x40dSy0sb2cKANb9f8BXDvs9oEUeM=;
        h=Subject:To:Cc:From:Date:From;
        b=jPDherWIRDBRZ0pX0RTTTI/LiV37+2TbfNC+SvZuKILwSP6QQaSZ/VqCCn6IQPNJK
         VxSL0rSKBFU1NO7+VzF0I6f5J1RjnEaatlpCDyDJ5dku2p/bwHbYxBZMZleiFVne5b
         3/bztkK29w4/ChB5vrZV4T+y6TfAEDiuAEv48hXA=
Subject: FAILED: patch "[PATCH] PM / devfreq: exynos-ppmu: Fix refcount leak in" failed to apply to 4.9-stable tree
To:     linmq006@gmail.com, cw00.choi@samsung.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 04 Jul 2022 15:13:10 +0200
Message-ID: <1656940390163254@kroah.com>
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


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f44b799603a9b5d2e375b0b2d54dd0b791eddfc2 Mon Sep 17 00:00:00 2001
From: Miaoqian Lin <linmq006@gmail.com>
Date: Thu, 26 May 2022 12:28:56 +0400
Subject: [PATCH] PM / devfreq: exynos-ppmu: Fix refcount leak in
 of_get_devfreq_events

of_get_child_by_name() returns a node pointer with refcount
incremented, we should use of_node_put() on it when done.
This function only calls of_node_put() in normal path,
missing it in error paths.
Add missing of_node_put() to avoid refcount leak.

Fixes: f262f28c1470 ("PM / devfreq: event: Add devfreq_event class")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>

diff --git a/drivers/devfreq/event/exynos-ppmu.c b/drivers/devfreq/event/exynos-ppmu.c
index 9b849d781116..a443e7c42daf 100644
--- a/drivers/devfreq/event/exynos-ppmu.c
+++ b/drivers/devfreq/event/exynos-ppmu.c
@@ -519,15 +519,19 @@ static int of_get_devfreq_events(struct device_node *np,
 
 	count = of_get_child_count(events_np);
 	desc = devm_kcalloc(dev, count, sizeof(*desc), GFP_KERNEL);
-	if (!desc)
+	if (!desc) {
+		of_node_put(events_np);
 		return -ENOMEM;
+	}
 	info->num_events = count;
 
 	of_id = of_match_device(exynos_ppmu_id_match, dev);
 	if (of_id)
 		info->ppmu_type = (enum exynos_ppmu_type)of_id->data;
-	else
+	else {
+		of_node_put(events_np);
 		return -EINVAL;
+	}
 
 	j = 0;
 	for_each_child_of_node(events_np, node) {

