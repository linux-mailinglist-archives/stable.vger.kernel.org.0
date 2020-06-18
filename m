Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7D41FE647
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729144AbgFRCcj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:32:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:45116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729441AbgFRBPI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:15:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C6B221D7B;
        Thu, 18 Jun 2020 01:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442908;
        bh=5U5PiWIjiwW7vjikoQHtJKRjG+IOR2gWNoMdCr8MBEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vDDK0HyOhVc5PIBzQ73MG2Yf0bLEfSxGT14ps3D3E9jrbx+K9xO+j19Z9Q93YCkv7
         iEAc8ctOnvqU2SOW4FaGQs2w8pO3z6ZmupJyteIe7TgCnq6TqH6qSQLlmGqDB1iUPS
         ENXVNvgFp6/mR2nfCZRU1Tzm8temhYxuqSjD672Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "J. Bruce Fields" <bfields@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 327/388] nfsd: safer handling of corrupted c_type
Date:   Wed, 17 Jun 2020 21:07:04 -0400
Message-Id: <20200618010805.600873-327-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "J. Bruce Fields" <bfields@redhat.com>

[ Upstream commit c25bf185e57213b54ea0d632ac04907310993433 ]

This can only happen if there's a bug somewhere, so let's make it a WARN
not a printk.  Also, I think it's safest to ignore the corruption rather
than trying to fix it by removing a cache entry.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfscache.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/nfsd/nfscache.c b/fs/nfsd/nfscache.c
index 0c10bfea039e..4a258065188e 100644
--- a/fs/nfsd/nfscache.c
+++ b/fs/nfsd/nfscache.c
@@ -469,8 +469,7 @@ nfsd_cache_lookup(struct svc_rqst *rqstp)
 		rtn = RC_REPLY;
 		break;
 	default:
-		printk(KERN_WARNING "nfsd: bad repcache type %d\n", rp->c_type);
-		nfsd_reply_cache_free_locked(b, rp, nn);
+		WARN_ONCE(1, "nfsd: bad repcache type %d\n", rp->c_type);
 	}
 
 	goto out;
-- 
2.25.1

