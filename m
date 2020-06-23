Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D523B2063F6
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390340AbgFWVNo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:13:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:50552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390333AbgFWUaR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:30:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E77A62070E;
        Tue, 23 Jun 2020 20:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944217;
        bh=58BjIi//UUzgUCcWBw6C1zUX/jPjqYckyPctRZQbmuo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JCbpw7PlFVBbDpymCHaLrLRU2aLrVApkL9c9UpSMoz1KmbVDlhKzcLdpG2hU77M5k
         vionBfvuEsnj1mtN4moqKwm8BJBHVmlf751WH4BoEQOhCytCvPDKBn2qdcKH4DuH7U
         lkhOHHido310XPSw/w3XIjcSjVNn+GruCYtgMet0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "J. Bruce Fields" <bfields@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 218/314] nfsd: safer handling of corrupted c_type
Date:   Tue, 23 Jun 2020 21:56:53 +0200
Message-Id: <20200623195349.335690935@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195338.770401005@linuxfoundation.org>
References: <20200623195338.770401005@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: J. Bruce Fields <bfields@redhat.com>

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
index 0c10bfea039eb..4a258065188e1 100644
--- a/fs/nfsd/nfscache.c
+++ b/fs/nfsd/nfscache.c
@@ -469,8 +469,7 @@ found_entry:
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



