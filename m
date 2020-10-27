Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A86FF29C655
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 19:27:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1756248AbgJ0SQF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 14:16:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:33246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756236AbgJ0OMJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:12:09 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FD882072D;
        Tue, 27 Oct 2020 14:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807929;
        bh=JNX1b1s1S8/slQjwsPJ324lvjzzJASKZch41UK6bUss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f6AwSWZ6+aGw4ogLiB4noR134+LYtaUIJnGzAgCk/NVkxWC7iTS3V+6Rt2CKb4SmL
         Epoayvlj/dN6RsoSL9iBfAqUWeYb6cz31Z/WGgv8MBUVwB7OfBwZZTq5cYKB+E9hAV
         8ylRwt4u7AYwLuPgTR+94bTXGlWCOekmKnqygjiY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 093/191] xfs: limit entries returned when counting fsmap records
Date:   Tue, 27 Oct 2020 14:49:08 +0100
Message-Id: <20201027134914.166848771@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134909.701581493@linuxfoundation.org>
References: <20201027134909.701581493@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

[ Upstream commit acd1ac3aa22fd58803a12d26b1ab7f70232f8d8d ]

If userspace asked fsmap to count the number of entries, we cannot
return more than UINT_MAX entries because fmh_entries is u32.
Therefore, stop counting if we hit this limit or else we will waste time
to return truncated results.

Fixes: e89c041338ed ("xfs: implement the GETFSMAP ioctl")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_fsmap.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 43cfc07996a43..e7622e0841868 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -273,6 +273,9 @@ xfs_getfsmap_helper(
 
 	/* Are we just counting mappings? */
 	if (info->head->fmh_count == 0) {
+		if (info->head->fmh_entries == UINT_MAX)
+			return -ECANCELED;
+
 		if (rec_daddr > info->next_daddr)
 			info->head->fmh_entries++;
 
-- 
2.25.1



