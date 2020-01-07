Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70C0913318E
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728658AbgAGVBy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:01:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:40242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728264AbgAGVBy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:01:54 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45D2420880;
        Tue,  7 Jan 2020 21:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430913;
        bh=Jg4b2oudpxvcI46wrRdcoGJxfli65coHnOsvvzRkXvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c0kOpzMhW4rAkbh36IIqJdW0yJ3LuowZYyzO4JUlTpDSCbRgSWXaXt1DANuWeFhbj
         mUKgQ3VUIAXukDlTmWlHkoaaCo5IAehC8Rdx5I2CFMiJrRlxmqqfsGNbdcWQWNb4IG
         SeuTianTRJxwwHzM3ilw1D/nyFngUERlAP3FKL+0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Omar Sandoval <osandov@fb.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 5.4 148/191] xfs: dont check for AG deadlock for realtime files in bunmapi
Date:   Tue,  7 Jan 2020 21:54:28 +0100
Message-Id: <20200107205340.891745863@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

commit 69ffe5960df16938bccfe1b65382af0b3de51265 upstream.

Commit 5b094d6dac04 ("xfs: fix multi-AG deadlock in xfs_bunmapi") added
a check in __xfs_bunmapi() to stop early if we would touch multiple AGs
in the wrong order. However, this check isn't applicable for realtime
files. In most cases, it just makes us do unnecessary commits. However,
without the fix from the previous commit ("xfs: fix realtime file data
space leak"), if the last and second-to-last extents also happen to have
different "AG numbers", then the break actually causes __xfs_bunmapi()
to return without making any progress, which sends
xfs_itruncate_extents_flags() into an infinite loop.

Fixes: 5b094d6dac04 ("xfs: fix multi-AG deadlock in xfs_bunmapi")
Signed-off-by: Omar Sandoval <osandov@fb.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/xfs/libxfs/xfs_bmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5300,7 +5300,7 @@ __xfs_bunmapi(
 		 * Make sure we don't touch multiple AGF headers out of order
 		 * in a single transaction, as that could cause AB-BA deadlocks.
 		 */
-		if (!wasdel) {
+		if (!wasdel && !isrt) {
 			agno = XFS_FSB_TO_AGNO(mp, del.br_startblock);
 			if (prev_agno != NULLAGNUMBER && prev_agno > agno)
 				break;


