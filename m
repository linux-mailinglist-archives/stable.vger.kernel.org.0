Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60E9F6B4553
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:33:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232584AbjCJOdL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:33:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232426AbjCJOcu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:32:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67492122CC2
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:31:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95F50B822AD
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:31:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED63FC433EF;
        Fri, 10 Mar 2023 14:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458716;
        bh=gHXetEGE0O4sV1tHB7TF+DnWwdU1Cq6wQ7udyCmfTrs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x/DvcyM3cHy3iwUmNMjZWTXuaqm05r0k0/vMyT62kqZlfQZQXWU+d2XBoxdmbsaPX
         3ppmmcNbMZ8tpaMD0Qg9KgTuZZ5MvRi6rtjq2bI7tGnDQlUyVFBp2hcmgNn91SI3u9
         2WJxNoYdWTXf88aNcFaaWe7kDu2q0sdeN8dwfrUc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yongqin Liu <yongqin.liu@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 090/357] thermal/drivers/hisi: Drop second sensor hi3660
Date:   Fri, 10 Mar 2023 14:36:19 +0100
Message-Id: <20230310133737.977342329@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yongqin Liu <yongqin.liu@linaro.org>

[ Upstream commit 15cc25829a97c3957e520e971868aacc84341317 ]

The commit 74c8e6bffbe1 ("driver core: Add __alloc_size hint to devm
allocators") exposes a panic "BRK handler: Fatal exception" on the
hi3660_thermal_probe funciton.
This is because the function allocates memory for only one
sensors array entry, but tries to fill up a second one.

Fix this by removing the unneeded second access.

Fixes: 7d3a2a2bbadb ("thermal/drivers/hisi: Fix number of sensors on hi3660")
Signed-off-by: Yongqin Liu <yongqin.liu@linaro.org>
Link: https://lore.kernel.org/linux-mm/20221101223321.1326815-5-keescook@chromium.org/
Link: https://lore.kernel.org/r/20230210141507.71014-1-yongqin.liu@linaro.org
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/hisi_thermal.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/thermal/hisi_thermal.c b/drivers/thermal/hisi_thermal.c
index 2d26ae80e2022..bee6d3524e52a 100644
--- a/drivers/thermal/hisi_thermal.c
+++ b/drivers/thermal/hisi_thermal.c
@@ -435,10 +435,6 @@ static int hi3660_thermal_probe(struct hisi_thermal_data *data)
 	data->sensor[0].irq_name = "tsensor_a73";
 	data->sensor[0].data = data;
 
-	data->sensor[1].id = HI3660_LITTLE_SENSOR;
-	data->sensor[1].irq_name = "tsensor_a53";
-	data->sensor[1].data = data;
-
 	return 0;
 }
 
-- 
2.39.2



