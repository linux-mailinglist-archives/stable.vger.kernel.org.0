Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E7DFA1B4A
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 15:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727639AbfH2NVX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 09:21:23 -0400
Received: from mga05.intel.com ([192.55.52.43]:4059 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726518AbfH2NVW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Aug 2019 09:21:22 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Aug 2019 06:21:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,443,1559545200"; 
   d="scan'208";a="197804512"
Received: from black.fi.intel.com (HELO black.fi.intel.com.) ([10.237.72.28])
  by fmsmga001.fm.intel.com with ESMTP; 29 Aug 2019 06:21:20 -0700
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kbuild test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 2/2] software node: Fix use of potentially uninitialized variable
Date:   Thu, 29 Aug 2019 16:21:16 +0300
Message-Id: <20190829132116.76120-3-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20190829132116.76120-1-heikki.krogerus@linux.intel.com>
References: <20190829132116.76120-1-heikki.krogerus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

reported by smatch:
drivers/base/swnode.c:71 software_node_to_swnode() error: uninitialized symbol 'swnode'.

Fixes: 80488a6b1d3c ("software node: Add support for static node descriptors")
Cc: stable@vger.kernel.org
Reported-by: kbuild test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 drivers/base/swnode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/swnode.c b/drivers/base/swnode.c
index de9596fc4166..a1f3f0994f9f 100644
--- a/drivers/base/swnode.c
+++ b/drivers/base/swnode.c
@@ -51,7 +51,7 @@ EXPORT_SYMBOL_GPL(is_software_node);
 static struct swnode *
 software_node_to_swnode(const struct software_node *node)
 {
-	struct swnode *swnode;
+	struct swnode *swnode = NULL;
 	struct kobject *k;
 
 	if (!node)
-- 
2.23.0.rc1

