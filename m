Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99636490DA7
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:04:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242477AbiAQREc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:04:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241852AbiAQRCh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:02:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B12EDC06139D;
        Mon, 17 Jan 2022 09:02:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 511096119F;
        Mon, 17 Jan 2022 17:02:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2512C36AE7;
        Mon, 17 Jan 2022 17:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642438925;
        bh=u56yJa6/B5ipNGduQHjOcZv8irApVmodvGSAzEzLbG8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l2ETjDhsNBrGyy/LEim1RmYFV9oR7rZCGLfOGQ5uxBOoK1TvxqkINtJwAf6Pz2WQE
         /VtJYqKiyc6C7+0SWoR6nLg2q5KqL8prYqMBH+WHVVDpvXGAkjfu3fY92agC+jUR0A
         9lL4KNozLPhxzHN1Odb0J6Yhf+vb8Cc/I4ReoJjsKWmikhaHNEe7FzeZURKDVYfMeZ
         f25odmoWcHUQWjH0sepDpA85Q9I1crZnU2RIRIGAxZCSKCQa3Z4wVM5pSmhx3gsps8
         MMF6K9+jrbiqDKHJKk1TzAGn5PGF8FoFUOoQQBYbZXZd8jhDEggmnjNayEJaCf1Fjh
         dVpxPlNTHHqNA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Sasha Levin <sashal@kernel.org>, agk@redhat.com,
        snitzer@redhat.com, dm-devel@redhat.com
Subject: [PATCH AUTOSEL 5.15 17/44] dm: fix alloc_dax error handling in alloc_dev
Date:   Mon, 17 Jan 2022 12:01:00 -0500
Message-Id: <20220117170127.1471115-17-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117170127.1471115-1-sashal@kernel.org>
References: <20220117170127.1471115-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit d751939235b9b7bc4af15f90a3e99288a8b844a7 ]

Make sure ->dax_dev is NULL on error so that the cleanup path doesn't
trip over an ERR_PTR.

Reported-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20211129102203.2243509-2-hch@lst.de
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 76d9da49fda75..671bb454f1649 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1794,8 +1794,10 @@ static struct mapped_device *alloc_dev(int minor)
 	if (IS_ENABLED(CONFIG_DAX_DRIVER)) {
 		md->dax_dev = alloc_dax(md, md->disk->disk_name,
 					&dm_dax_ops, 0);
-		if (IS_ERR(md->dax_dev))
+		if (IS_ERR(md->dax_dev)) {
+			md->dax_dev = NULL;
 			goto bad;
+		}
 	}
 
 	format_dev_t(md->name, MKDEV(_major, minor));
-- 
2.34.1

