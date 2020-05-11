Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF69D1CDDD6
	for <lists+stable@lfdr.de>; Mon, 11 May 2020 16:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729465AbgEKOyh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 May 2020 10:54:37 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:58605 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729463AbgEKOyh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 May 2020 10:54:37 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01358;MF=zhongjiang-ali@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0TyGy9MH_1589208869;
Received: from localhost(mailfrom:zhongjiang-ali@linux.alibaba.com fp:SMTPD_---0TyGy9MH_1589208869)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 11 May 2020 22:54:34 +0800
From:   zhongjiang-ali <zhongjiang-ali@linux.alibaba.com>
To:     yang.s@alibaba-inc.com, fulin.dn@alibaba-inc.com,
        xunlei.pxl@alibaba-inc.com
Cc:     alikernel-developer@linux.alibaba.com,
        Yasunori Goto <y-goto@jp.fujitsu.com>,
        <stable@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH Ali3000 AEP 21/26] tools/testing/nvdimm: fix nfit_test buffer overflow
Date:   Mon, 11 May 2020 22:53:11 +0800
Message-Id: <1589208796-89259-22-git-send-email-zhongjiang-ali@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1589208796-89259-1-git-send-email-zhongjiang-ali@linux.alibaba.com>
References: <1589208796-89259-1-git-send-email-zhongjiang-ali@linux.alibaba.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yasunori Goto <y-goto@jp.fujitsu.com>

The root cause of panic is the num_pm of nfit_test1 is wrong.
Though 1 is specified for num_pm at nfit_test_init(), it must be 2,
because nfit_test1->spa_set[] array has 2 elements.

Since the array is smaller than expected, the driver breaks other area.
(it is often the link list of devres).

As a result, panic occurs like the following example.

    CPU: 4 PID: 2233 Comm: lt-libndctl Tainted: G           O    4.12.0-rc1+ #12
    RIP: 0010:__list_del_entry_valid+0x6c/0xa0
    Call Trace:
     release_nodes+0x76/0x260
     devres_release_all+0x3c/0x50
     device_release_driver_internal+0x159/0x200
     device_release_driver+0x12/0x20
     bus_remove_device+0xfd/0x170
     device_del+0x1e8/0x330
     platform_device_del+0x28/0x90
     platform_device_unregister+0x12/0x30
     nfit_test_exit+0x2a/0x93b [nfit_test]

Cc: <stable@vger.kernel.org>
Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 tools/testing/nvdimm/test/nfit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index 47ab1ab..ffdb7d0 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -2388,7 +2388,7 @@ static __init int nfit_test_init(void)
 			nfit_test->setup = nfit_test0_setup;
 			break;
 		case 1:
-			nfit_test->num_pm = 1;
+			nfit_test->num_pm = 2;
 			nfit_test->dcr_idx = NUM_DCR;
 			nfit_test->num_dcr = 2;
 			nfit_test->alloc = nfit_test1_alloc;
-- 
1.8.3.1

