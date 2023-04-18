Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F39FB6E6245
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:31:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231564AbjDRMb1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:31:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231661AbjDRMbS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:31:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5FCB10266
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:30:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF7996313B
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:30:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C309AC4339E;
        Tue, 18 Apr 2023 12:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821056;
        bh=UwAHvUIjp3nYOSwv4c7kg7PDjSa/URXdq1MvhJC35CA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vqm0MXFf1WBrEwqw0C7iNB4xdjyCgGntKrAQBaAkMMzcL1pQHnYrFVc8H+SMpBNtV
         8Lv9pCZhcyXbd1V06OL3G3uUk4ZpdYXG1BE3LUhRzRj3XD9tTrM4uxyCa0lT6/fbgW
         ymhIE2JDpQsh3Ofry3v64YT+LEOu8fVqDZUrlsuY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Steve Clevenger <scclevenger@os.amperecomputing.com>,
        James Clark <james.clark@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 5.4 75/92] coresight-etm4: Fix for() loop drvdata->nr_addr_cmp range bug
Date:   Tue, 18 Apr 2023 14:21:50 +0200
Message-Id: <20230418120307.416582349@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120304.658273364@linuxfoundation.org>
References: <20230418120304.658273364@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve Clevenger <scclevenger@os.amperecomputing.com>

commit bf84937e882009075f57fd213836256fc65d96bc upstream.

In etm4_enable_hw, fix for() loop range to represent address comparator pairs.

Fixes: 2e1cdfe184b5 ("coresight-etm4x: Adding CoreSight ETM4x driver")
Cc: stable@vger.kernel.org
Signed-off-by: Steve Clevenger <scclevenger@os.amperecomputing.com>
Reviewed-by: James Clark <james.clark@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/4a4ee61ce8ef402615a4528b21a051de3444fb7b.1677540079.git.scclevenger@os.amperecomputing.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwtracing/coresight/coresight-etm4x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwtracing/coresight/coresight-etm4x.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x.c
@@ -156,7 +156,7 @@ static int etm4_enable_hw(struct etmv4_d
 		writel_relaxed(config->ss_pe_cmp[i],
 			       drvdata->base + TRCSSPCICRn(i));
 	}
-	for (i = 0; i < drvdata->nr_addr_cmp; i++) {
+	for (i = 0; i < drvdata->nr_addr_cmp * 2; i++) {
 		writeq_relaxed(config->addr_val[i],
 			       drvdata->base + TRCACVRn(i));
 		writeq_relaxed(config->addr_acc[i],


