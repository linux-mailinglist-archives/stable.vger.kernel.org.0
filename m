Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2561637CC9F
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244423AbhELQpy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:45:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:33526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239339AbhELQjN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:39:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC4CD61CDF;
        Wed, 12 May 2021 16:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835398;
        bh=gY9Pp0xiZuLgyrykZk4BpV1fMrVQZQKidXqE3FDqiKg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RRFQ82hurHulzWpN1XZRRO/emmX260szEuR4j7q7ZwWH0Ei54x7Cen/ko7x0gFwAP
         u9sfCcvE6LU3T2c5tw5T946Gp1yPd3OmXxggyi6Cdg/VdqgeEi6xBnE/X6Fyr/agDd
         2HnMtkqeBjrFTAEjwjeGi6/5umZVjUPanI3NN9iY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 327/677] btrfs: zoned: bail out in btrfs_alloc_chunk for bad input
Date:   Wed, 12 May 2021 16:46:13 +0200
Message-Id: <20210512144848.110528854@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit bb05b298af8b2330db2b39971bf0029798e7ad59 ]

gcc complains that the ctl->max_chunk_size member might be used
uninitialized when none of the three conditions for initializing it in
init_alloc_chunk_ctl_policy_zoned() are true:

In function ‘init_alloc_chunk_ctl_policy_zoned’,
    inlined from ‘init_alloc_chunk_ctl’ at fs/btrfs/volumes.c:5023:3,
    inlined from ‘btrfs_alloc_chunk’ at fs/btrfs/volumes.c:5340:2:
include/linux/compiler-gcc.h:48:45: error: ‘ctl.max_chunk_size’ may be used uninitialized [-Werror=maybe-uninitialized]
 4998 |         ctl->max_chunk_size = min(limit, ctl->max_chunk_size);
      |                               ^~~
fs/btrfs/volumes.c: In function ‘btrfs_alloc_chunk’:
fs/btrfs/volumes.c:5316:32: note: ‘ctl’ declared here
 5316 |         struct alloc_chunk_ctl ctl;
      |                                ^~~

If we ever get into this condition, something is seriously
wrong, as validity is checked in the callers

  btrfs_alloc_chunk
    init_alloc_chunk_ctl
      init_alloc_chunk_ctl_policy_zoned

so the same logic as in init_alloc_chunk_ctl_policy_regular()
and a few other places should be applied. This avoids both further
data corruption, and the compile-time warning.

Fixes: 1cd6121f2a38 ("btrfs: zoned: implement zoned chunk allocator")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/volumes.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 1c6810bbaf8b..3912eda7905f 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4989,6 +4989,8 @@ static void init_alloc_chunk_ctl_policy_zoned(
 		ctl->max_chunk_size = 2 * ctl->max_stripe_size;
 		ctl->devs_max = min_t(int, ctl->devs_max,
 				      BTRFS_MAX_DEVS_SYS_CHUNK);
+	} else {
+		BUG();
 	}
 
 	/* We don't want a chunk larger than 10% of writable space */
-- 
2.30.2



