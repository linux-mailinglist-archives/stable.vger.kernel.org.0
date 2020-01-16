Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93F8C13EE9E
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:11:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393363AbgAPSKE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:10:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:53776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393257AbgAPRiC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:38:02 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16442246E1;
        Thu, 16 Jan 2020 17:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196282;
        bh=7+YWIhcNEOIuEvafzelpdtdaQmB3T7mH9FS6SgZ5Xwc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O/d64gK5v2WKJbgxIaFy1BPXslJbGot4HbTbWNRtotopsZTIOrubWFjQRVLoZUlab
         1ZDP142S+C+CA2qCsz+xeUrTYCXalzagDjQoPaC8oCQyTE4JWgwZVi89OOyqVq+Syy
         UVD7TfYjYKt+G2kOS8qJc7xxnStG5GKPmfLUb88A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        jfs-discussion@lists.sourceforge.net,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 4.9 101/251] jfs: fix bogus variable self-initialization
Date:   Thu, 16 Jan 2020 12:34:10 -0500
Message-Id: <20200116173641.22137-61-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116173641.22137-1-sashal@kernel.org>
References: <20200116173641.22137-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit a5fdd713d256887b5f012608701149fa939e5645 ]

A statement was originally added in 2006 to shut up a gcc warning,
now but now clang warns about it:

fs/jfs/jfs_txnmgr.c:1932:15: error: variable 'pxd' is uninitialized when used within its own initialization
      [-Werror,-Wuninitialized]
                pxd_t pxd = pxd;        /* truncated extent of xad */
                      ~~~   ^~~

Modern versions of gcc are fine without the silly assignment, so just
drop it. Tested with gcc-4.6 (released 2011), 4.7, 4.8, and 4.9.

Fixes: c9e3ad6021e5 ("JFS: Get rid of "may be used uninitialized" warnings")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/jfs_txnmgr.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/jfs/jfs_txnmgr.c b/fs/jfs/jfs_txnmgr.c
index 4d973524c887..224ef034004b 100644
--- a/fs/jfs/jfs_txnmgr.c
+++ b/fs/jfs/jfs_txnmgr.c
@@ -1928,8 +1928,7 @@ static void xtLog(struct jfs_log * log, struct tblock * tblk, struct lrd * lrd,
 	 * header ?
 	 */
 	if (tlck->type & tlckTRUNCATE) {
-		/* This odd declaration suppresses a bogus gcc warning */
-		pxd_t pxd = pxd;	/* truncated extent of xad */
+		pxd_t pxd;	/* truncated extent of xad */
 		int twm;
 
 		/*
-- 
2.20.1

