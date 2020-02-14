Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7DB15EEA7
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:42:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729434AbgBNRl5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:41:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:50846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389676AbgBNQDe (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:03:34 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5926D24654;
        Fri, 14 Feb 2020 16:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696214;
        bh=idBDqzu2y3o0QPiMY39TEUWKHEZlHWZnr1qSgzMQ1lU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kzgfARh9ccFGwWzx7PNoV7jB5ZU6G0bAmvTM1rdWu2XrhSzUeuEpw1+wCRFSi1boi
         jcGc2jldHCyTqsT9r7RccK2+eVklJAU+bUWiFDDe4FGfpsGAt6a8tjGMRjfOm4rz+g
         gOE784GkQ28DTPEXNvaon+U/pEwDsW66HB9oaFUA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jan Kara <jack@suse.cz>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 078/459] udf: Allow writing to 'Rewritable' partitions
Date:   Fri, 14 Feb 2020 10:55:28 -0500
Message-Id: <20200214160149.11681-78-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

[ Upstream commit 15fb05fd286ac57a0802d71624daeb5c1c2d5b07 ]

UDF 2.60 standard states in section 2.2.14.2:

    A partition with Access Type 3 (rewritable) shall define a Freed
    Space Bitmap or a Freed Space Table, see 2.3.3. All other partitions
    shall not define a Freed Space Bitmap or a Freed Space Table.

    Rewritable partitions are used on media that require some form of
    preprocessing before re-writing data (for example legacy MO). Such
    partitions shall use Access Type 3.

    Overwritable partitions are used on media that do not require
    preprocessing before overwriting data (for example: CD-RW, DVD-RW,
    DVD+RW, DVD-RAM, BD-RE, HD DVD-Rewritable). Such partitions shall
    use Access Type 4.

however older versions of the standard didn't have this wording and
there are tools out there that create UDF filesystems with rewritable
partitions but that don't contain a Freed Space Bitmap or a Freed Space
Table on media that does not require pre-processing before overwriting a
block. So instead of forcing media with rewritable partition read-only,
base this decision on presence of a Freed Space Bitmap or a Freed Space
Table.

Reported-by: Pali Rohár <pali.rohar@gmail.com>
Reviewed-by: Pali Rohár <pali.rohar@gmail.com>
Fixes: b085fbe2ef7f ("udf: Fix crash during mount")
Link: https://lore.kernel.org/linux-fsdevel/20200112144735.hj2emsoy4uwsouxz@pali
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/super.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index 8c28e93e9b730..008bf96b1732d 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1035,7 +1035,6 @@ static int check_partition_desc(struct super_block *sb,
 	switch (le32_to_cpu(p->accessType)) {
 	case PD_ACCESS_TYPE_READ_ONLY:
 	case PD_ACCESS_TYPE_WRITE_ONCE:
-	case PD_ACCESS_TYPE_REWRITABLE:
 	case PD_ACCESS_TYPE_NONE:
 		goto force_ro;
 	}
-- 
2.20.1

