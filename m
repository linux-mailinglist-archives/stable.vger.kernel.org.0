Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E40F66AF495
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:17:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233922AbjCGTRi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:17:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233894AbjCGTRN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:17:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ABEA61B6
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 11:01:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 17BEF6150F
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 19:01:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DA59C433EF;
        Tue,  7 Mar 2023 19:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215661;
        bh=Oj9JntBQWOhAYET4xyBqJrN3dmq8msvR8XKDcoS3vcQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wh17R+D+YHEhApvYTdx6Dc4n5guv+UsmQfXrOWSdropZG5dFI7jH9rHhgVcgxR08V
         ieqnUMa2uuFgYcu1NNniUYk3arXoUHVAPgRKsM3j66vIP3ItXllnDz8yJE9E6OStrv
         hUMq0zpOquhC0Ton1LzY9UiRWzTXava8lrNYZknY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jinlong Mao <quic_jinlmao@quicinc.com>,
        James Clark <james.clark@arm.com>,
        Mike Leach <mike.leach@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 291/567] coresight: cti: Prevent negative values of enable count
Date:   Tue,  7 Mar 2023 18:00:27 +0100
Message-Id: <20230307165918.512833862@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
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

From: James Clark <james.clark@arm.com>

[ Upstream commit 3244fb6dbbf1ffc114cdf382cc167bdd8c18088a ]

Writing 0 to the enable control repeatedly results in a negative value
for enable_req_count. After this, writing 1 to the enable control
appears to not work until the count returns to positive.

Change it so that it's impossible for enable_req_count to be < 0.
Return an error to indicate that the disable request was invalid.

Fixes: 835d722ba10a ("coresight: cti: Initial CoreSight CTI Driver")
Tested-by: Jinlong Mao <quic_jinlmao@quicinc.com>
Signed-off-by: James Clark <james.clark@arm.com>
Reviewed-by: Mike Leach <mike.leach@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20230110110736.2709917-2-james.clark@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-cti-core.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-cti-core.c b/drivers/hwtracing/coresight/coresight-cti-core.c
index dcd607a0c41a1..932e17f00c0ba 100644
--- a/drivers/hwtracing/coresight/coresight-cti-core.c
+++ b/drivers/hwtracing/coresight/coresight-cti-core.c
@@ -151,9 +151,16 @@ static int cti_disable_hw(struct cti_drvdata *drvdata)
 {
 	struct cti_config *config = &drvdata->config;
 	struct coresight_device *csdev = drvdata->csdev;
+	int ret = 0;
 
 	spin_lock(&drvdata->spinlock);
 
+	/* don't allow negative refcounts, return an error */
+	if (!atomic_read(&drvdata->config.enable_req_count)) {
+		ret = -EINVAL;
+		goto cti_not_disabled;
+	}
+
 	/* check refcount - disable on 0 */
 	if (atomic_dec_return(&drvdata->config.enable_req_count) > 0)
 		goto cti_not_disabled;
@@ -171,12 +178,12 @@ static int cti_disable_hw(struct cti_drvdata *drvdata)
 	coresight_disclaim_device_unlocked(csdev);
 	CS_LOCK(drvdata->base);
 	spin_unlock(&drvdata->spinlock);
-	return 0;
+	return ret;
 
 	/* not disabled this call */
 cti_not_disabled:
 	spin_unlock(&drvdata->spinlock);
-	return 0;
+	return ret;
 }
 
 void cti_write_single_reg(struct cti_drvdata *drvdata, int offset, u32 value)
-- 
2.39.2



