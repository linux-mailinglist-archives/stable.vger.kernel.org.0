Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93B624EF408
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 17:29:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349918AbiDAO6S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 10:58:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349355AbiDAOzT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:55:19 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20A8D182;
        Fri,  1 Apr 2022 07:43:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5450FCE2586;
        Fri,  1 Apr 2022 14:43:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD4EBC340EE;
        Fri,  1 Apr 2022 14:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648824197;
        bh=x3dT+DRrUHEyWgSp2GIzctNgqRJI1RTLFgiQNQ6Ldk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EMqSYt0ER4T92tsFIMkO31icjaTPTcia/PNbzvA54J2IFr045g7fagP3ePeVegGwf
         HmoqNt4Ley0pzWieb2dycpzg8vGMaNxCqCh0RLXcbNfrXVwQ/IYz0OZ591p+B0kouz
         fsuFDoUvCOLGIWFrQTUNmKWy2VfOt77Hf/QVNuUdhO3PzX/ZIVChMIDlmH5WFUAKzQ
         2rqYwLUEYXREE597GkMhEjd2jMZDy885BxO/ZCSSbPK/iv5VsoeSJKld0qRKYj1ONQ
         f+J6k6lKsp/9pk25Z7W+ru3IzP8RPTizBlbNozRXFjY3pCKLHBiPKk4XpFI+2nMoqE
         LJhyUCpCpQAQA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hou Zhiqiang <Zhiqiang.Hou@nxp.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Sasha Levin <sashal@kernel.org>, bhelgaas@google.com,
        yangyingliang@huawei.com, lchen@ambarella.com,
        linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 24/65] PCI: endpoint: Fix alignment fault error in copy tests
Date:   Fri,  1 Apr 2022 10:41:25 -0400
Message-Id: <20220401144206.1953700-24-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401144206.1953700-1-sashal@kernel.org>
References: <20220401144206.1953700-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hou Zhiqiang <Zhiqiang.Hou@nxp.com>

[ Upstream commit 829cc0e2ea2d61fb6c54bc3f8a17f86c56e11864 ]

The copy test uses the memcpy() to copy data between IO memory spaces.
This can trigger an alignment fault error (pasted the error logs below)
because memcpy() may use unaligned accesses on a mapped memory that is
just IO, which does not support unaligned memory accesses.

Fix it by using the correct memcpy API to copy from/to IO memory.

Alignment fault error logs:
   Unable to handle kernel paging request at virtual address ffff8000101cd3c1
   Mem abort info:
     ESR = 0x96000021
     EC = 0x25: DABT (current EL), IL = 32 bits
     SET = 0, FnV = 0
     EA = 0, S1PTW = 0
     FSC = 0x21: alignment fault
   Data abort info:
     ISV = 0, ISS = 0x00000021
     CM = 0, WnR = 0
   swapper pgtable: 4k pages, 48-bit VAs, pgdp=0000000081773000
   [ffff8000101cd3c1] pgd=1000000082410003, p4d=1000000082410003, pud=1000000082411003, pmd=1000000082412003, pte=0068004000001f13
   Internal error: Oops: 96000021 [#1] PREEMPT SMP
   Modules linked in:
   CPU: 0 PID: 6 Comm: kworker/0:0H Not tainted 5.15.0-rc1-next-20210914-dirty #2
   Hardware name: LS1012A RDB Board (DT)
   Workqueue: kpcitest pci_epf_test_cmd_handler
   pstate: 80000005 (Nzcv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
   pc : __memcpy+0x168/0x230
   lr : pci_epf_test_cmd_handler+0x6f0/0xa68
   sp : ffff80001003bce0
   x29: ffff80001003bce0 x28: ffff800010135000 x27: ffff8000101e5000
   x26: ffff8000101cd000 x25: ffff6cda941cf6c8 x24: 0000000000000000
   x23: ffff6cda863f2000 x22: ffff6cda9096c800 x21: ffff800010135000
   x20: ffff6cda941cf680 x19: ffffaf39fd999000 x18: 0000000000000000
   x17: 0000000000000000 x16: 0000000000000000 x15: ffffaf39fd2b6000
   x14: 0000000000000000 x13: 15f5c8fa2f984d57 x12: 604d132b60275454
   x11: 065cee5e5fb428b6 x10: aae662eb17d0cf3e x9 : 1d97c9a1b4ddef37
   x8 : 7541b65edebf928c x7 : e71937c4fc595de0 x6 : b8a0e09562430d1c
   x5 : ffff8000101e5401 x4 : ffff8000101cd401 x3 : ffff8000101e5380
   x2 : fffffffffffffff1 x1 : ffff8000101cd3c0 x0 : ffff8000101e5000
   Call trace:
    __memcpy+0x168/0x230
    process_one_work+0x1ec/0x370
    worker_thread+0x44/0x478
    kthread+0x154/0x160
    ret_from_fork+0x10/0x20
   Code: a984346c a9c4342c f1010042 54fffee8 (a97c3c8e)
   ---[ end trace 568c28c7b6336335 ]---

Link: https://lore.kernel.org/r/20211217094708.28678-1-Zhiqiang.Hou@nxp.com
Signed-off-by: Hou Zhiqiang <Zhiqiang.Hou@nxp.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/endpoint/functions/pci-epf-test.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/endpoint/functions/pci-epf-test.c b/drivers/pci/endpoint/functions/pci-epf-test.c
index d41570715dc7..b861840e867c 100644
--- a/drivers/pci/endpoint/functions/pci-epf-test.c
+++ b/drivers/pci/endpoint/functions/pci-epf-test.c
@@ -285,7 +285,17 @@ static int pci_epf_test_copy(struct pci_epf_test *epf_test)
 		if (ret)
 			dev_err(dev, "Data transfer failed\n");
 	} else {
-		memcpy(dst_addr, src_addr, reg->size);
+		void *buf;
+
+		buf = kzalloc(reg->size, GFP_KERNEL);
+		if (!buf) {
+			ret = -ENOMEM;
+			goto err_map_addr;
+		}
+
+		memcpy_fromio(buf, src_addr, reg->size);
+		memcpy_toio(dst_addr, buf, reg->size);
+		kfree(buf);
 	}
 	ktime_get_ts64(&end);
 	pci_epf_test_print_rate("COPY", reg->size, &start, &end, use_dma);
-- 
2.34.1

