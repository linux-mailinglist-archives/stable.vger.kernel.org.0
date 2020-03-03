Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55626177F82
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:58:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731649AbgCCRvR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:51:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:59234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729788AbgCCRvO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:51:14 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A791820728;
        Tue,  3 Mar 2020 17:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583257873;
        bh=emN2YqhmaWQTC1ham4gaISlsVWsP0a+LgTJnYCtT0ks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aTBl6YTYhU3U9w4RfxcsDOO7IiQa2D2CbVSMl5t3Yc9nk1Tr0lqMY7j+t/ll3qKjR
         njANXWCk2ub1ca3HlC4/hty8ZsXZ2mAz6BNr+66j5W/SljDIOX582/diphOPde5RAN
         Hq0+szowHI1jjmGrYIcOjQInpkyohUYwN4BFKcqg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.5 161/176] ubifs: Fix ino_t format warnings in orphan_delete()
Date:   Tue,  3 Mar 2020 18:43:45 +0100
Message-Id: <20200303174322.914285494@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174304.593872177@linuxfoundation.org>
References: <20200303174304.593872177@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

commit 155fc6ba488a8bdfd1d3be3d7ba98c9cec2b2429 upstream.

On alpha and s390x:

    fs/ubifs/debug.h:158:11: warning: format ‘%lu’ expects argument of type ‘long unsigned int’, but argument 4 has type ‘ino_t {aka unsigned int}’ [-Wformat=]
    ...
    fs/ubifs/orphan.c:132:3: note: in expansion of macro ‘dbg_gen’
       dbg_gen("deleted twice ino %lu", orph->inum);
    ...
    fs/ubifs/orphan.c:140:3: note: in expansion of macro ‘dbg_gen’
       dbg_gen("delete later ino %lu", orph->inum);

__kernel_ino_t is "unsigned long" on most architectures, but not on
alpha and s390x, where it is "unsigned int".  Hence when printing an
ino_t, it should always be cast to "unsigned long" first.

Fix this by re-adding the recently removed casts.

Fixes: 8009ce956c3d2802 ("ubifs: Don't leak orphans on memory during commit")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ubifs/orphan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ubifs/orphan.c
+++ b/fs/ubifs/orphan.c
@@ -129,7 +129,7 @@ static void __orphan_drop(struct ubifs_i
 static void orphan_delete(struct ubifs_info *c, struct ubifs_orphan *orph)
 {
 	if (orph->del) {
-		dbg_gen("deleted twice ino %lu", orph->inum);
+		dbg_gen("deleted twice ino %lu", (unsigned long)orph->inum);
 		return;
 	}
 
@@ -137,7 +137,7 @@ static void orphan_delete(struct ubifs_i
 		orph->del = 1;
 		orph->dnext = c->orph_dnext;
 		c->orph_dnext = orph;
-		dbg_gen("delete later ino %lu", orph->inum);
+		dbg_gen("delete later ino %lu", (unsigned long)orph->inum);
 		return;
 	}
 


