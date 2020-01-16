Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10BE713FD66
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:26:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730338AbgAPXZd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:25:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:55012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388789AbgAPXZX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:25:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4619B20684;
        Thu, 16 Jan 2020 23:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217122;
        bh=Am514viuDR+6nowEVV3dj8GfLUbRHk3fnPYTQWZhNqw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DWxHVMMMXDyUO9kXyBbNYV9qP8boOs6qE8F1yak5lQ4+W+uc48aPV10EFNf1KZspa
         KC57C8fNJAaK2vXHJyXH0zqPEu24kXrVvJABU+zPmcgbwwulWlSwh7Fx/vs1Smb4Pk
         fFw0VR7bNHng5wxH0Rk045j1/z5RJz2AjTzCyjF0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thomas Bogendoerfer <tbogendoerfer@suse.de>,
        Paul Burton <paulburton@kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>, linux-mips@vger.kernel.org
Subject: [PATCH 5.4 140/203] MIPS: PCI: remember nasid changed by set interrupt affinity
Date:   Fri, 17 Jan 2020 00:17:37 +0100
Message-Id: <20200116231757.243032912@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Bogendoerfer <tbogendoerfer@suse.de>

commit 37640adbefd66491cb8083a438f7bf366ac09bc7 upstream.

When changing interrupt affinity remember the possible changed nasid,
otherwise an interrupt deactivate/activate sequence will incorrectly
setup interrupt.

Fixes: e6308b6d35ea ("MIPS: SGI-IP27: abstract chipset irq from bridge")
Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
Signed-off-by: Paul Burton <paulburton@kernel.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: James Hogan <jhogan@kernel.org>
Cc: linux-mips@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/pci/pci-xtalk-bridge.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/arch/mips/pci/pci-xtalk-bridge.c
+++ b/arch/mips/pci/pci-xtalk-bridge.c
@@ -279,16 +279,15 @@ static int bridge_set_affinity(struct ir
 	struct bridge_irq_chip_data *data = d->chip_data;
 	int bit = d->parent_data->hwirq;
 	int pin = d->hwirq;
-	nasid_t nasid;
 	int ret, cpu;
 
 	ret = irq_chip_set_affinity_parent(d, mask, force);
 	if (ret >= 0) {
 		cpu = cpumask_first_and(mask, cpu_online_mask);
-		nasid = COMPACT_TO_NASID_NODEID(cpu_to_node(cpu));
+		data->nnasid = COMPACT_TO_NASID_NODEID(cpu_to_node(cpu));
 		bridge_write(data->bc, b_int_addr[pin].addr,
 			     (((data->bc->intr_addr >> 30) & 0x30000) |
-			      bit | (nasid << 8)));
+			      bit | (data->nasid << 8)));
 		bridge_read(data->bc, b_wid_tflush);
 	}
 	return ret;


