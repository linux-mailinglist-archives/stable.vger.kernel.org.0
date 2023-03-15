Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 884B36BB064
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:17:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231731AbjCOMRw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:17:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231849AbjCOMRq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:17:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C56790B54
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:17:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9D62B81DFD
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:17:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3368FC433EF;
        Wed, 15 Mar 2023 12:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678882659;
        bh=W8BVLgEICDfHoY2CX1QBhe6Uk4YndKzjM8kULqyWtXI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=caMy1Ce3Eq66oBkPHsPfRq1JxtCegujT8xb2EMLsr0+bPW9laPTZqbd/pAXYU58/t
         +LnOuW4egTcrkbt7ZcJkwzixYDl5E3CE80hfR8UKFqYK2exJGSCxcHhkbFfNsoXx5n
         qwCBbcl/Ev31WiPuvQ/qoprMZ78OTTROkLRL1L6A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Bixuan Cui <cuibixuan@huawei.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 22/68] irqdomain: Change the type of size in __irq_domain_add() to be consistent
Date:   Wed, 15 Mar 2023 13:12:16 +0100
Message-Id: <20230315115726.956429673@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115726.103942885@linuxfoundation.org>
References: <20230315115726.103942885@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bixuan Cui <cuibixuan@huawei.com>

[ Upstream commit 20c36ce2164f1774b487d443ece99b754bc6ad43 ]

The 'size' is used in struct_size(domain, revmap, size) and its input
parameter type is 'size_t'(unsigned int).
Changing the size to 'unsigned int' to make the type consistent.

Signed-off-by: Bixuan Cui <cuibixuan@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20210916025203.44841-1-cuibixuan@huawei.com
Stable-dep-of: 8932c32c3053 ("irqdomain: Fix domain registration race")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/irqdomain.h | 2 +-
 kernel/irq/irqdomain.c    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index 824d7a19dd66e..2552f66a7a891 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -254,7 +254,7 @@ static inline struct fwnode_handle *irq_domain_alloc_fwnode(phys_addr_t *pa)
 }
 
 void irq_domain_free_fwnode(struct fwnode_handle *fwnode);
-struct irq_domain *__irq_domain_add(struct fwnode_handle *fwnode, int size,
+struct irq_domain *__irq_domain_add(struct fwnode_handle *fwnode, unsigned int size,
 				    irq_hw_number_t hwirq_max, int direct_max,
 				    const struct irq_domain_ops *ops,
 				    void *host_data);
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 3d1b570a1dadd..cfb5a96f023f7 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -127,7 +127,7 @@ EXPORT_SYMBOL_GPL(irq_domain_free_fwnode);
  * Allocates and initializes an irq_domain structure.
  * Returns pointer to IRQ domain, or NULL on failure.
  */
-struct irq_domain *__irq_domain_add(struct fwnode_handle *fwnode, int size,
+struct irq_domain *__irq_domain_add(struct fwnode_handle *fwnode, unsigned int size,
 				    irq_hw_number_t hwirq_max, int direct_max,
 				    const struct irq_domain_ops *ops,
 				    void *host_data)
-- 
2.39.2



