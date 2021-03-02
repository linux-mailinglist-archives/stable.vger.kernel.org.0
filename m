Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CEDB32AF07
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:14:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231325AbhCCAOg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:14:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:40132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237334AbhCBL7I (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 06:59:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 962CC64F19;
        Tue,  2 Mar 2021 11:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686146;
        bh=Wxn8Bvnolw8MgzDPl7y+OEVkXz02zvxeI6P2SoHE9O8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M2Qd2g6Ma3DctPPJwcRXu5k896GYW7TZP5nt1XAHr5gxURNctuEcMfTp3Qj5NiKPe
         576dSMbYlGytMg+5sp2MF3CHgS0EGuxOydtmYyi494JARVy/RYT+9EWZoqIdSqQtkw
         1UmfQYGAeNX9dl6b76bs3G5Foum5DygxkQFTmaP6imK6R5u8gwBZhIfYdB5kaihm11
         vM9G40eDV8FcKn3a61NuV9GqGwZTK5RSmnPBgL1FMSOkubi04bP/aAw6pkwPNcfPYq
         oYiOSmpUsSdyBNJULsAOzCZYqk1XwoUJf5HusUo17FnaAQ1RutfvG1gfQBQkNw6lng
         wtSpGyfTfC3yg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Steven J. Magnani" <magnani@ieee.org>, Jan Kara <jack@suse.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.11 08/52] udf: fix silent AED tagLocation corruption
Date:   Tue,  2 Mar 2021 06:54:49 -0500
Message-Id: <20210302115534.61800-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115534.61800-1-sashal@kernel.org>
References: <20210302115534.61800-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven J. Magnani" <magnani@ieee.org>

[ Upstream commit 63c9e47a1642fc817654a1bc18a6ec4bbcc0f056 ]

When extending a file, udf_do_extend_file() may enter following empty
indirect extent. At the end of udf_do_extend_file() we revert prev_epos
to point to the last written extent. However if we end up not adding any
further extent in udf_do_extend_file(), the reverting points prev_epos
into the header area of the AED and following updates of the extents
(in udf_update_extents()) will corrupt the header.

Make sure that we do not follow indirect extent if we are not going to
add any more extents so that returning back to the last written extent
works correctly.

Link: https://lore.kernel.org/r/20210107234116.6190-2-magnani@ieee.org
Signed-off-by: Steven J. Magnani <magnani@ieee.org>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/inode.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index bb89c3e43212..0dd2f93ac048 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -544,11 +544,14 @@ static int udf_do_extend_file(struct inode *inode,
 
 		udf_write_aext(inode, last_pos, &last_ext->extLocation,
 				last_ext->extLength, 1);
+
 		/*
-		 * We've rewritten the last extent but there may be empty
-		 * indirect extent after it - enter it.
+		 * We've rewritten the last extent. If we are going to add
+		 * more extents, we may need to enter possible following
+		 * empty indirect extent.
 		 */
-		udf_next_aext(inode, last_pos, &tmploc, &tmplen, 0);
+		if (new_block_bytes || prealloc_len)
+			udf_next_aext(inode, last_pos, &tmploc, &tmplen, 0);
 	}
 
 	/* Managed to do everything necessary? */
-- 
2.30.1

