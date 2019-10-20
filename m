Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39C11DDBE4
	for <lists+stable@lfdr.de>; Sun, 20 Oct 2019 03:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbfJTB6W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Oct 2019 21:58:22 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:41578 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726036AbfJTB6W (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Oct 2019 21:58:22 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 5A12660D59; Sun, 20 Oct 2019 01:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571536701;
        bh=IA/2nenmpm2hIMv7OY+2bIdqFwYtpWLS+0Q+Q2dzqwI=;
        h=From:To:Cc:Subject:Date:From;
        b=I3cBTjqjSQ6vKw7eQRGCOEjvojj34FfnONu+JR0Q9l8L/SK5PCCFm2ZT0JPnZP5xR
         lI7p+1yBoAu5CJYnqLgwjjryDX37vs2k+w8GozJKEETRIOBfeuJcoXHFo83f1nccqp
         hYEJSlKni7OFMXmJ0iCOaQcjZ2EWGbv0X2c7HhB8=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from cgoldswo-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cgoldswo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4E1B760D38;
        Sun, 20 Oct 2019 01:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571536700;
        bh=IA/2nenmpm2hIMv7OY+2bIdqFwYtpWLS+0Q+Q2dzqwI=;
        h=From:To:Cc:Subject:Date:From;
        b=acbHJzaf64weUMSWKM1saVt2iNwkt454/CYcxmxj/lbJsiEBmwBAR+kyg+WLr3EY2
         0bRVZgBODmbcmyL6gQ8omKlltFaDfeiVFSNZrXrXBPyT/GhX2af3Cyygly/0Gjgslr
         K7koKWYlZL1Dls05rImMU/uYWdAG0FvfKYxPbOjs=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4E1B760D38
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=cgoldswo@codeaurora.org
From:   Chris Goldsworthy <cgoldswo@codeaurora.org>
To:     robh+dt@kernel.org
Cc:     Chris Goldsworthy <cgoldswo@codeaurora.org>,
        devicetree@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] of: reserved_mem: add missing of_node_put() for proper ref-counting
Date:   Sat, 19 Oct 2019 18:57:24 -0700
Message-Id: <1571536644-13840-1-git-send-email-cgoldswo@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit d698a388146c ("of: reserved-memory: ignore disabled memory-region
nodes") added an early return in of_reserved_mem_device_init_by_idx(), but
didn't call of_node_put() on a device_node whose ref-count was incremented
in the call to of_parse_phandle() preceding the early exit.

Fixes: d698a388146c ("of: reserved-memory: ignore disabled memory-region nodes")
Signed-off-by: Chris Goldsworthy <cgoldswo@codeaurora.org>
To: Rob Herring <robh+dt@kernel.org>
Cc: devicetree@vger.kernel.org
Cc: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
---
 drivers/of/of_reserved_mem.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index 7989703..6bd610e 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -324,8 +324,10 @@ int of_reserved_mem_device_init_by_idx(struct device *dev,
 	if (!target)
 		return -ENODEV;
 
-	if (!of_device_is_available(target))
+	if (!of_device_is_available(target)) {
+		of_node_put(target);
 		return 0;
+	}
 
 	rmem = __find_rmem(target);
 	of_node_put(target);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

