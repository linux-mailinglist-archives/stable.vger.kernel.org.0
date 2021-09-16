Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40DF640E2C1
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244162AbhIPQl1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:41:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:51356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244523AbhIPQjP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:39:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1745961414;
        Thu, 16 Sep 2021 16:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809385;
        bh=/OGP/yAmYACff1XTpF9TAvEyyXaIy5z49YGbG8LHycA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RlI5HUAV3cZdf3kbb/754iQUKcJpvTmypH6sFp7G5i95rREWQZYFyvYzKzpP60+up
         +/a6F5fnYybPC/PoFt04Kmi/XVUQgsRE1QdsKSvFaW82CJU4d01Dv6FNz2VhfTSJSZ
         fBKwlEb1nlG2UfslcHmESpylpLqpGQHxNBRPy5Lo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <chao@kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 108/380] f2fs: fix to keep compatibility of fault injection interface
Date:   Thu, 16 Sep 2021 17:57:45 +0200
Message-Id: <20210916155807.711982481@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
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
index b91e5a8444d5..7f52d9079d76 100644
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
index 7084b42a4437..395f18e90a8f 100644
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



