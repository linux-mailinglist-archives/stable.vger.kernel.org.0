Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 898CB3280EE
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 15:33:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236399AbhCAOcR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 09:32:17 -0500
Received: from mga09.intel.com ([134.134.136.24]:37767 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236391AbhCAOcL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 09:32:11 -0500
IronPort-SDR: qU4G5v7uMWtW+L5Q9hqHZAHQLjeWbu2ArYIwMADNEqfn01hBjV9mN9ulfB5GMVBuTmcyoPHwgP
 Jqui9xQoz21w==
X-IronPort-AV: E=McAfee;i="6000,8403,9909"; a="186593226"
X-IronPort-AV: E=Sophos;i="5.81,215,1610438400"; 
   d="scan'208";a="186593226"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2021 06:30:19 -0800
IronPort-SDR: ivMI6VbDxWFB1/Bfjg59vvlmquNP3jRal8MWWbVi4yC9N6hJpAj+VHwE4AdoJvbTKXv7IXIXrr
 ACSau3K478Pw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,215,1610438400"; 
   d="scan'208";a="505086242"
Received: from black.fi.intel.com (HELO black.fi.intel.com.) ([10.237.72.28])
  by fmsmga001.fm.intel.com with ESMTP; 01 Mar 2021 06:30:16 -0800
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 1/2] software node: Fix node registration
Date:   Mon,  1 Mar 2021 17:30:11 +0300
Message-Id: <20210301143012.55118-2-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301143012.55118-1-heikki.krogerus@linux.intel.com>
References: <20210301143012.55118-1-heikki.krogerus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Software node can not be registered before its parent.

Fixes: 80488a6b1d3c ("software node: Add support for static node descriptors")
Cc: stable@vger.kernel.org
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 drivers/base/swnode.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/base/swnode.c b/drivers/base/swnode.c
index 37179a8b1ceba..74db8c971db74 100644
--- a/drivers/base/swnode.c
+++ b/drivers/base/swnode.c
@@ -938,6 +938,9 @@ int software_node_register(const struct software_node *node)
 	if (software_node_to_swnode(node))
 		return -EEXIST;
 
+	if (node->parent && !parent)
+		return -EINVAL;
+
 	return PTR_ERR_OR_ZERO(swnode_register(node, parent, 0));
 }
 EXPORT_SYMBOL_GPL(software_node_register);
-- 
2.30.1

