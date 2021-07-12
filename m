Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 957303C4C92
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242072AbhGLHGO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:06:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:39036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242762AbhGLHEJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:04:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6AF8C610E6;
        Mon, 12 Jul 2021 07:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073281;
        bh=9brvtHm5P1xX4on/zdIiSZ+3b4pLzhJ4IaEBj2zRwds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BE6HjXSvh1QRN8Kk7HN8r8zn+zVgiFU23dzgpbTVGtNgbOUjvpm8ZMjOqWdpVJGlk
         i5sWbaN8p+NLfTJ4Q/ROoI02VboziQFA2Uh9ogwPaHNvkP2Mq4gV161DR6n7kAqEZ9
         mqL30/4Ajlq2dRQ65WR5O6z2cysE3Yr0DVz1qIDs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 188/700] btrfs: disable build on platforms having page size 256K
Date:   Mon, 12 Jul 2021 08:04:31 +0200
Message-Id: <20210712060953.371952153@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



