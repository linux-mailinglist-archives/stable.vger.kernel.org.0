Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29E72157C43
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:36:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbgBJNgJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:36:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:51458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727788AbgBJMfO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:35:14 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8F30215A4;
        Mon, 10 Feb 2020 12:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338113;
        bh=j+HWRVEt/+j597D3pKf3o4tRQ6QKMvOyHvkGg8bdgpI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tfSuwr9skLqBOiYcEVPe7393OgSEorz0ZGBlRb1kvhOazNNCCZ3s7TVxP9SqpUPXx
         DC/K5qdgwZHdofDHfyHxXQ70bO/+r/4cGY4U2XsIIlHmtYP3PsN+oUmQ06E57fPtS0
         xIfHEC09mozJdI+ASIjAVPfMd+pK91Cjgl9DiXEg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 007/195] udf: Allow writing to Rewritable partitions
Date:   Mon, 10 Feb 2020 04:31:05 -0800
Message-Id: <20200210122306.502163440@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122305.731206734@linuxfoundation.org>
References: <20200210122305.731206734@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 7af011dc9ae8a..6fd0f14e9dd22 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -999,7 +999,6 @@ static int check_partition_desc(struct super_block *sb,
 	switch (le32_to_cpu(p->accessType)) {
 	case PD_ACCESS_TYPE_READ_ONLY:
 	case PD_ACCESS_TYPE_WRITE_ONCE:
-	case PD_ACCESS_TYPE_REWRITABLE:
 	case PD_ACCESS_TYPE_NONE:
 		goto force_ro;
 	}
-- 
2.20.1



