Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFD88450F65
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:28:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241743AbhKOSat (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:30:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:40012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241821AbhKOS3C (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:29:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67DA963443;
        Mon, 15 Nov 2021 17:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999062;
        bh=f+k4pf/lIk9rBI5b9QTxE6NgaYlPDGRU6VXqapoxdQo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AKkZ5GTUd5XVvIV5bUPnkoh7j1P4YPEpC1GW6e7Mm+up0+1CCEjnio0q1IK4wHw0u
         XkbiZ5scoZeNZGSlDu8KcHjGSe1dkDF6guDKOr6WH5kLMOLWkZnfHJADPN/NK+oJep
         vazxUqOu1MIeBg4bSnnI56f9Ax6QwVywa+NermMc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaoming Ni <nixiaoming@huawei.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.14 162/849] powerpc/85xx: Fix oops when mpc85xx_smp_guts_ids node cannot be found
Date:   Mon, 15 Nov 2021 17:54:05 +0100
Message-Id: <20211115165425.645198470@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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


