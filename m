Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7888CB5CB4
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730326AbfIRG0j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:26:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:48094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730332AbfIRG0g (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:26:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5246321929;
        Wed, 18 Sep 2019 06:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568787995;
        bh=FdXQ5GCxGzSD3aWt3Raz/h1pzonloyJFe+fcXM42WoI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pGlBMaMYlrWw5Z7lkcGXokMrJ25J8yFsvW/b4acZXwDdbR8vJaSsIME9lvFUrYX8u
         zPdq44WraUhoNSxuDuZ8fJ85w70yifXLAyHXTJlCH3Tw5IWUvpyBGoO//VW3X/x6Mc
         Po/DOw5rALKpnQghw11M9PiCyxcZXAETY/hGdzw0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hyunchul Lee <hyc.lee@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.2 61/85] ubifs: Correctly use tnc_next() in search_dh_cookie()
Date:   Wed, 18 Sep 2019 08:19:19 +0200
Message-Id: <20190918061236.997345935@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918061234.107708857@linuxfoundation.org>
References: <20190918061234.107708857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Richard Weinberger <richard@nod.at>

commit bacfa94b08027b9f66ede7044972e3b066766b3e upstream.

Commit c877154d307f fixed an uninitialized variable and optimized
the function to not call tnc_next() in the first iteration of the
loop. While this seemed perfectly legit and wise, it turned out to
be illegal.
If the lookup function does not find an exact match it will rewind
the cursor by 1.
The rewinded cursor will not match the name hash we are looking for
and this results in a spurious -ENOENT.
So we need to move to the next entry in case of an non-exact match,
but not if the match was exact.

While we are here, update the documentation to avoid further confusion.

Cc: Hyunchul Lee <hyc.lee@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Fixes: c877154d307f ("ubifs: Fix uninitialized variable in search_dh_cookie()")
Fixes: 781f675e2d7e ("ubifs: Fix unlink code wrt. double hash lookups")
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ubifs/tnc.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/fs/ubifs/tnc.c
+++ b/fs/ubifs/tnc.c
@@ -1158,8 +1158,8 @@ static struct ubifs_znode *dirty_cow_bot
  *   o exact match, i.e. the found zero-level znode contains key @key, then %1
  *     is returned and slot number of the matched branch is stored in @n;
  *   o not exact match, which means that zero-level znode does not contain
- *     @key, then %0 is returned and slot number of the closest branch is stored
- *     in @n;
+ *     @key, then %0 is returned and slot number of the closest branch or %-1
+ *     is stored in @n; In this case calling tnc_next() is mandatory.
  *   o @key is so small that it is even less than the lowest key of the
  *     leftmost zero-level node, then %0 is returned and %0 is stored in @n.
  *
@@ -1882,13 +1882,19 @@ int ubifs_tnc_lookup_nm(struct ubifs_inf
 
 static int search_dh_cookie(struct ubifs_info *c, const union ubifs_key *key,
 			    struct ubifs_dent_node *dent, uint32_t cookie,
-			    struct ubifs_znode **zn, int *n)
+			    struct ubifs_znode **zn, int *n, int exact)
 {
 	int err;
 	struct ubifs_znode *znode = *zn;
 	struct ubifs_zbranch *zbr;
 	union ubifs_key *dkey;
 
+	if (!exact) {
+		err = tnc_next(c, &znode, n);
+		if (err)
+			return err;
+	}
+
 	for (;;) {
 		zbr = &znode->zbranch[*n];
 		dkey = &zbr->key;
@@ -1930,7 +1936,7 @@ static int do_lookup_dh(struct ubifs_inf
 	if (unlikely(err < 0))
 		goto out_unlock;
 
-	err = search_dh_cookie(c, key, dent, cookie, &znode, &n);
+	err = search_dh_cookie(c, key, dent, cookie, &znode, &n, err);
 
 out_unlock:
 	mutex_unlock(&c->tnc_mutex);
@@ -2723,7 +2729,7 @@ int ubifs_tnc_remove_dh(struct ubifs_inf
 		if (unlikely(err < 0))
 			goto out_free;
 
-		err = search_dh_cookie(c, key, dent, cookie, &znode, &n);
+		err = search_dh_cookie(c, key, dent, cookie, &znode, &n, err);
 		if (err)
 			goto out_free;
 	}


