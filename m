Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC59B29BCDA
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:41:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1811117AbgJ0QhW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:37:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:40476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801845AbgJ0Pob (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:44:31 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CA112242F;
        Tue, 27 Oct 2020 15:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813441;
        bh=qoRhQuQEV4CKlz3qaWNl7/xqZX+AF2ooIstYglQn92E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mum6oHCFGahzmaJLcT0qKSFZLJZEUzxPPmvzjlCNuNxfGWgvIfb1U4LCfSAmU57+o
         cPt7D4Q0zDdBRR6pr4Zkjv1eFWUJ0vGOAy/8BwUWbK7zPFIq9Qkc8niYzJ7vaUTg+A
         M2CoqVFNRUebE3TfLdLoTRsn+mrVk4mnd0xsdkv8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 553/757] ext4: limit entries returned when counting fsmap records
Date:   Tue, 27 Oct 2020 14:53:23 +0100
Message-Id: <20201027135516.435502150@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

[ Upstream commit af8c53c8bc087459b1aadd4c94805d8272358d79 ]

If userspace asked fsmap to try to count the number of entries, we cannot
return more than UINT_MAX entries because fmh_entries is u32.
Therefore, stop counting if we hit this limit or else we will waste time
to return truncated results.

Fixes: 0c9ec4beecac ("ext4: support GETFSMAP ioctls")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Link: https://lore.kernel.org/r/20201001222148.GA49520@magnolia
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/fsmap.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ext4/fsmap.c b/fs/ext4/fsmap.c
index dbccf46f17709..37347ba868b70 100644
--- a/fs/ext4/fsmap.c
+++ b/fs/ext4/fsmap.c
@@ -108,6 +108,9 @@ static int ext4_getfsmap_helper(struct super_block *sb,
 
 	/* Are we just counting mappings? */
 	if (info->gfi_head->fmh_count == 0) {
+		if (info->gfi_head->fmh_entries == UINT_MAX)
+			return EXT4_QUERY_RANGE_ABORT;
+
 		if (rec_fsblk > info->gfi_next_fsblk)
 			info->gfi_head->fmh_entries++;
 
-- 
2.25.1



