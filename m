Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E6D46DF25A
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 12:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbjDLK50 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 06:57:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjDLK5Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 06:57:25 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C255E6EBA
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 03:57:20 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DEDFD1691;
        Wed, 12 Apr 2023 03:58:04 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id A16913F73F;
        Wed, 12 Apr 2023 03:57:19 -0700 (PDT)
From:   Suzuki K Poulose <suzuki.poulose@arm.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Steve Clevenger <scclevenger@os.amperecomputing.com>,
        James Clark <james.clark@arm.com>
Subject: [PATCH stable 4.14] coresight-etm4: Fix for() loop drvdata->nr_addr_cmp range bug
Date:   Wed, 12 Apr 2023 11:57:05 +0100
Message-Id: <20230412105705.710242-1-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <2023041128-almanac-hasty-c1f0@gregkh>
References: <2023041128-almanac-hasty-c1f0@gregkh>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit bf84937e882009075f57fd213836256fc65d96bc upstream

In etm4_enable_hw, fix for() loop range to represent address comparator pairs.

Fixes: 2e1cdfe184b5 ("coresight-etm4x: Adding CoreSight ETM4x driver")
Cc: stable@vger.kernel.org # 4.14.x
Signed-off-by: Steve Clevenger <scclevenger@os.amperecomputing.com>
Reviewed-by: James Clark <james.clark@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/4a4ee61ce8ef402615a4528b21a051de3444fb7b.1677540079.git.scclevenger@os.amperecomputing.com
---
 drivers/hwtracing/coresight/coresight-etm4x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm4x.c b/drivers/hwtracing/coresight/coresight-etm4x.c
index fb392688281b..7a82f51568d0 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x.c
@@ -150,7 +150,7 @@ static void etm4_enable_hw(void *info)
 		writel_relaxed(config->ss_pe_cmp[i],
 			       drvdata->base + TRCSSPCICRn(i));
 	}
-	for (i = 0; i < drvdata->nr_addr_cmp; i++) {
+	for (i = 0; i < drvdata->nr_addr_cmp * 2; i++) {
 		writeq_relaxed(config->addr_val[i],
 			       drvdata->base + TRCACVRn(i));
 		writeq_relaxed(config->addr_acc[i],
-- 
2.34.1

