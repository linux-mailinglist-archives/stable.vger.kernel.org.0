Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0342829C3FC
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:51:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2901477AbgJ0Rvw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:51:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:48864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2901450AbgJ0OXu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:23:50 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 717FA20773;
        Tue, 27 Oct 2020 14:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808630;
        bh=js8BAC5Wj1AlTmDOoQZXXqIX0aIzcIBPGfsh+aWzhRQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wEUZMzMAKMOVtm9IBBSWy55qbWbhnCMrSrtst9J4vllAOgOsS+8v6bQM5aObfQzBS
         IndSD8ooE0wKlsFQfjuTqq+UlE9mFU/MF8brpnzzbzbNI51l7Fzpkp3anfVohN2a2W
         tJ6diGXkykqIPJvmJkRzu84cGX6OGPDq6Sj9et4o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Souptick Joarder <jrdr.linux@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ira Weiny <ira.weiny@intel.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Matthew Wilcox <willy@infradead.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        Alexandre Bounine <alex.bou9@gmail.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 164/264] rapidio: fix error handling path
Date:   Tue, 27 Oct 2020 14:53:42 +0100
Message-Id: <20201027135438.385205564@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Souptick Joarder <jrdr.linux@gmail.com>

[ Upstream commit fa63f083b3492b5ed5332b8d7c90b03b5ef24a1d ]

rio_dma_transfer() attempts to clamp the return value of
pin_user_pages_fast() to be >= 0.  However, the attempt fails because
nr_pages is overridden a few lines later, and restored to the undesirable
-ERRNO value.

The return value is ultimately stored in nr_pages, which in turn is passed
to unpin_user_pages(), which expects nr_pages >= 0, else, disaster.

Fix this by fixing the nesting of the assignment to nr_pages: nr_pages
should be clamped to zero if pin_user_pages_fast() returns -ERRNO, or set
to the return value of pin_user_pages_fast(), otherwise.

[jhubbard@nvidia.com: new changelog]

Fixes: e8de370188d09 ("rapidio: add mport char device driver")
Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Gustavo A. R. Silva <gustavoars@kernel.org>
Cc: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lkml.kernel.org/r/1600227737-20785-1-git-send-email-jrdr.linux@gmail.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rapidio/devices/rio_mport_cdev.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/rapidio/devices/rio_mport_cdev.c b/drivers/rapidio/devices/rio_mport_cdev.c
index f36a8a5261a13..c3ca1cf0e1bb7 100644
--- a/drivers/rapidio/devices/rio_mport_cdev.c
+++ b/drivers/rapidio/devices/rio_mport_cdev.c
@@ -875,15 +875,16 @@ rio_dma_transfer(struct file *filp, u32 transfer_mode,
 				rmcd_error("get_user_pages_unlocked err=%ld",
 					   pinned);
 				nr_pages = 0;
-			} else
+			} else {
 				rmcd_error("pinned %ld out of %ld pages",
 					   pinned, nr_pages);
+				/*
+				 * Set nr_pages up to mean "how many pages to unpin, in
+				 * the error handler:
+				 */
+				nr_pages = pinned;
+			}
 			ret = -EFAULT;
-			/*
-			 * Set nr_pages up to mean "how many pages to unpin, in
-			 * the error handler:
-			 */
-			nr_pages = pinned;
 			goto err_pg;
 		}
 
-- 
2.25.1



