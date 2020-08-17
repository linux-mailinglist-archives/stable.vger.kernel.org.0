Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDD5C24711F
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390839AbgHQSUv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:20:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:52116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388303AbgHQQE1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:04:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F09D20729;
        Mon, 17 Aug 2020 16:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680267;
        bh=T032HNqer3nEdXQY6nSIg8lNRyD2RtX1s3YPunX42wk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vET3egSJ7uMXhrKyM3LHBglJ5P3uisHyL5asr3u/JnAvdp6DdaJKgEFn/o10FhYh8
         CLf860WEh+MsYFrZFPBMBx0ng1pIkqo/f41nkQP/m7vVtbXXxn1OO9cf++WqP9Jif4
         U0+GUESSp3ZJhuPRulk5f4t47NBDZIRjHRgyBxqs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Yongjun <weiyongjun1@huawei.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 118/270] iavf: fix error return code in iavf_init_get_resources()
Date:   Mon, 17 Aug 2020 17:15:19 +0200
Message-Id: <20200817143801.648140468@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143755.807583758@linuxfoundation.org>
References: <20200817143755.807583758@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 753f3884f253de6b6d3a516e6651bda0baf4aede ]

Fix to return negative error code -ENOMEM from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: b66c7bc1cd4d ("iavf: Refactor init state machine")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index bacc5fb7eba2c..905fc45b4a58f 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -1863,8 +1863,10 @@ static int iavf_init_get_resources(struct iavf_adapter *adapter)
 
 	adapter->rss_key = kzalloc(adapter->rss_key_size, GFP_KERNEL);
 	adapter->rss_lut = kzalloc(adapter->rss_lut_size, GFP_KERNEL);
-	if (!adapter->rss_key || !adapter->rss_lut)
+	if (!adapter->rss_key || !adapter->rss_lut) {
+		err = -ENOMEM;
 		goto err_mem;
+	}
 	if (RSS_AQ(adapter))
 		adapter->aq_required |= IAVF_FLAG_AQ_CONFIGURE_RSS;
 	else
-- 
2.25.1



