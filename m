Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F40B56DEF7F
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231241AbjDLIvU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:51:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231342AbjDLIvR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:51:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9375903B
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:50:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 960046317C
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:50:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA1EEC433D2;
        Wed, 12 Apr 2023 08:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289452;
        bh=+wPbTRfenOfWq7UEujuOoPuctD1IGdzvO57c4X6CL1s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aedvEopkX1nuORTU2mi6BDiMLG1ALLnv9muJqpv6fQby9wVwYW/jXGxYknLmt2bRH
         G4Nc9YjT0rAaMKnktg1ud8OTvCsOuZ00zhoojr306kK/SvQWkdJ40gu7IhP7vDyAKW
         0zEigsG2zEt17diKsXwkEpd0rSmIbVlHnUvZLvTI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Steve Clevenger <scclevenger@os.amperecomputing.com>,
        James Clark <james.clark@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 6.2 105/173] coresight-etm4: Fix for() loop drvdata->nr_addr_cmp range bug
Date:   Wed, 12 Apr 2023 10:33:51 +0200
Message-Id: <20230412082842.307389314@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
 drivers/hwtracing/coresight/coresight-etm4x-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -454,7 +454,7 @@ static int etm4_enable_hw(struct etmv4_d
 		if (etm4x_sspcicrn_present(drvdata, i))
 			etm4x_relaxed_write32(csa, config->ss_pe_cmp[i], TRCSSPCICRn(i));
 	}
-	for (i = 0; i < drvdata->nr_addr_cmp; i++) {
+	for (i = 0; i < drvdata->nr_addr_cmp * 2; i++) {
 		etm4x_relaxed_write64(csa, config->addr_val[i], TRCACVRn(i));
 		etm4x_relaxed_write64(csa, config->addr_acc[i], TRCACATRn(i));
 	}


