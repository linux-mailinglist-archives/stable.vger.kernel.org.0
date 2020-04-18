Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84A621AEF16
	for <lists+stable@lfdr.de>; Sat, 18 Apr 2020 16:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbgDROkv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Apr 2020 10:40:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:49292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725903AbgDROkv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 Apr 2020 10:40:51 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 154F1221F4;
        Sat, 18 Apr 2020 14:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587220850;
        bh=WwMQnnlr9UFxuKnVYip2MbxhHSDl070mII4XwC96BvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Vviwj5T4TctrLGU1yZC03N2m4txI8yJXAGxosGdCZXxazio8iYhZJ9uhN/I8tlFE
         /hTgOIuO2E4KgNPrf7hS1M0tmXgvUPyw4NtrsGZ6cZ8UqKo/Qg2ahoid5cSRxmQsN/
         bmQ5Xijw+UfIcTz/KX0YAkgK49QG3Mjs0ZbVa6zY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jan Kara <jack@suse.cz>, Dan Williams <dan.j.williams@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-nvdimm@lists.01.org
Subject: [PATCH AUTOSEL 5.4 02/78] tools/testing/nvdimm: Fix compilation failure without CONFIG_DEV_DAX_PMEM_COMPAT
Date:   Sat, 18 Apr 2020 10:39:31 -0400
Message-Id: <20200418144047.9013-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200418144047.9013-1-sashal@kernel.org>
References: <20200418144047.9013-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

[ Upstream commit c0e71d602053e4e7637e4bc7d0bc9603ea77a33f ]

When a kernel is configured without CONFIG_DEV_DAX_PMEM_COMPAT, the
compilation of tools/testing/nvdimm fails with:

  Building modules, stage 2.
  MODPOST 11 modules
ERROR: "dax_pmem_compat_test" [tools/testing/nvdimm/test/nfit_test.ko] undefined!

Fix the problem by calling dax_pmem_compat_test() only if the kernel has
the required functionality.

Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20200123154720.12097-1-jack@suse.cz
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/nvdimm/test/nfit.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index bf6422a6af7ff..a8ee5c4d41ebb 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -3164,7 +3164,9 @@ static __init int nfit_test_init(void)
 	mcsafe_test();
 	dax_pmem_test();
 	dax_pmem_core_test();
+#ifdef CONFIG_DEV_DAX_PMEM_COMPAT
 	dax_pmem_compat_test();
+#endif
 
 	nfit_test_setup(nfit_test_lookup, nfit_test_evaluate_dsm);
 
-- 
2.20.1

