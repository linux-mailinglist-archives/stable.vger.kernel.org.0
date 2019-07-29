Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24C6979644
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403769AbfG2TuP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:50:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:41126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726516AbfG2TuP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:50:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45D21205F4;
        Mon, 29 Jul 2019 19:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429814;
        bh=xwKZZt9RPsUw9lityUO2BIO1UFepdsEzObO9gq9lH30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FJOWWj8Hle7zicwWaMVYJiNVpGW/22BtU71lXtkLA/QrKTLLQjg2l6o/LyERpDTvh
         XlLaDcdzzXXvBEoaxrV42LiXzqY2cbkEKb46s2x0A2OpoCOPMjS/PokBJbf47jRbEv
         accOeyegBFNSl9c+y0dxumZlaVHPSrX7EcVNL5fE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Mathieu Malaterre <malat@debian.org>,
        Michael Neuling <mikey@neuling.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 103/215] powerpc: silence a -Wcast-function-type warning in dawr_write_file_bool
Date:   Mon, 29 Jul 2019 21:21:39 +0200
Message-Id: <20190729190756.898918407@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 548c54acba5bd1388d50727a9a126a42d0cd4ad0 ]

In commit c1fe190c0672 ("powerpc: Add force enable of DAWR on P9
option") the following piece of code was added:

   smp_call_function((smp_call_func_t)set_dawr, &null_brk, 0);

Since GCC 8 this triggers the following warning about incompatible
function types:

  arch/powerpc/kernel/hw_breakpoint.c:408:21: error: cast between incompatible function types from 'int (*)(struct arch_hw_breakpoint *)' to 'void (*)(void *)' [-Werror=cast-function-type]

Since the warning is there for a reason, and should not be hidden behind
a cast, provide an intermediate callback function to avoid the warning.

Fixes: c1fe190c0672 ("powerpc: Add force enable of DAWR on P9 option")
Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Mathieu Malaterre <malat@debian.org>
Signed-off-by: Michael Neuling <mikey@neuling.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/hw_breakpoint.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/hw_breakpoint.c b/arch/powerpc/kernel/hw_breakpoint.c
index a293a53b4365..50262597c222 100644
--- a/arch/powerpc/kernel/hw_breakpoint.c
+++ b/arch/powerpc/kernel/hw_breakpoint.c
@@ -370,6 +370,11 @@ void hw_breakpoint_pmu_read(struct perf_event *bp)
 bool dawr_force_enable;
 EXPORT_SYMBOL_GPL(dawr_force_enable);
 
+static void set_dawr_cb(void *info)
+{
+	set_dawr(info);
+}
+
 static ssize_t dawr_write_file_bool(struct file *file,
 				    const char __user *user_buf,
 				    size_t count, loff_t *ppos)
@@ -389,7 +394,7 @@ static ssize_t dawr_write_file_bool(struct file *file,
 
 	/* If we are clearing, make sure all CPUs have the DAWR cleared */
 	if (!dawr_force_enable)
-		smp_call_function((smp_call_func_t)set_dawr, &null_brk, 0);
+		smp_call_function(set_dawr_cb, &null_brk, 0);
 
 	return rc;
 }
-- 
2.20.1



