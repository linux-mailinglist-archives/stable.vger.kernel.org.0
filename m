Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E68642F79F3
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:44:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387773AbhAOMjP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:39:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:46686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733225AbhAOMjP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:39:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86098236FB;
        Fri, 15 Jan 2021 12:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714315;
        bh=Ohvj5MoWfLEuNKrtfujEERe7LIG0LnBBL+ERZCS8wa4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pBcL1JaeSV0s7uo+Hba6qorWnFpRhi6MNBLYGKSUBBt1LJuzxX7bqoleeBufRvQDN
         Ws0iKbMBAuoScTxSMdrPxPGrufbU6FQxO1xtmt0TlPiZpfOSx4aMB1lCyHO7lA19RW
         CAHZc2pU5FUH9X+em+T1Z8GpubZIHR7I5KkeXfws=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 5.10 081/103] iommu/intel: Fix memleak in intel_irq_remapping_alloc
Date:   Fri, 15 Jan 2021 13:28:14 +0100
Message-Id: <20210115122009.943038282@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115122006.047132306@linuxfoundation.org>
References: <20210115122006.047132306@linuxfoundation.org>
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
 drivers/iommu/intel/irq_remapping.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iommu/intel/irq_remapping.c
+++ b/drivers/iommu/intel/irq_remapping.c
@@ -1390,6 +1390,8 @@ static int intel_irq_remapping_alloc(str
 		irq_data = irq_domain_get_irq_data(domain, virq + i);
 		irq_cfg = irqd_cfg(irq_data);
 		if (!irq_data || !irq_cfg) {
+			if (!i)
+				kfree(data);
 			ret = -EINVAL;
 			goto out_free_data;
 		}


