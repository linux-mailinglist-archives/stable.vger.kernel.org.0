Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C95F133B8BB
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:06:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234561AbhCOOEU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:04:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:37632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233084AbhCOOAh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:00:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B57664EFC;
        Mon, 15 Mar 2021 14:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816823;
        bh=G54vohvt+g5VieYybML1LGzxlSiZ1Tb+gpNzAx1aXvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uUPehyKPCaVSvoHh3GMUFO7sWT2JHXbp5mmKJw0dvrHS+wO/Ygdri7aPVJjXP/CvD
         0726FOmLqPkxE6iW7Larwg00SCBjWweDtxV0fTNAdw9b/k/cdkp+iNl/k8CSsJgncA
         7lGrPIROMVhTcqGsxT9tUkDC6t52u1l4TeOsaJa0=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Steven J. Magnani" <magnani@ieee.org>,
        Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 134/290] udf: fix silent AED tagLocation corruption
Date:   Mon, 15 Mar 2021 14:53:47 +0100
Message-Id: <20210315135546.437045564@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
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



