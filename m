Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8EB41BD84
	for <lists+stable@lfdr.de>; Wed, 29 Sep 2021 05:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242224AbhI2Dic (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 23:38:32 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:26963 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241509AbhI2Dib (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Sep 2021 23:38:31 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HK24c4X3qzbmvH;
        Wed, 29 Sep 2021 11:32:32 +0800 (CST)
Received: from dggema774-chm.china.huawei.com (10.1.198.216) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 11:36:49 +0800
Received: from use12-sp2.huawei.com (10.67.189.174) by
 dggema774-chm.china.huawei.com (10.1.198.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.8; Wed, 29 Sep 2021 11:36:48 +0800
From:   Xiaoming Ni <nixiaoming@huawei.com>
To:     <oss@buserror.net>, <mpe@ellerman.id.au>,
        <benh@kernel.crashing.org>, <paulus@samba.org>,
        <paul.gortmaker@windriver.com>, <chenhui.zhao@freescale.com>,
        <Yuantian.Tang@feescale.com>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        <gregkh@linuxfoundation.org>
CC:     <wangle6@huawei.com>, <liuwenliang@huawei.com>,
        <chenjianguo3@huawei.com>, <nixiaoming@huawei.com>
Subject: [PATCH v2 1/2] powerpc:85xx:Fix oops when mpc85xx_smp_guts_ids node cannot be found
Date:   Wed, 29 Sep 2021 11:36:45 +0800
Message-ID: <20210929033646.39630-2-nixiaoming@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210929033646.39630-1-nixiaoming@huawei.com>
References: <021a5ee3-25ef-1de4-0111-d4c3281e0f45@huawei.com>
 <20210929033646.39630-1-nixiaoming@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.189.174]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggema774-chm.china.huawei.com (10.1.198.216)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When the field described in mpc85xx_smp_guts_ids[] is not configured in
 dtb, the mpc85xx_setup_pmc() does not assign a value to the "guts"
 variable. As a result, the oops is triggered when
 mpc85xx_freeze_time_base() is executed.

Fixes:56f1ba280719 ("powerpc/mpc85xx: refactor the PM operations")
Cc: stable@vger.kernel.org #v4.6
Signed-off-by: Xiaoming Ni <nixiaoming@huawei.com>
---
 arch/powerpc/platforms/85xx/mpc85xx_pm_ops.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/85xx/mpc85xx_pm_ops.c b/arch/powerpc/platforms/85xx/mpc85xx_pm_ops.c
index 7c0133f558d0..ffa8a7a6a2db 100644
--- a/arch/powerpc/platforms/85xx/mpc85xx_pm_ops.c
+++ b/arch/powerpc/platforms/85xx/mpc85xx_pm_ops.c
@@ -94,9 +94,8 @@ int __init mpc85xx_setup_pmc(void)
 			pr_err("Could not map guts node address\n");
 			return -ENOMEM;
 		}
+		qoriq_pm_ops = &mpc85xx_pm_ops;
 	}
 
-	qoriq_pm_ops = &mpc85xx_pm_ops;
-
 	return 0;
 }
-- 
2.27.0

