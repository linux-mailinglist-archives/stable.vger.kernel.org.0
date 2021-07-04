Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD94E3BB2A0
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233363AbhGDXQA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:16:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:55624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234137AbhGDXOz (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:14:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 072B8619B0;
        Sun,  4 Jul 2021 23:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440281;
        bh=b/CIhG+SKlQx6SI8ki7u97CIeZH13CqdD0xfsr05kgU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nsG3bBCW+GpfvqgKWRhRrdo2Q5v7ZJqPtXjv9NoOawkjH1W3Rxfq0OG3iKxhBlWdQ
         jIOKPbgbrkNcvpO3PDQwesvTttsIhX95aoo/TBTJA9hNkHhz9Icq8/NK7xO9i1IG1r
         BugFFakoaTRPU7Dsck0I4zpOAc+KF3ibIY77m+n2ICVd/8/s9HkqolIsGTd5zHul0j
         E2nqivIqGx3JriQ8hHhI9CO29XX+8vyPv48Sj6fGR13o2xWiX2tOjnvtLp+lD16qSO
         ZOhR+L1pB4lc1PXAiCFle6/LZ8uStexRZgdsEBirvh0mJsF1tXrhq66/w54xeYMy9/
         2hFuCEXL3rUIg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        kernel test robot <lkp@intel.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 30/31] btrfs: disable build on platforms having page size 256K
Date:   Sun,  4 Jul 2021 19:10:42 -0400
Message-Id: <20210704231043.1491209-30-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704231043.1491209-1-sashal@kernel.org>
References: <20210704231043.1491209-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit b05fbcc36be1f8597a1febef4892053a0b2f3f60 ]

With a config having PAGE_SIZE set to 256K, BTRFS build fails
with the following message

  include/linux/compiler_types.h:326:38: error: call to
  '__compiletime_assert_791' declared with attribute error:
  BUILD_BUG_ON failed: (BTRFS_MAX_COMPRESSED % PAGE_SIZE) != 0

BTRFS_MAX_COMPRESSED being 128K, BTRFS cannot support platforms with
256K pages at the time being.

There are two platforms that can select 256K pages:
 - hexagon
 - powerpc

Disable BTRFS when 256K page size is selected. Supporting this would
require changes to the subpage mode that's currently being developed.
Given that 256K is many times larger than page sizes commonly used and
for what the algorithms and structures have been tuned, it's out of
scope and disabling build is a reasonable option.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
[ update changelog ]
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/Kconfig b/fs/btrfs/Kconfig
index 23537bc8c827..7233127bb93a 100644
--- a/fs/btrfs/Kconfig
+++ b/fs/btrfs/Kconfig
@@ -12,6 +12,8 @@ config BTRFS_FS
 	select RAID6_PQ
 	select XOR_BLOCKS
 	select SRCU
+	depends on !PPC_256K_PAGES	# powerpc
+	depends on !PAGE_SIZE_256KB	# hexagon
 
 	help
 	  Btrfs is a general purpose copy-on-write filesystem with extents,
-- 
2.30.2

