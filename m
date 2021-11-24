Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0918A45BB07
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:13:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243019AbhKXMPp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:15:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:47098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243574AbhKXMOM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:14:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D54E6113A;
        Wed, 24 Nov 2021 12:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755759;
        bh=ppjQpJ3BT+IxHTPIg1arb5LdUzdb7vcG/rv012g1/8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ONdq2RvZbVLgLRXUiv7d+va2sPaM0ZN/a2aXrHOtEIQvh5B/t1wsLRJ0r3BG7Ymqp
         NIVJo8/TjS48d697DlDoykaeAq82xi3e3OC4v7XZ8a1kJJ5IKrxdCf9auwatfNJ68x
         itm0Vlmjii1CpBdD2bD9ePTm8nqKm068fmZvGR5M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaoming Ni <nixiaoming@huawei.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.9 046/207] powerpc/85xx: Fix oops when mpc85xx_smp_guts_ids node cannot be found
Date:   Wed, 24 Nov 2021 12:55:17 +0100
Message-Id: <20211124115705.425733167@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115703.941380739@linuxfoundation.org>
References: <20211124115703.941380739@linuxfoundation.org>
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


