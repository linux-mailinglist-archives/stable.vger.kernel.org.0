Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17274420C30
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:02:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234427AbhJDNDu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:03:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:60396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234126AbhJDNCH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:02:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03AC2615A4;
        Mon,  4 Oct 2021 12:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352335;
        bh=3+uSUMwiGr0vWOPVOODaHR+2+RrS0BvRSyqfqhN1DcM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ieFpEIGJAEWt1BAhBkxvefFdedg4DVBZKR9RDJ8KnNrpzcXKNk9IyJuzH4L1aaZuU
         COPKPQoaxEcUC1MKIUnds4vuk6wnhWGTdlc/FGiKjfJ7z70ON57CXE+pRIbWS8bAd1
         zSQbB+kPF53QK8sK2Vg38VLR/bngclzFeJV7yev8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kaige Fu <kaige.fu@linux.alibaba.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 21/75] irqchip/gic-v3-its: Fix potential VPE leak on error
Date:   Mon,  4 Oct 2021 14:51:56 +0200
Message-Id: <20211004125032.229863489@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125031.530773667@linuxfoundation.org>
References: <20211004125031.530773667@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kaige Fu <kaige.fu@linux.alibaba.com>

[ Upstream commit 280bef512933b2dda01d681d8cbe499b98fc5bdd ]

In its_vpe_irq_domain_alloc, when its_vpe_init() returns an error,
there is an off-by-one in the number of VPEs to be freed.

Fix it by simply passing the number of VPEs allocated, which is the
index of the loop iterating over the VPEs.

Fixes: 7d75bbb4bc1a ("irqchip/gic-v3-its: Add VPE irq domain allocation/teardown")
Signed-off-by: Kaige Fu <kaige.fu@linux.alibaba.com>
[maz: fixed commit message]
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/d9e36dee512e63670287ed9eff884a5d8d6d27f2.1631672311.git.kaige.fu@linux.alibaba.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 1d2267c6d31a..85b4610e6dc4 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -2730,7 +2730,7 @@ static int its_vpe_irq_domain_alloc(struct irq_domain *domain, unsigned int virq
 
 	if (err) {
 		if (i > 0)
-			its_vpe_irq_domain_free(domain, virq, i - 1);
+			its_vpe_irq_domain_free(domain, virq, i);
 
 		its_lpi_free_chunks(bitmap, base, nr_ids);
 		its_free_prop_table(vprop_page);
-- 
2.33.0



