Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A15B31EAD4
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 11:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726212AbfEOJTW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 05:19:22 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:8195 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725871AbfEOJTW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 05:19:22 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 1D72BC7EB305D65CEB4E;
        Wed, 15 May 2019 17:19:21 +0800 (CST)
Received: from FRA1000014316.huawei.com (100.126.230.97) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.439.0; Wed, 15 May 2019 17:19:09 +0800
From:   Jonathan Cameron <Jonathan.Cameron@huawei.com>
To:     <shameerali.kolothum.thodi@huawei.com>
CC:     Jean-Philippe Brucker <jean-philippe.brucker@arm.com>,
        <stable@vger.kernel.org>, Will Deacon <will.deacon@arm.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 46/60] arm64: Clear OSDLR_EL1 on CPU boot
Date:   Wed, 15 May 2019 17:17:23 +0800
Message-ID: <20190515091737.18578-46-Jonathan.Cameron@huawei.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190515091737.18578-1-Jonathan.Cameron@huawei.com>
References: <20190515091737.18578-1-Jonathan.Cameron@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [100.126.230.97]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>

Some firmwares may reboot CPUs with OS Double Lock set. Make sure that
it is unlocked, in order to use debug exceptions.

Cc: <stable@vger.kernel.org>
Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 arch/arm64/kernel/debug-monitors.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kernel/debug-monitors.c b/arch/arm64/kernel/debug-monitors.c
index 800486cc48239..555b6bd2f3d68 100644
--- a/arch/arm64/kernel/debug-monitors.c
+++ b/arch/arm64/kernel/debug-monitors.c
@@ -135,6 +135,7 @@ NOKPROBE_SYMBOL(disable_debug_monitors);
  */
 static int clear_os_lock(unsigned int cpu)
 {
+	write_sysreg(0, osdlr_el1);
 	write_sysreg(0, oslar_el1);
 	isb();
 	return 0;
-- 
2.19.1

