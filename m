Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 419B6450EDC
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:18:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241473AbhKOSUi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:20:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:56282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241171AbhKOSSh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:18:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E2AD633F7;
        Mon, 15 Nov 2021 17:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998683;
        bh=WB6MbKLKedrVfpPzHLDPxMlz+56MEw5M6n7E8d+mgfg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eT4zpEb23sZHrT8LVxUBWyJIbGvEn2+6LIywzuRB9INIwkMDd4iHnGT0BaC0AgOmD
         GVEH9bnjZQ9Grs0sxc1LQfZ6wQ9cf+iiZV1eKM/xD37fZroPtCjp8lQU1tW9rwoOUY
         jNctACwWfNKs4rqbgtP3fqSsgZxtMF3Gk36kt2DE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>,
        Mark Rutland <mark.rutland@arm.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        jing yangyang <jing.yangyang@zte.com.cn>
Subject: [PATCH 5.14 022/849] firmware/psci: fix application of sizeof to pointer
Date:   Mon, 15 Nov 2021 17:51:45 +0100
Message-Id: <20211115165420.744926141@linuxfoundation.org>
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
 drivers/firmware/psci/psci_checker.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/firmware/psci/psci_checker.c
+++ b/drivers/firmware/psci/psci_checker.c
@@ -155,7 +155,7 @@ static int alloc_init_cpu_groups(cpumask
 	if (!alloc_cpumask_var(&tmp, GFP_KERNEL))
 		return -ENOMEM;
 
-	cpu_groups = kcalloc(nb_available_cpus, sizeof(cpu_groups),
+	cpu_groups = kcalloc(nb_available_cpus, sizeof(*cpu_groups),
 			     GFP_KERNEL);
 	if (!cpu_groups) {
 		free_cpumask_var(tmp);


