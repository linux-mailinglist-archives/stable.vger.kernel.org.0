Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2B10490F31
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242271AbiAQRQh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:16:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243151AbiAQRNE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:13:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B8ECC0612E1;
        Mon, 17 Jan 2022 09:07:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E2479612A8;
        Mon, 17 Jan 2022 17:07:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CD79C36AE7;
        Mon, 17 Jan 2022 17:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642439264;
        bh=bpMBu5yH7MGhV8vmY6xchErCuexz35VkhDge5dgYqqc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FExpqSyb657oNhAYBqWsUjsdKQW6SbsRgpErO+hQMRBAYBxnHtEndaohC9CXeYg5w
         Ft3gTncbRV1XuUDnhS2LQcHCq0Su0HqBEdXMfWWH2p4Gr2N8zdcihGW/JK3MpFAwMA
         bKlBwrJipQGon+OBhoSRg09yx2SbXYjChDJ5oqVb73SMb9TXHXVYlwk1Mf4YurR41s
         jgUFLetw6c/LXzmHQGpd7q46UmR6Mrg3I+Vq6biQ3jHQwcJ/DE2L/4HnbrB3vLMD7c
         eulgvi0rGiiqeU6WZaYLkoxIu2DTv1Wk1qN4+rYEU94DCpPTbA2hLpl4vj7PZZCUZ+
         FL61TG0n0V5wA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lakshmi Sowjanya D <lakshmi.sowjanya.d@intel.com>,
        Wolfram Sang <wsa@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 10/13] i2c: designware-pci: Fix to change data types of hcnt and lcnt parameters
Date:   Mon, 17 Jan 2022 12:07:18 -0500
Message-Id: <20220117170722.1473137-10-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117170722.1473137-1-sashal@kernel.org>
References: <20220117170722.1473137-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lakshmi Sowjanya D <lakshmi.sowjanya.d@intel.com>

[ Upstream commit d52097010078c1844348dc0e467305e5f90fd317 ]

The data type of hcnt and lcnt in the struct dw_i2c_dev is of type u16.
It's better to have same data type in struct dw_scl_sda_cfg as well.

Reported-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Lakshmi Sowjanya D <lakshmi.sowjanya.d@intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-designware-pcidrv.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/i2c/busses/i2c-designware-pcidrv.c b/drivers/i2c/busses/i2c-designware-pcidrv.c
index 96f8230cd2d33..5c32a7ef476da 100644
--- a/drivers/i2c/busses/i2c-designware-pcidrv.c
+++ b/drivers/i2c/busses/i2c-designware-pcidrv.c
@@ -49,10 +49,10 @@ enum dw_pci_ctl_id_t {
 };
 
 struct dw_scl_sda_cfg {
-	u32 ss_hcnt;
-	u32 fs_hcnt;
-	u32 ss_lcnt;
-	u32 fs_lcnt;
+	u16 ss_hcnt;
+	u16 fs_hcnt;
+	u16 ss_lcnt;
+	u16 fs_lcnt;
 	u32 sda_hold;
 };
 
-- 
2.34.1

