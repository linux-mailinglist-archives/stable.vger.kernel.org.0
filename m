Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 450527F249
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391740AbfHBJrF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:47:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:51686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391836AbfHBJrB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:47:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0AE22086A;
        Fri,  2 Aug 2019 09:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739220;
        bh=ub2i0odmx7m8MQjRuWxJMi/W74+GzzJ3ZvokLiAy6yo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aD/S7HUl9rDpBBlEI/uF3eAlWn0bIxAGnrQymTK1zLIzLvKDe+fmEfBkltbNMegD0
         5XmsSftpqgj1VVpLWlVgbIAm7jD+7Bpsy1/GP9+bmVTZ7jBXwte47cNqojsHOozQRc
         QBKYtTVO2jnPa9uwCwWujB4i0Uqbb6LoUkD16IV0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Menzel <pmenzel@molgen.mpg.de>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 158/223] nfsd: Fix overflow causing non-working mounts on 1 TB machines
Date:   Fri,  2 Aug 2019 11:36:23 +0200
Message-Id: <20190802092248.512740385@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092238.692035242@linuxfoundation.org>
References: <20190802092238.692035242@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 3b2d4dcf71c4a91b420f835e52ddea8192300a3b ]

Since commit 10a68cdf10 (nfsd: fix performance-limiting session
calculation) (Linux 5.1-rc1 and 4.19.31), shares from NFS servers with
1 TB of memory cannot be mounted anymore. The mount just hangs on the
client.

The gist of commit 10a68cdf10 is the change below.

    -avail = clamp_t(int, avail, slotsize, avail/3);
    +avail = clamp_t(int, avail, slotsize, total_avail/3);

Here are the macros.

    #define min_t(type, x, y)       __careful_cmp((type)(x), (type)(y), <)
    #define clamp_t(type, val, lo, hi) min_t(type, max_t(type, val, lo), hi)

`total_avail` is 8,434,659,328 on the 1 TB machine. `clamp_t()` casts
the values to `int`, which for 32-bit integers can only hold values
−2,147,483,648 (−2^31) through 2,147,483,647 (2^31 − 1).

`avail` (in the function signature) is just 65536, so that no overflow
was happening. Before the commit the assignment would result in 21845,
and `num = 4`.

When using `total_avail`, it is causing the assignment to be
18446744072226137429 (printed as %lu), and `num` is then 4164608182.

My next guess is, that `nfsd_drc_mem_used` is then exceeded, and the
server thinks there is no memory available any more for this client.

Updating the arguments of `clamp_t()` and `min_t()` to `unsigned long`
fixes the issue.

Now, `avail = 65536` (before commit 10a68cdf10 `avail = 21845`), but
`num = 4` remains the same.

Fixes: c54f24e338ed (nfsd: fix performance-limiting session calculation)
Cc: stable@vger.kernel.org
Signed-off-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index c4762d8aa9f8..032fcae3a94f 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -1511,7 +1511,7 @@ static u32 nfsd4_get_drc_mem(struct nfsd4_channel_attrs *ca)
 	 * Never use more than a third of the remaining memory,
 	 * unless it's the only way to give this client a slot:
 	 */
-	avail = clamp_t(int, avail, slotsize, total_avail/3);
+	avail = clamp_t(unsigned long, avail, slotsize, total_avail/3);
 	num = min_t(int, num, avail / slotsize);
 	nfsd_drc_mem_used += num * slotsize;
 	spin_unlock(&nfsd_drc_lock);
-- 
2.20.1



