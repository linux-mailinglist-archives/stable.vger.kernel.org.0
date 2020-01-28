Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B40C514B7F0
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:20:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730358AbgA1OTB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:19:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:43234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730787AbgA1OTA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:19:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BCC32071E;
        Tue, 28 Jan 2020 14:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221139;
        bh=bxsM9wkTKbbaw5X9lfoDF/LZA8vY4wzEaVce2Y8TZNs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NPcR1Q48mmKTA1wXyGorJ4pFkEanFnMUxFwmVuOPVJauOyYUcIIwKjDI0jVsDWieg
         vISBK/BE0pht1jdGUPPH8yjTjf/g+WEAv6GubI+g/TwRngz8C7iEfpinrTqWi3mv63
         +IZPdoMG9sT2Ic95/97gGxrOR1w+npaCFhutY5r8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 103/271] jfs: fix bogus variable self-initialization
Date:   Tue, 28 Jan 2020 15:04:12 +0100
Message-Id: <20200128135900.258014976@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 4d973524c8879..224ef034004b7 100644
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



