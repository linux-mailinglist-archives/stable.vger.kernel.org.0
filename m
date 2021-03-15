Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EACE633B807
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:04:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233509AbhCOOBx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:01:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:35186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232628AbhCON7w (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:59:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3943364EFC;
        Mon, 15 Mar 2021 13:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816774;
        bh=20NaSGLvTYKwMt1yutcaUGuc6VgU+tHjTLCYqQx3qRQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bXJPH1dspsrUZH/5zl+LY3f03xS+6YFaZ8DH1Yl6RapSNPtCtcR4bDRjVkIeAmcYf
         6lS9IezBIrTs7bHDol/MMDTmP59N4kl4sQo5r+NmxK55qaEMgKu5zE/uW5wkilPekS
         4jNVoLVNqAdBFOMJQllbelMbU8VbRZw4Vb8+OUA4=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.4 100/168] software node: Fix node registration
Date:   Mon, 15 Mar 2021 14:55:32 +0100
Message-Id: <20210315135553.655781092@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135550.333963635@linuxfoundation.org>
References: <20210315135550.333963635@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

commit 8891123f9cbb9c1ee531e5a87fa116f0af685c48 upstream.

Software node can not be registered before its parent.

Fixes: 80488a6b1d3c ("software node: Add support for static node descriptors")
Cc: 5.10+ <stable@vger.kernel.org> # 5.10+
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Tested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/swnode.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/base/swnode.c
+++ b/drivers/base/swnode.c
@@ -812,6 +812,9 @@ int software_node_register(const struct
 	if (software_node_to_swnode(node))
 		return -EEXIST;
 
+	if (node->parent && !parent)
+		return -EINVAL;
+
 	return PTR_ERR_OR_ZERO(swnode_register(node, parent, 0));
 }
 EXPORT_SYMBOL_GPL(software_node_register);


