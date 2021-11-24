Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15DBB45BF6C
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:55:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347036AbhKXM5y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:57:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:33124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346344AbhKXMzy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:55:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 27F81615E6;
        Wed, 24 Nov 2021 12:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757126;
        bh=ppjQpJ3BT+IxHTPIg1arb5LdUzdb7vcG/rv012g1/8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RrAWx8Mjx4RwqPvmvWeHH4qo43+A3s3uwKXqUul1vGK+A00ZaLT5sSsE+Zx7nvY02
         Qa8beFzg6SByRpSaQGmUYa2Xbzuwair32sOoApp8vQB7KDk+VB6jGPuPwWEot9wzOI
         PP70vAVU+xymev7TabCcJprggrcDiJESX5gtZlck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaoming Ni <nixiaoming@huawei.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.19 067/323] powerpc/85xx: Fix oops when mpc85xx_smp_guts_ids node cannot be found
Date:   Wed, 24 Nov 2021 12:54:17 +0100
Message-Id: <20211124115721.122647587@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaoming Ni <nixiaoming@huawei.com>

commit 3c2172c1c47b4079c29f0e6637d764a99355ebcd upstream.

When the field described in mpc85xx_smp_guts_ids[] is not configured in
dtb, the mpc85xx_setup_pmc() does not assign a value to the "guts"
variable. As a result, the oops is triggered when
mpc85xx_freeze_time_base() is executed.

Fixes: 56f1ba280719 ("powerpc/mpc85xx: refactor the PM operations")
Cc: stable@vger.kernel.org # v4.6+
Signed-off-by: Xiaoming Ni <nixiaoming@huawei.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210929033646.39630-2-nixiaoming@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/platforms/85xx/mpc85xx_pm_ops.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/powerpc/platforms/85xx/mpc85xx_pm_ops.c
+++ b/arch/powerpc/platforms/85xx/mpc85xx_pm_ops.c
@@ -98,9 +98,8 @@ int __init mpc85xx_setup_pmc(void)
 			pr_err("Could not map guts node address\n");
 			return -ENOMEM;
 		}
+		qoriq_pm_ops = &mpc85xx_pm_ops;
 	}
 
-	qoriq_pm_ops = &mpc85xx_pm_ops;
-
 	return 0;
 }


