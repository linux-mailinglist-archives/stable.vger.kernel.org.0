Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7D7451341
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:52:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347960AbhKOTtR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:49:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:44636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245509AbhKOTUl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:20:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61F3963265;
        Mon, 15 Nov 2021 18:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001374;
        bh=f+k4pf/lIk9rBI5b9QTxE6NgaYlPDGRU6VXqapoxdQo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cGkTnRUm7DqVHu6f0DHTLNi0JpMj9G9qN3f3OJZjpJOKFoAGEs95JcXa0i+EugWto
         lOVuquOtPFY8yZLGInd3C8hTWYwQQADWt7qwzfKIgSU137RDT+gLaRf6vJ+D4Ts3dP
         UCRhy8b45Ey+QfGO+PttN2tzz4DziD9klYCj4PoA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaoming Ni <nixiaoming@huawei.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.15 132/917] powerpc/85xx: Fix oops when mpc85xx_smp_guts_ids node cannot be found
Date:   Mon, 15 Nov 2021 17:53:47 +0100
Message-Id: <20211115165433.242864417@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
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


