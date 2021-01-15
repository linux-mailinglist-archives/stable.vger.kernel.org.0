Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7C2F2F7B77
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 14:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731207AbhAOMc0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:32:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:38656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728292AbhAOMcX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:32:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7131236FB;
        Fri, 15 Jan 2021 12:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610713903;
        bh=UcUSkdhomd29qxtAEw3WoWLxg0l1edWhcBOCyhJSGL4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mSbQksgucma+EPHwl/BsshUU6ktf546dkBhO7ovd9XnqW8QR5m7Wf+3MkpIFTmaV0
         lhcSOHlIuBadPa+Kh1+izSjheqUFs1DOPDssrbbN7htPIT1aZMGI6qi+PwG2JrvRf9
         KAHLFo5HjNfLGkcaBclc8V/2rk7+q/Xq4os/UpcA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 4.14 22/28] iommu/intel: Fix memleak in intel_irq_remapping_alloc
Date:   Fri, 15 Jan 2021 13:27:59 +0100
Message-Id: <20210115121957.858460673@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115121956.731354372@linuxfoundation.org>
References: <20210115121956.731354372@linuxfoundation.org>
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
@@ -1367,6 +1367,8 @@ static int intel_irq_remapping_alloc(str
 		irq_data = irq_domain_get_irq_data(domain, virq + i);
 		irq_cfg = irqd_cfg(irq_data);
 		if (!irq_data || !irq_cfg) {
+			if (!i)
+				kfree(data);
 			ret = -EINVAL;
 			goto out_free_data;
 		}


