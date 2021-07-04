Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 252E83BB15D
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbhGDXLl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:11:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:48918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232471AbhGDXKf (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:10:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7351D6193E;
        Sun,  4 Jul 2021 23:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440075;
        bh=9brvtHm5P1xX4on/zdIiSZ+3b4pLzhJ4IaEBj2zRwds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mobURB0sDkIuLL3EKhswJ+x5fG4Da89Gl73mo0xUsaCIGOB7KIaleJ+eOo7tVMBhf
         kp8hWOtmVnhNVmKypkbaSnerzjvDgtfrMFDfog+VEA2jB9yC24/fN/pc+4nqaaxEqa
         e2ZsxY1qMsII8NzsYfO1KT/F4odGA0SJeqM5YXIJWlAJcKuVrQqD0PIEC73iHjHlS/
         HXu1O6Tj1em7IBdzd+CP7cQEUY7LL3SzPz/ksII+jUISR+5yPOY3Y4Rz8tdXjSqsDD
         2B2FYvLprK5aE879/KdzLR3jwg32dNeLQ5TShjbrSxaqBGJr31yyl8/O7/q86yVsgs
         VhEdjLbVCSJTw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        kernel test robot <lkp@intel.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 74/80] btrfs: disable build on platforms having page size 256K
Date:   Sun,  4 Jul 2021 19:06:10 -0400
Message-Id: <20210704230616.1489200-74-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230616.1489200-1-sashal@kernel.org>
References: <20210704230616.1489200-1-sashal@kernel.org>
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
index 68b95ad82126..520a0f6a7d9e 100644
--- a/fs/btrfs/Kconfig
+++ b/fs/btrfs/Kconfig
@@ -18,6 +18,8 @@ config BTRFS_FS
 	select RAID6_PQ
 	select XOR_BLOCKS
 	select SRCU
+	depends on !PPC_256K_PAGES	# powerpc
+	depends on !PAGE_SIZE_256KB	# hexagon
 
 	help
 	  Btrfs is a general purpose copy-on-write filesystem with extents,
-- 
2.30.2

