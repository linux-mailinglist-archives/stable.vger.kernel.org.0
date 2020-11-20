Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1A222BA899
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 12:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728097AbgKTLJl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 06:09:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:54942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728442AbgKTLHA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Nov 2020 06:07:00 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA5392222F;
        Fri, 20 Nov 2020 11:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605870420;
        bh=dmkeiis4d4Vw2BZHP1dTouAtp1d1sOFq1VLwuAii8Ik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tKBAUhavytkFWY119l7C0ehLdJ9Zw0bxYkxz0KeyUw9bsd9Cv0Kjz8AvUOv7hicXh
         oSky6aNo3+1kR+MZd95g5qBtigKqxbCsiRx+Rqg4+TnJMMLM4U5nU+Z1NjODna8o62
         FHvn3mIFppUIUnuW6hsiHVZwHOZJvnBYJCqv+xys=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 5.4 06/17] MIPS: PCI: Fix MIPS build
Date:   Fri, 20 Nov 2020 12:03:33 +0100
Message-Id: <20201120104541.390312868@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201120104541.058449969@linuxfoundation.org>
References: <20201120104541.058449969@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>

While backporting 37640adbefd6 ("MIPS: PCI: remember nasid changed by
set interrupt affinity") something went wrong and an extra 'n' was added.
So 'data->nasid' became 'data->nnasid' and the MIPS builds started failing.

This is only needed for 5.4-stable tree.

Fixes: 957978aa56f1 ("MIPS: PCI: remember nasid changed by set interrupt affinity")
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/pci/pci-xtalk-bridge.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/pci/pci-xtalk-bridge.c
+++ b/arch/mips/pci/pci-xtalk-bridge.c
@@ -284,7 +284,7 @@ static int bridge_set_affinity(struct ir
 	ret = irq_chip_set_affinity_parent(d, mask, force);
 	if (ret >= 0) {
 		cpu = cpumask_first_and(mask, cpu_online_mask);
-		data->nnasid = COMPACT_TO_NASID_NODEID(cpu_to_node(cpu));
+		data->nasid = COMPACT_TO_NASID_NODEID(cpu_to_node(cpu));
 		bridge_write(data->bc, b_int_addr[pin].addr,
 			     (((data->bc->intr_addr >> 30) & 0x30000) |
 			      bit | (data->nasid << 8)));


