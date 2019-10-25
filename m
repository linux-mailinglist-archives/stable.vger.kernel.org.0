Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41E99E530B
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 20:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731701AbfJYSG6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 14:06:58 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46802 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731441AbfJYSFo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Oct 2019 14:05:44 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iO3xx-0008PB-2v; Fri, 25 Oct 2019 19:05:37 +0100
Received: from ben by deadeye with local (Exim 4.92.2)
        (envelope-from <ben@decadent.org.uk>)
        id 1iO3xw-0001kE-7O; Fri, 25 Oct 2019 19:05:36 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Christophe Leroy" <christophe.leroy@c-s.fr>,
        "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Fri, 25 Oct 2019 19:03:35 +0100
Message-ID: <lsq.1572026582.623399615@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 34/47] lib/scatterlist: Fix mapping iterator when
 sg->offset is greater than PAGE_SIZE
In-Reply-To: <lsq.1572026581.992411028@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.76-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe Leroy <christophe.leroy@c-s.fr>

commit aeb87246537a83c2aff482f3f34a2e0991e02cbc upstream.

All mapping iterator logic is based on the assumption that sg->offset
is always lower than PAGE_SIZE.

But there are situations where sg->offset is such that the SG item
is on the second page. In that case sg_copy_to_buffer() fails
properly copying the data into the buffer. One of the reason is
that the data will be outside the kmapped area used to access that
data.

This patch fixes the issue by adjusting the mapping iterator
offset and pgoffset fields such that offset is always lower than
PAGE_SIZE.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Fixes: 4225fc8555a9 ("lib/scatterlist: use page iterator in the mapping iterator")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 lib/scatterlist.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -459,17 +459,18 @@ static bool sg_miter_get_next_page(struc
 {
 	if (!miter->__remaining) {
 		struct scatterlist *sg;
-		unsigned long pgoffset;
 
 		if (!__sg_page_iter_next(&miter->piter))
 			return false;
 
 		sg = miter->piter.sg;
-		pgoffset = miter->piter.sg_pgoffset;
 
-		miter->__offset = pgoffset ? 0 : sg->offset;
+		miter->__offset = miter->piter.sg_pgoffset ? 0 : sg->offset;
+		miter->piter.sg_pgoffset += miter->__offset >> PAGE_SHIFT;
+		miter->__offset &= PAGE_SIZE - 1;
 		miter->__remaining = sg->offset + sg->length -
-				(pgoffset << PAGE_SHIFT) - miter->__offset;
+				     (miter->piter.sg_pgoffset << PAGE_SHIFT) -
+				     miter->__offset;
 		miter->__remaining = min_t(unsigned long, miter->__remaining,
 					   PAGE_SIZE - miter->__offset);
 	}

