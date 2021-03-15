Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6006E33B797
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:01:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232795AbhCOOAs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:00:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:34900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232664AbhCON71 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:59:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A4E3B64EF3;
        Mon, 15 Mar 2021 13:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816743;
        bh=SFbf1cAXb28Jkh91bhM6Fp6dX9YLIV9CBTgWSUyxwy8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bkf3CiwHYX4wW8mS7gNoVxgv4HvY24PMrtLJQtMPG72pT7r3Z2arTs/JSpQm+iKjp
         gTFneKlPjY31kwAKbPYelegnFAH9f5A+CuW2LKN4rjCgJUyMlqwZ85ltFRxl6bdFWZ
         kRs70S/O1BYqRCi7ESARNW+jYrCLrihxYo9KbqP8=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Steven J. Magnani" <magnani@ieee.org>,
        Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 32/95] udf: fix silent AED tagLocation corruption
Date:   Mon, 15 Mar 2021 14:57:02 +0100
Message-Id: <20210315135741.330948404@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135740.245494252@linuxfoundation.org>
References: <20210315135740.245494252@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Steven J. Magnani <magnani@ieee.org>

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
index dd57bd446340..e0e2bc19c929 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -540,11 +540,14 @@ static int udf_do_extend_file(struct inode *inode,
 
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



