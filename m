Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 834C588D81
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbfHJUql (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:46:41 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55296 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726893AbfHJUoH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:44:07 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDb-00058O-VO; Sat, 10 Aug 2019 21:44:04 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDL-0003dg-GN; Sat, 10 Aug 2019 21:43:47 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        linux-block@vger.kernel.org,
        "=?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?=" <jglisse@redhat.com>,
        "Jens Axboe" <axboe@kernel.dk>,
        "Chaitanya Kulkarni" <chaitanya.kulkarni@wdc.com>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.283676874@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 078/157] block: do not leak memory in bio_copy_user_iov()
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jérôme Glisse <jglisse@redhat.com>

commit a3761c3c91209b58b6f33bf69dd8bb8ec0c9d925 upstream.

When bio_add_pc_page() fails in bio_copy_user_iov() we should free
the page we just allocated otherwise we are leaking it.

Cc: linux-block@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 block/bio.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/block/bio.c
+++ b/block/bio.c
@@ -1216,8 +1216,11 @@ struct bio *bio_copy_user_iov(struct req
 			}
 		}
 
-		if (bio_add_pc_page(q, bio, page, bytes, offset) < bytes)
+		if (bio_add_pc_page(q, bio, page, bytes, offset) < bytes) {
+			if (!map_data)
+				__free_page(page);
 			break;
+		}
 
 		len -= bytes;
 		offset = 0;

