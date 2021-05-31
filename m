Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7D34396255
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234352AbhEaOzM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:55:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:46632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232301AbhEaOwT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:52:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A778961932;
        Mon, 31 May 2021 13:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469503;
        bh=mc9qPXOYM9BuhwrCiFltIAGr2dsvj56kwEtrxC/IiC0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xwW9rDh+pQTgdWDihO6zdo6lGu4IoybtVHbcmvi0aqOM2cMywRmZOvvZy4OvLsl2E
         uTh34s04Wd5WltfeVi52kp9D8JuQQkgpYt36Pa0eA4enW95yxhpQm4SyfIUpkUFcZ4
         kQY3UbegM8U7RJ1jetZiKXWHQBENMlXjePWfXE2M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Subbaraman Narayanamurthy <subbaram@codeaurora.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        Georgi Djakov <djakov@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 223/296] interconnect: qcom: bcm-voter: add a missing of_node_put()
Date:   Mon, 31 May 2021 15:14:38 +0200
Message-Id: <20210531130711.325292247@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
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
index 1cc565bce2f4..dd18cd8474f8 100644
--- a/drivers/interconnect/qcom/bcm-voter.c
+++ b/drivers/interconnect/qcom/bcm-voter.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * Copyright (c) 2020, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2020-2021, The Linux Foundation. All rights reserved.
  */
 
 #include <asm/div64.h>
@@ -205,6 +205,7 @@ struct bcm_voter *of_bcm_voter_get(struct device *dev, const char *name)
 	}
 	mutex_unlock(&bcm_voter_lock);
 
+	of_node_put(node);
 	return voter;
 }
 EXPORT_SYMBOL_GPL(of_bcm_voter_get);
-- 
2.30.2



