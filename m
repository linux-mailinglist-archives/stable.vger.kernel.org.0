Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F36B640E61F
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346404AbhIPRSJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:18:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:39808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243467AbhIPRP6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:15:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E5AE61B97;
        Thu, 16 Sep 2021 16:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810390;
        bh=fpu0kwbRNeA7FwCJ1kfquK8yT26beo2T44htSi7SdpI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o/sC2YJXJCuc+5h1iqfFpXP60MsLqQindvhFu+WKihdBc7dyCUvp+lkg0FjGTPkVi
         fm+Bf3t7KR6s3J/hpNdQDHcdjvZoiP9wos/sQ+FEGKsdg3VBvB2QHz8YJFNhdngXD7
         1aKDEeOiOLngX3xGBQRMBB9TH7CA9B4AbgMo+YGU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <chao@kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 122/432] f2fs: fix to keep compatibility of fault injection interface
Date:   Thu, 16 Sep 2021 17:57:51 +0200
Message-Id: <20210916155814.895796699@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <chao@kernel.org>

[ Upstream commit b96d9b3b09f0427b289332c6f6bfbf747a19b654 ]

The value of FAULT_* macros and its description in f2fs.rst became
inconsistent, fix this to keep compatibility of fault injection
interface.

Fixes: 67883ade7a98 ("f2fs: remove FAULT_ALLOC_BIO")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/filesystems/f2fs.rst | 1 +
 fs/f2fs/f2fs.h                     | 1 +
 2 files changed, 2 insertions(+)

diff --git a/Documentation/filesystems/f2fs.rst b/Documentation/filesystems/f2fs.rst
index ff9e7cc97c65..b5285599d972 100644
--- a/Documentation/filesystems/f2fs.rst
+++ b/Documentation/filesystems/f2fs.rst
@@ -185,6 +185,7 @@ fault_type=%d		 Support configuring fault injection type, should be
 			 FAULT_KVMALLOC		  0x000000002
 			 FAULT_PAGE_ALLOC	  0x000000004
 			 FAULT_PAGE_GET		  0x000000008
+			 FAULT_ALLOC_BIO	  0x000000010 (obsolete)
 			 FAULT_ALLOC_NID	  0x000000020
 			 FAULT_ORPHAN		  0x000000040
 			 FAULT_BLOCK		  0x000000080
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index bfcd5ef36907..db95829904e5 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -43,6 +43,7 @@ enum {
 	FAULT_KVMALLOC,
 	FAULT_PAGE_ALLOC,
 	FAULT_PAGE_GET,
+	FAULT_ALLOC_BIO,	/* it's obsolete due to bio_alloc() will never fail */
 	FAULT_ALLOC_NID,
 	FAULT_ORPHAN,
 	FAULT_BLOCK,
-- 
2.30.2



