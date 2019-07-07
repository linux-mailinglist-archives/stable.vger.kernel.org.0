Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01DD76169B
	for <lists+stable@lfdr.de>; Sun,  7 Jul 2019 21:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727756AbfGGTlL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jul 2019 15:41:11 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57874 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727651AbfGGTiP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jul 2019 15:38:15 -0400
Received: from 94.197.121.43.threembb.co.uk ([94.197.121.43] helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCzC-0006jU-Mg; Sun, 07 Jul 2019 20:38:10 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz8-0005fa-Oa; Sun, 07 Jul 2019 20:38:06 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Xiao Ni" <xni@redhat.com>, "Song Liu" <songliubraving@fb.com>
Date:   Sun, 07 Jul 2019 17:54:17 +0100
Message-ID: <lsq.1562518457.332065955@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 114/129] It's wrong to add len to sector_nr in raid10
 reshape twice
In-Reply-To: <lsq.1562518456.876074874@decadent.org.uk>
X-SA-Exim-Connect-IP: 94.197.121.43
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.70-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Xiao Ni <xni@redhat.com>

commit b761dcf1217760a42f7897c31dcb649f59b2333e upstream.

In reshape_request it already adds len to sector_nr already. It's wrong to add len to
sector_nr again after adding pages to bio. If there is bad block it can't copy one chunk
at a time, it needs to goto read_more. Now the sector_nr is wrong. It can cause data
corruption.

Signed-off-by: Xiao Ni <xni@redhat.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/md/raid10.c | 1 -
 1 file changed, 1 deletion(-)

--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4506,7 +4506,6 @@ bio_full:
 	atomic_inc(&r10_bio->remaining);
 	read_bio->bi_next = NULL;
 	generic_make_request(read_bio);
-	sector_nr += nr_sectors;
 	sectors_done += nr_sectors;
 	if (sector_nr <= last)
 		goto read_more;

