Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F293D1BCBF2
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 21:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728747AbgD1S03 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:26:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:37970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728742AbgD1S02 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:26:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5B1C208E0;
        Tue, 28 Apr 2020 18:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098388;
        bh=WwMQnnlr9UFxuKnVYip2MbxhHSDl070mII4XwC96BvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gbhP5OeYWiw7IPJM79Vt250W/3NXY6UzLUZ56ptbqtIjifBfjwnqsszCowOHSGWT8
         M1h0goctVktTSPpK36p1Y6PEtbMtILB2jfJHPmf1eiabCo/t0U52BqGCn4xebO1mAq
         RkJtZE45LT14vM6SUK8htCca5IAAXr8u5aKKbmgk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 002/167] tools/testing/nvdimm: Fix compilation failure without CONFIG_DEV_DAX_PMEM_COMPAT
Date:   Tue, 28 Apr 2020 20:22:58 +0200
Message-Id: <20200428182225.771266156@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182225.451225420@linuxfoundation.org>
References: <20200428182225.451225420@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



