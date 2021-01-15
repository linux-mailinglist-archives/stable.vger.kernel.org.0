Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2CC62F7C11
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 14:09:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387458AbhAONIv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 08:08:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:36294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732131AbhAOMal (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:30:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CBB2E23136;
        Fri, 15 Jan 2021 12:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610713773;
        bh=7DhH4CeaiM1Ol8TRHyRqIFvNkZi+WpYGPYti91uLLGk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JJkMLlxgxY5uqLvL0Z+tNgZajfFSohSUpTRAn3jPbDxn5wWpk45AzIcG7tOWnSbHy
         dHnV8gfOM8WiZmDIcrha1TTvfgtNvOkXsCK3FGTxWgE/rARY16tKUS5tiysP3gaKML
         c+TVyOwwTLmGjRSx/CZi64i2WJ1fKXmK9QL+n0fU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 4.4 16/18] iommu/intel: Fix memleak in intel_irq_remapping_alloc
Date:   Fri, 15 Jan 2021 13:27:44 +0100
Message-Id: <20210115121955.909084929@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115121955.112329537@linuxfoundation.org>
References: <20210115121955.112329537@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

commit ff2b46d7cff80d27d82f7f3252711f4ca1666129 upstream.

When irq_domain_get_irq_data() or irqd_cfg() fails
at i == 0, data allocated by kzalloc() has not been
freed before returning, which leads to memleak.

Fixes: b106ee63abcc ("irq_remapping/vt-d: Enhance Intel IR driver to support hierarchical irqdomains")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Acked-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/20210105051837.32118-1-dinghao.liu@zju.edu.cn
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/intel_irq_remapping.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -1350,6 +1350,8 @@ static int intel_irq_remapping_alloc(str
 		irq_data = irq_domain_get_irq_data(domain, virq + i);
 		irq_cfg = irqd_cfg(irq_data);
 		if (!irq_data || !irq_cfg) {
+			if (!i)
+				kfree(data);
 			ret = -EINVAL;
 			goto out_free_data;
 		}


