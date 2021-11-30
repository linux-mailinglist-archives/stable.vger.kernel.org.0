Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37A984638EA
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 16:03:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244891AbhK3PG1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 10:06:27 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48632 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243438AbhK3O4f (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:56:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 090BAB81A61;
        Tue, 30 Nov 2021 14:53:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2837C53FC7;
        Tue, 30 Nov 2021 14:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283994;
        bh=sv6SHN8BiLPKNf1x5CfhepLuwQcvghPgfP6OXk2juBA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oHZxRmAVkmlTedR4+L4lO01LiwmGe9FnKT4XucP350tjFOvCSq5damahbTExcgkRd
         tqRDvWqm1f0Lb/mG+wB/s0nwfdfF4PbmUG8sZUky0rVAYWakU1H00yJ6mCUcjKOHSB
         LobuWo/GCNO8BKY3lWByW79uPFUN64zWYd/SojCCJapJc3PbmKNPfQqrVJ7/IonaWC
         mNPiF/XiekjeJkjh7WblaZkwmL10M2DHFaXuI3ZiPUsgVMioQKDgqdThx44m0PQzoM
         elwIpvNPxmO60HaDXhZgD823MGIN1Sdrmjr5pfJIt+UP8JrkvP80P9Y+QDa1xQ+YdC
         hGZ6lqQL9pUfA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Anton Altaparmakov <anton@tuxera.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-ntfs-dev@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.19 17/17] fs: ntfs: Limit NTFS_RW to page sizes smaller than 64k
Date:   Tue, 30 Nov 2021 09:52:41 -0500
Message-Id: <20211130145243.946407-17-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130145243.946407-1-sashal@kernel.org>
References: <20211130145243.946407-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 4eec7faf6775263d9e450ae7ee5bc4101d4a0bc9 ]

NTFS_RW code allocates page size dependent arrays on the stack. This
results in build failures if the page size is 64k or larger.

  fs/ntfs/aops.c: In function 'ntfs_write_mst_block':
  fs/ntfs/aops.c:1311:1: error:
	the frame size of 2240 bytes is larger than 2048 bytes

Since commit f22969a66041 ("powerpc/64s: Default to 64K pages for 64 bit
book3s") this affects ppc:allmodconfig builds, but other architectures
supporting page sizes of 64k or larger are also affected.

Increasing the maximum frame size for affected architectures just to
silence this error does not really help.  The frame size would have to
be set to a really large value for 256k pages.  Also, a large frame size
could potentially result in stack overruns in this code and elsewhere
and is therefore not desirable.  Make NTFS_RW dependent on page sizes
smaller than 64k instead.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Cc: Anton Altaparmakov <anton@tuxera.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ntfs/Kconfig b/fs/ntfs/Kconfig
index f5a868cc9152e..5b384ec44793f 100644
--- a/fs/ntfs/Kconfig
+++ b/fs/ntfs/Kconfig
@@ -51,6 +51,7 @@ config NTFS_DEBUG
 config NTFS_RW
 	bool "NTFS write support"
 	depends on NTFS_FS
+	depends on PAGE_SIZE_LESS_THAN_64KB
 	help
 	  This enables the partial, but safe, write support in the NTFS driver.
 
-- 
2.33.0

