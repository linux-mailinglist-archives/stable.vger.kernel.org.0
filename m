Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 130323BB289
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232527AbhGDXPq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:15:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:56968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233805AbhGDXOk (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:14:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 71E7461999;
        Sun,  4 Jul 2021 23:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440235;
        bh=d91l8YOMkXlStC5R05sJlbRKTozf270BCQBHcP2Iu4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KORuoefTpW4ZxmZbh5Yw4ryLvJjv30n43bzIQNYCW7kr1c/3irAFGPwLXUpbXrvd4
         fAHqxN7mOyLziNdlLdyVKiqvJBY+DaGZmco7dQTbDo9eM5Zt1zfeQX81f7KcQfRieY
         z7eGBOqafcBqZrBglIddQg844fBxzxKgAXnA7i48gaPmZzCAqIG1+GUOqPr8YLHkgA
         OCVn5q2XjXE82UcCadYIouXbYSc+fvygC9UuDpjalGNuTbepa9ARgKAZItrDwTEe1p
         AiKmPulV+uxRq78u/wIx7exI2l7HGkIiKw3gKI8hO7JpL2nArkBbSRkeSXiXhYygMk
         iCDvLzAX2Ujcw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        kernel test robot <lkp@intel.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 44/50] btrfs: disable build on platforms having page size 256K
Date:   Sun,  4 Jul 2021 19:09:32 -0400
Message-Id: <20210704230938.1490742-44-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230938.1490742-1-sashal@kernel.org>
References: <20210704230938.1490742-1-sashal@kernel.org>
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
index 38651fae7f21..0aa1bee24d80 100644
--- a/fs/btrfs/Kconfig
+++ b/fs/btrfs/Kconfig
@@ -14,6 +14,8 @@ config BTRFS_FS
 	select RAID6_PQ
 	select XOR_BLOCKS
 	select SRCU
+	depends on !PPC_256K_PAGES	# powerpc
+	depends on !PAGE_SIZE_256KB	# hexagon
 
 	help
 	  Btrfs is a general purpose copy-on-write filesystem with extents,
-- 
2.30.2

