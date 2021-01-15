Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 541E02F7A82
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:52:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732260AbhAOMgA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:36:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:43058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387788AbhAOMf7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:35:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 293102399C;
        Fri, 15 Jan 2021 12:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714118;
        bh=JnrR4vsSbpqjqdW8b9BavNLaK+WKxDy4qbB7pMGWGPw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Wc/nOvMBYVNxDegG3yaKsmmNqH+m+P6UsKyZ/MYXDfRW0Yk2Gt/WDgebqX4iNCSV
         wvve6/YMN1GAX6H2XYfePTyKBhw1jdaKgD8A0mbXt+ckGmgUtAyuqv6TEk6gHo+1Na
         0fWqWct/oD9j4/0nUzjH/Jk7ezjyzp2RQWXvcwcw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaolei Wang <xiaolei.wang@windriver.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 55/62] regmap: debugfs: Fix a memory leak when calling regmap_attach_dev
Date:   Fri, 15 Jan 2021 13:28:17 +0100
Message-Id: <20210115122001.049398706@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115121958.391610178@linuxfoundation.org>
References: <20210115121958.391610178@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaolei Wang <xiaolei.wang@windriver.com>

commit cffa4b2122f5f3e53cf3d529bbc74651f95856d5 upstream.

After initializing the regmap through
syscon_regmap_lookup_by_compatible, then regmap_attach_dev to the
device, because the debugfs_name has been allocated, there is no
need to redistribute it again

unreferenced object 0xd8399b80 (size 64):
  comm "swapper/0", pid 1, jiffies 4294937641 (age 278.590s)
  hex dump (first 32 bytes):
	64 75 6d 6d 79 2d 69 6f 6d 75 78 63 2d 67 70 72
dummy-iomuxc-gpr
	40 32 30 65 34 30 30 30 00 7f 52 5b d8 7e 42 69
@20e4000..R[.~Bi
  backtrace:
    [<ca384d6f>] kasprintf+0x2c/0x54
    [<6ad3bbc2>] regmap_debugfs_init+0xdc/0x2fc
    [<bc4181da>] __regmap_init+0xc38/0xd88
    [<1f7e0609>] of_syscon_register+0x168/0x294
    [<735e8766>] device_node_get_regmap+0x6c/0x98
    [<d96c8982>] imx6ul_init_machine+0x20/0x88
    [<0456565b>] customize_machine+0x1c/0x30
    [<d07393d8>] do_one_initcall+0x80/0x3ac
    [<7e584867>] kernel_init_freeable+0x170/0x1f0
    [<80074741>] kernel_init+0x8/0x120
    [<285d6f28>] ret_from_fork+0x14/0x20
    [<00000000>] 0x0

Fixes: 9b947a13e7f6 ("regmap: use debugfs even when no device")
Signed-off-by: Xiaolei Wang <xiaolei.wang@windriver.com>
Link: https://lore.kernel.org/r/20201229105046.41984-1-xiaolei.wang@windriver.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/regmap/regmap-debugfs.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -583,18 +583,25 @@ void regmap_debugfs_init(struct regmap *
 		devname = dev_name(map->dev);
 
 	if (name) {
-		map->debugfs_name = kasprintf(GFP_KERNEL, "%s-%s",
+		if (!map->debugfs_name) {
+			map->debugfs_name = kasprintf(GFP_KERNEL, "%s-%s",
 					      devname, name);
+			if (!map->debugfs_name)
+				return;
+		}
 		name = map->debugfs_name;
 	} else {
 		name = devname;
 	}
 
 	if (!strcmp(name, "dummy")) {
-		kfree(map->debugfs_name);
+		if (!map->debugfs_name)
+			kfree(map->debugfs_name);
 
 		map->debugfs_name = kasprintf(GFP_KERNEL, "dummy%d",
 						dummy_index);
+		if (!map->debugfs_name)
+				return;
 		name = map->debugfs_name;
 		dummy_index++;
 	}


