Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A034713E262
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:56:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731354AbgAPQzc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:55:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:40730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732930AbgAPQz2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:55:28 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DB2D2192A;
        Thu, 16 Jan 2020 16:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193728;
        bh=C56IW0/Kh53913yk/Ml60Mj0SZ9XP0ePBFNW2/HPD6M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hznRKdI3gJyCSiJtmhJ0bFjP8G7GH621qfMkYTVKxl4ATtFQHbLXjzHZVgR6b2aiP
         Q5vxgN5uBUyHMjFtSyCboX/ecG38irrEeH0T4yd14LpyR/nnJwRmGjjaAYkC7zyTdU
         n972T6z+yC0YNGg2Q9OeSezgkb/1RntEvq4Y3ksg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marc Zyngier <marc.zyngier@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 021/671] genirq/debugfs: Reinstate full OF path for domain name
Date:   Thu, 16 Jan 2020 11:44:12 -0500
Message-Id: <20200116165502.8838-21-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165502.8838-1-sashal@kernel.org>
References: <20200116165502.8838-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <marc.zyngier@arm.com>

[ Upstream commit 94967b55ebf3b603f2fe750ecedd896042585a1c ]

On a DT based system, we use the of_node full name to name the
corresponding irq domain. We expect that name to be unique, so so that
domains with the same base name won't clash (this happens on multi-node
topologies, for example).

Since a7e4cfb0a7ca ("of/fdt: only store the device node basename in
full_name"), of_node_full_name() lies and only returns the basename. This
breaks the above requirement, and we end-up with only a subset of the
domains in /sys/kernel/debug/irq/domains.

Let's reinstate the feature by using the fancy new %pOF format specifier,
which happens to do the right thing.

Fixes: a7e4cfb0a7ca ("of/fdt: only store the device node basename in full_name")
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/20181001100522.180054-3-marc.zyngier@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/irq/irqdomain.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 5d9fc01b60a6..0b90be360724 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -183,7 +183,7 @@ struct irq_domain *__irq_domain_add(struct fwnode_handle *fwnode, int size,
 		 * unhappy about. Replace them with ':', which does
 		 * the trick and is not as offensive as '\'...
 		 */
-		name = kstrdup(of_node_full_name(of_node), GFP_KERNEL);
+		name = kasprintf(GFP_KERNEL, "%pOF", of_node);
 		if (!name) {
 			kfree(domain);
 			return NULL;
-- 
2.20.1

