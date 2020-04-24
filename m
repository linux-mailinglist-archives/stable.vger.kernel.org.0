Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E19FA1B73F1
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 14:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728015AbgDXMXa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 08:23:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:53344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728012AbgDXMXa (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Apr 2020 08:23:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5863521569;
        Fri, 24 Apr 2020 12:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587731009;
        bh=17Z6ur9/JVGYgU+ovwJDkUoJXP5IFKxDcHNAtxzeoZ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KBlyRuCiUynDv20CC259Yv9vAje/kEht69KMZX8HGIKEbqrLW/HlXa3ZYFVOfr6X/
         PdcmNV9baHoGyYIjI58+8WX0rNKu23vhTv9CEAFxiN0tUghVj34aNNsPh8PNa4Y8K1
         dgPR6LvRW+bz0BlOJCGO3/SQamhNl6RkVz3kxwyI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-afs@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 05/26] afs: Fix length of dump of bad YFSFetchStatus record
Date:   Fri, 24 Apr 2020 08:23:02 -0400
Message-Id: <20200424122323.10194-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200424122323.10194-1-sashal@kernel.org>
References: <20200424122323.10194-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 3efe55b09a92a59ed8214db801683cf13c9742c4 ]

Fix the length of the dump of a bad YFSFetchStatus record.  The function
was copied from the AFS version, but the YFS variant contains bigger fields
and extra information, so expand the dump to match.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/yfsclient.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/afs/yfsclient.c b/fs/afs/yfsclient.c
index 31b236c6b1f76..39230880f372b 100644
--- a/fs/afs/yfsclient.c
+++ b/fs/afs/yfsclient.c
@@ -165,15 +165,15 @@ static void xdr_dump_bad(const __be32 *bp)
 	int i;
 
 	pr_notice("YFS XDR: Bad status record\n");
-	for (i = 0; i < 5 * 4 * 4; i += 16) {
+	for (i = 0; i < 6 * 4 * 4; i += 16) {
 		memcpy(x, bp, 16);
 		bp += 4;
 		pr_notice("%03x: %08x %08x %08x %08x\n",
 			  i, ntohl(x[0]), ntohl(x[1]), ntohl(x[2]), ntohl(x[3]));
 	}
 
-	memcpy(x, bp, 4);
-	pr_notice("0x50: %08x\n", ntohl(x[0]));
+	memcpy(x, bp, 8);
+	pr_notice("0x60: %08x %08x\n", ntohl(x[0]), ntohl(x[1]));
 }
 
 /*
-- 
2.20.1

