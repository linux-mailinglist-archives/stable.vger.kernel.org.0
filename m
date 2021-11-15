Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E52F452090
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:52:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350040AbhKPAzk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:55:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:44602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245719AbhKOTVF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:21:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A4D961AAA;
        Mon, 15 Nov 2021 18:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001605;
        bh=r9Sq2+fDaeiZhcm01+EI3sv9zGPlCwDY8guDarLBoK0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f2d2D/m/f90XwH90kOpQ4s2MyGU9xTN0pV9K+tJchVPVWb6HebkTSScc39c8Zxel1
         zqSfBVjUoi06Xs+IpDRLj0lRbR7LyOs4ia2BnDsOqXfSyuGAYDIxDD9BdqPW12tFWL
         lr0vH00buogUZwyMphSzkfFnh+4cOtRrBoeh8jkg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 253/917] iov_iter: Fix iov_iter_get_pages{,_alloc} page fault return value
Date:   Mon, 15 Nov 2021 17:55:48 +0100
Message-Id: <20211115165437.366144546@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 814a66741b9ffb5e1ba119e368b178edb0b7322d ]

Both iov_iter_get_pages and iov_iter_get_pages_alloc return the number
of bytes of the iovec they could get the pages for.  When they cannot
get any pages, they're supposed to return 0, but when the start of the
iovec isn't page aligned, the calculation goes wrong and they return a
negative value.  Fix both functions.

In addition, change iov_iter_get_pages_alloc to return NULL in that case
to prevent resource leaks.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/iov_iter.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 755c10c5138cd..60b5e6edfbaa7 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -1488,7 +1488,7 @@ ssize_t iov_iter_get_pages(struct iov_iter *i,
 		res = get_user_pages_fast(addr, n,
 				iov_iter_rw(i) != WRITE ?  FOLL_WRITE : 0,
 				pages);
-		if (unlikely(res < 0))
+		if (unlikely(res <= 0))
 			return res;
 		return (res == n ? len : res * PAGE_SIZE) - *start;
 	}
@@ -1612,8 +1612,9 @@ ssize_t iov_iter_get_pages_alloc(struct iov_iter *i,
 			return -ENOMEM;
 		res = get_user_pages_fast(addr, n,
 				iov_iter_rw(i) != WRITE ?  FOLL_WRITE : 0, p);
-		if (unlikely(res < 0)) {
+		if (unlikely(res <= 0)) {
 			kvfree(p);
+			*pages = NULL;
 			return res;
 		}
 		*pages = p;
-- 
2.33.0



