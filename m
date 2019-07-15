Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 160F568B80
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 15:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730727AbfGONi5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 09:38:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:39968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731097AbfGONi4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 09:38:56 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F2AC21530;
        Mon, 15 Jul 2019 13:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563197935;
        bh=E2IlxDnxRzpURG/a4YOJ+pc1wc8mQLpQJwE8n6zaDw0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=frF4NjkVKHa0+cxsnLVWQgHee0Bns1UxcQ/XYw7RNwI/Wgtf6RVi3OBlxqVtBLUfO
         UCSytzNCpsIrYkdKHZIT5XceEksj1AOgRInHTDCMhjq8N2XO6AXpWTJ2KKoQU6LXFh
         LjCcbBy7fexO4D8yuCyodGgv/XhEGvVqt14/8gxA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Baluta <daniel.baluta@nxp.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.1 017/219] regmap: debugfs: Fix memory leak in regmap_debugfs_init
Date:   Mon, 15 Jul 2019 09:34:49 -0400
Message-Id: <20190715133811.2441-17-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715133811.2441-1-sashal@kernel.org>
References: <20190715133811.2441-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Baluta <daniel.baluta@nxp.com>

[ Upstream commit 2899872b627e99b7586fe3b6c9f861da1b4d5072 ]

As detected by kmemleak running on i.MX6ULL board:

nreferenced object 0xd8366600 (size 64):
  comm "swapper/0", pid 1, jiffies 4294937370 (age 933.220s)
  hex dump (first 32 bytes):
    64 75 6d 6d 79 2d 69 6f 6d 75 78 63 2d 67 70 72  dummy-iomuxc-gpr
    40 32 30 65 34 30 30 30 00 e3 f3 ab fe d1 1b dd  @20e4000........
  backtrace:
    [<b0402aec>] kasprintf+0x2c/0x54
    [<a6fbad2c>] regmap_debugfs_init+0x7c/0x31c
    [<9c8d91fa>] __regmap_init+0xb5c/0xcf4
    [<5b1c3d2a>] of_syscon_register+0x164/0x2c4
    [<596a5d80>] syscon_node_to_regmap+0x64/0x90
    [<49bd597b>] imx6ul_init_machine+0x34/0xa0
    [<250a4dac>] customize_machine+0x1c/0x30
    [<2d19fdaf>] do_one_initcall+0x7c/0x398
    [<e6084469>] kernel_init_freeable+0x328/0x448
    [<168c9101>] kernel_init+0x8/0x114
    [<913268aa>] ret_from_fork+0x14/0x20
    [<ce7b131a>] 0x0

Root cause is that map->debugfs_name is allocated using kasprintf
and then the pointer is lost by assigning it other memory address.

Reported-by: Stefan Wahren <stefan.wahren@i2se.com>
Signed-off-by: Daniel Baluta <daniel.baluta@nxp.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/regmap/regmap-debugfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index 19eb454f26c3..df2893d4626b 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -565,6 +565,8 @@ void regmap_debugfs_init(struct regmap *map, const char *name)
 	}
 
 	if (!strcmp(name, "dummy")) {
+		kfree(map->debugfs_name);
+
 		map->debugfs_name = kasprintf(GFP_KERNEL, "dummy%d",
 						dummy_index);
 		name = map->debugfs_name;
-- 
2.20.1

