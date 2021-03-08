Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10DF6330E16
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 13:35:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbhCHMfR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 07:35:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:43756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229950AbhCHMes (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 07:34:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D9D5D651C9;
        Mon,  8 Mar 2021 12:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615206887;
        bh=ym8wd/Ubr9g/GbZG3aJ84RYjH82G13HigPDID7JJF6c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oYCZkk0Iefqrm74tNw0WNV+NkgMGWHjWsJXnKMR1pPCIgcBlbmLxKsNVpg2Cb036G
         Bc1pOn+rWE70wk9TBJ7fNdajyA+zrh6Vf5WhEYvol3x25KMF8fUVzcmZSmNndrq8vg
         kuIFWMaI3StGiKKd/W9X7Qmjp/T/UUKtC0gXmMPs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jing Xiangfeng <jingxiangfeng@huawei.com>
Subject: [PATCH 5.10 40/42] of: unittest: Fix build on architectures without CONFIG_OF_ADDRESS
Date:   Mon,  8 Mar 2021 13:31:06 +0100
Message-Id: <20210308122720.062508474@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210308122718.120213856@linuxfoundation.org>
References: <20210308122718.120213856@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Catalin Marinas <catalin.marinas@arm.com>

commit aed5041ef9a3f594ed9dc0bb5ee7e1bbccfd3366 upstream.

of_dma_get_max_cpu_address() is not defined if !CONFIG_OF_ADDRESS, so
return early in of_unittest_dma_get_max_cpu_address().

Fixes: 07d13a1d6120 ("of: unittest: Add test for of_dma_get_max_cpu_address()")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Jing Xiangfeng <jingxiangfeng@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/unittest.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/of/unittest.c
+++ b/drivers/of/unittest.c
@@ -874,6 +874,9 @@ static void __init of_unittest_dma_get_m
 	struct device_node *np;
 	phys_addr_t cpu_addr;
 
+	if (!IS_ENABLED(CONFIG_OF_ADDRESS))
+		return;
+
 	np = of_find_node_by_path("/testcase-data/address-tests");
 	if (!np) {
 		pr_err("missing testcase data\n");


