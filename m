Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E47AA32E9DC
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbhCEMfE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:35:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:46426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232416AbhCEMeq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:34:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 08E0165012;
        Fri,  5 Mar 2021 12:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947686;
        bh=ncUlp5/Ewe/nJo/evmWUyWBBqbmFOCyhlo53JqmdYxQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PDYrzOvz+Lf6AhXmHL5lDON51yryukSEPkJjK6xHfPtv1xJQG0Mh8nCMbQ0WpB3IZ
         8Z5GdzsPQMvPqPZ7vdfUDDxP62tUZVMT/IQfZ4OdF+WydPG9gRWnrbQpfE4GDUoZrc
         dskt/wJKJJQQ60KOtOldpMQotHo35mqctpT4QPBg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 47/72] f2fs: handle unallocated section and zone on pinned/atgc
Date:   Fri,  5 Mar 2021 13:21:49 +0100
Message-Id: <20210305120859.641720674@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120857.341630346@linuxfoundation.org>
References: <20210305120857.341630346@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@kernel.org>

[ Upstream commit 632faca72938f9f63049e48a8c438913828ac7a9 ]

If we have large section/zone, unallocated segment makes them corrupted.

E.g.,

  - Pinned file:       -1 119304647 119304647
  - ATGC   data:       -1 119304647 119304647

Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/segment.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index 325781a1ae4d..2034b9a07d63 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -88,11 +88,11 @@
 #define BLKS_PER_SEC(sbi)					\
 	((sbi)->segs_per_sec * (sbi)->blocks_per_seg)
 #define GET_SEC_FROM_SEG(sbi, segno)				\
-	((segno) / (sbi)->segs_per_sec)
+	(((segno) == -1) ? -1: (segno) / (sbi)->segs_per_sec)
 #define GET_SEG_FROM_SEC(sbi, secno)				\
 	((secno) * (sbi)->segs_per_sec)
 #define GET_ZONE_FROM_SEC(sbi, secno)				\
-	((secno) / (sbi)->secs_per_zone)
+	(((secno) == -1) ? -1: (secno) / (sbi)->secs_per_zone)
 #define GET_ZONE_FROM_SEG(sbi, segno)				\
 	GET_ZONE_FROM_SEC(sbi, GET_SEC_FROM_SEG(sbi, segno))
 
-- 
2.30.1



