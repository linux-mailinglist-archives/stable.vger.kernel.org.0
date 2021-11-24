Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64B6B45BF07
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:51:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344399AbhKXMyi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:54:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:56302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244875AbhKXMwV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:52:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA18861164;
        Wed, 24 Nov 2021 12:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757016;
        bh=krP28d1Ar2BWTNQ31jnIRNtwHZlSMhwd9NV4gENJ7Dg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f1Q5ViPd4lOmCVu3S7igXDPY99Q6srHIYxUcbPen286G91V6TGE0sCbDy9vO4NZ14
         2l+JY34HMMa6bpuW2kMS5CakRE7kZBs9qdyetSdlbYgLwsYTW7IqlEyDLtkQYsXZoK
         eD3e84Mo6N/iR7XOm8YZTpKjKfNf8cV6x2WT70xI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>,
        Mark Rutland <mark.rutland@arm.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        jing yangyang <jing.yangyang@zte.com.cn>
Subject: [PATCH 4.19 011/323] firmware/psci: fix application of sizeof to pointer
Date:   Wed, 24 Nov 2021 12:53:21 +0100
Message-Id: <20211124115719.208634276@linuxfoundation.org>
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

From: jing yangyang <cgel.zte@gmail.com>

commit 2ac5fb35cd520ab1851c9a4816c523b65276052f upstream.

sizeof when applied to a pointer typed expression gives the size of
the pointer.

./drivers/firmware/psci/psci_checker.c:158:41-47: ERROR application of sizeof to pointer

This issue was detected with the help of Coccinelle.

Fixes: 7401056de5f8 ("drivers/firmware: psci_checker: stash and use topology_core_cpumask for hotplug tests")
Cc: stable@vger.kernel.org
Reported-by: Zeal Robot <zealci@zte.com.cn>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: jing yangyang <jing.yangyang@zte.com.cn>
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/psci_checker.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/firmware/psci_checker.c
+++ b/drivers/firmware/psci_checker.c
@@ -162,7 +162,7 @@ static int alloc_init_cpu_groups(cpumask
 	if (!alloc_cpumask_var(&tmp, GFP_KERNEL))
 		return -ENOMEM;
 
-	cpu_groups = kcalloc(nb_available_cpus, sizeof(cpu_groups),
+	cpu_groups = kcalloc(nb_available_cpus, sizeof(*cpu_groups),
 			     GFP_KERNEL);
 	if (!cpu_groups) {
 		free_cpumask_var(tmp);


