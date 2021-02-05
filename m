Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67A8331143D
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 23:06:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232923AbhBEWCM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 17:02:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:44630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232839AbhBEOyd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 09:54:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 27C5C64F38;
        Fri,  5 Feb 2021 14:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534236;
        bh=Q4OvAdboO6WGJc4QftulHDtVha3jGqAblQWnE4WApzM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iP4XwZ8PkMuiA9oXlZlKLFm+PJrGWSIv10a4NAZtyadmU9dirvvC4KiXLqGNCOweC
         h3QuyewpaaaCvfEoDTknrGG9cMTvU+5JDzkOdp8RYrxXOA0XmZT+BgoPNOuBa3+02G
         iFTFkgUPWG6RlEMR9duFJ9w68gjBHNPrX06T40RQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, lianzhi chang <changlianzhi@uniontech.com>,
        Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 38/57] udf: fix the problem that the disc content is not displayed
Date:   Fri,  5 Feb 2021 15:07:04 +0100
Message-Id: <20210205140657.604397857@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140655.982616732@linuxfoundation.org>
References: <20210205140655.982616732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: lianzhi chang <changlianzhi@uniontech.com>

[ Upstream commit 5cdc4a6950a883594e9640b1decb3fcf6222a594 ]

When the capacity of the disc is too large (assuming the 4.7G
specification), the disc (UDF file system) will be burned
multiple times in the windows (Multisession Usage). When the
remaining capacity of the CD is less than 300M (estimated
value, for reference only), open the CD in the Linux system,
the content of the CD is displayed as blank (the kernel will
say "No VRS found"). Windows can display the contents of the
CD normally.
Through analysis, in the "fs/udf/super.c": udf_check_vsd
function, the actual value of VSD_MAX_SECTOR_OFFSET may
be much larger than 0x800000. According to the current code
logic, it is found that the type of sbi->s_session is "__s32",
 when the remaining capacity of the disc is less than 300M
(take a set of test values: sector=3154903040,
sbi->s_session=1540464, sb->s_blocksize_bits=11 ), the
calculation result of "sbi->s_session << sb->s_blocksize_bits"
 will overflow. Therefore, it is necessary to convert the
type of s_session to "loff_t" (when udf_check_vsd starts,
assign a value to _sector, which is also converted in this
way), so that the result will not overflow, and then the
content of the disc can be displayed normally.

Link: https://lore.kernel.org/r/20210114075741.30448-1-changlianzhi@uniontech.com
Signed-off-by: lianzhi chang <changlianzhi@uniontech.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/super.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index 5bef3a68395d8..d0df217f4712a 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -705,6 +705,7 @@ static int udf_check_vsd(struct super_block *sb)
 	struct buffer_head *bh = NULL;
 	int nsr = 0;
 	struct udf_sb_info *sbi;
+	loff_t session_offset;
 
 	sbi = UDF_SB(sb);
 	if (sb->s_blocksize < sizeof(struct volStructDesc))
@@ -712,7 +713,8 @@ static int udf_check_vsd(struct super_block *sb)
 	else
 		sectorsize = sb->s_blocksize;
 
-	sector += (((loff_t)sbi->s_session) << sb->s_blocksize_bits);
+	session_offset = (loff_t)sbi->s_session << sb->s_blocksize_bits;
+	sector += session_offset;
 
 	udf_debug("Starting at sector %u (%lu byte sectors)\n",
 		  (unsigned int)(sector >> sb->s_blocksize_bits),
@@ -757,8 +759,7 @@ static int udf_check_vsd(struct super_block *sb)
 
 	if (nsr > 0)
 		return 1;
-	else if (!bh && sector - (sbi->s_session << sb->s_blocksize_bits) ==
-			VSD_FIRST_SECTOR_OFFSET)
+	else if (!bh && sector - session_offset == VSD_FIRST_SECTOR_OFFSET)
 		return -1;
 	else
 		return 0;
-- 
2.27.0



