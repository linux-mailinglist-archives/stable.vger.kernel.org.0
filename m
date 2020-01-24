Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4423A148459
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:44:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbgAXLAz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:00:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:33024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387408AbgAXLAy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:00:54 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C86542071A;
        Fri, 24 Jan 2020 11:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579863653;
        bh=b+o3zGzEFYXqTT/+j3VpTMFE2Ngr9EM1dX3QrS2h22A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HNse8cF+BPNHGf8iuSwtnWX76E13OfkNLMAP6AOC0+b9BG3tinBv4DxLHkVeWCn2t
         8RhZKZ8zsllXJYtmuJ1I0ZSjF+so0znV3H2DTbCwplJGMBMqwSZLtqWZemhsASLBKG
         sKWAguHkMIkAmAYk36wbYY7vFmU+WQISVx8c17iY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 038/639] genirq/debugfs: Reinstate full OF path for domain name
Date:   Fri, 24 Jan 2020 10:23:28 +0100
Message-Id: <20200124093052.220266299@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 5d9fc01b60a61..0b90be3607249 100644
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



