Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E157566BC7
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:09:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234611AbiGEMJo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:09:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234956AbiGEMIN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:08:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A4411A05E;
        Tue,  5 Jul 2022 05:07:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AAD85B817D6;
        Tue,  5 Jul 2022 12:07:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDC11C341CB;
        Tue,  5 Jul 2022 12:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657022838;
        bh=I6nBQjLM1/cAfalksFjC0yxm4pri54FIPYoqdUEPRDo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cjwi123TzYXbdmApYeIqEFghvb5VkcPesLqKIr8G+ujPSZ9SPKDSJi//u1fswAZWC
         lgHUEFKzYjDAxMV6HJMy9euVOJXPlOd7zqR+kr3oBAKkNTxMR389g4kIOifSAU6t7w
         Dm4lqLtGHU7gbwnIDpU8cVn/lmc/OYEr/HMsA3JQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 5.10 28/84] PM / devfreq: exynos-ppmu: Fix refcount leak in of_get_devfreq_events
Date:   Tue,  5 Jul 2022 13:57:51 +0200
Message-Id: <20220705115616.147314835@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115615.323395630@linuxfoundation.org>
References: <20220705115615.323395630@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Miaoqian Lin <linmq006@gmail.com>

commit f44b799603a9b5d2e375b0b2d54dd0b791eddfc2 upstream.

of_get_child_by_name() returns a node pointer with refcount
incremented, we should use of_node_put() on it when done.
This function only calls of_node_put() in normal path,
missing it in error paths.
Add missing of_node_put() to avoid refcount leak.

Fixes: f262f28c1470 ("PM / devfreq: event: Add devfreq_event class")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/devfreq/event/exynos-ppmu.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/devfreq/event/exynos-ppmu.c
+++ b/drivers/devfreq/event/exynos-ppmu.c
@@ -514,15 +514,19 @@ static int of_get_devfreq_events(struct
 
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


