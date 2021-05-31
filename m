Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA619395F32
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232817AbhEaOI5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:08:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:40026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233318AbhEaOGy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:06:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A7D361375;
        Mon, 31 May 2021 13:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468345;
        bh=iq19nwbXo475XeFET3mRSIMavLdAwk3iHyWapCMHCAU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2ObxucgIyMmcMGA7u77g3/zbVMYhw7KJY8QXKT5mj5l8v65z87XgDqsKVtloKJQBN
         e25ijtQXzgpX+IP3UXY8t5VEWYa3mExiPl0e5SuZULMBW0+2eoXMKMABCCslxsXiEO
         IQmehi5ySItsXHDnUrAdUHsm1CyVDlWV7P3cgTWw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Subbaraman Narayanamurthy <subbaram@codeaurora.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        Georgi Djakov <djakov@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 191/252] interconnect: qcom: bcm-voter: add a missing of_node_put()
Date:   Mon, 31 May 2021 15:14:16 +0200
Message-Id: <20210531130704.497208212@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Subbaraman Narayanamurthy <subbaram@codeaurora.org>

[ Upstream commit a00593737f8bac2c9e97b696e7ff84a4446653e8 ]

Add a missing of_node_put() in of_bcm_voter_get() to avoid the
reference leak.

Signed-off-by: Subbaraman Narayanamurthy <subbaram@codeaurora.org>
Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
Link: https://lore.kernel.org/r/1619116570-13308-1-git-send-email-subbaram@codeaurora.org
Fixes: 976daac4a1c5 ("interconnect: qcom: Consolidate interconnect RPMh support")
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/qcom/bcm-voter.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/interconnect/qcom/bcm-voter.c b/drivers/interconnect/qcom/bcm-voter.c
index 887d13721e52..7c3ef817e99c 100644
--- a/drivers/interconnect/qcom/bcm-voter.c
+++ b/drivers/interconnect/qcom/bcm-voter.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * Copyright (c) 2020, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2020-2021, The Linux Foundation. All rights reserved.
  */
 
 #include <asm/div64.h>
@@ -212,6 +212,7 @@ struct bcm_voter *of_bcm_voter_get(struct device *dev, const char *name)
 	}
 	mutex_unlock(&bcm_voter_lock);
 
+	of_node_put(node);
 	return voter;
 }
 EXPORT_SYMBOL_GPL(of_bcm_voter_get);
-- 
2.30.2



