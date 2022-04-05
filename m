Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C34C64F2AD0
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350723AbiDEJ7e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:59:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344204AbiDEJSi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:18:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0DD51CFF4;
        Tue,  5 Apr 2022 02:05:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7603FB81BAE;
        Tue,  5 Apr 2022 09:05:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D53B7C385A1;
        Tue,  5 Apr 2022 09:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149533;
        bh=IECC3XuBdG5GLST7u+ger1qa2WxBbPkq2C29u83lBFo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t1J08TPrdaRfZt5b6Be4/viNk6Pt6JvK0XJs/OW+3tn+BfyLCjz1w8zauFhR9T5bj
         MWenyQJKTGvv1hKemW1vfdqHWDIsHvq8L5nQ05zds4hk5TQmY/HRBTevLNOzcr0FkW
         M0XsMjMvCBUXucWVMFq+kI2vhLIfCCAj6zlMpU2I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fedor Pchelkin <aissur0002@gmail.com>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Christian Brauner <brauner@kernel.org>
Subject: [PATCH 5.16 0748/1017] fs: fd tables have to be multiples of BITS_PER_LONG
Date:   Tue,  5 Apr 2022 09:27:41 +0200
Message-Id: <20220405070416.463926404@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 1c24a186398f59c80adb9a967486b65c1423a59d ]

This has always been the rule: fdtables have several bitmaps in them,
and as a result they have to be sized properly for bitmaps.  We walk
those bitmaps in chunks of 'unsigned long' in serveral cases, but even
when we don't, we use the regular kernel bitops that are defined to work
on arrays of 'unsigned long', not on some byte array.

Now, the distinction between arrays of bytes and 'unsigned long'
normally only really ends up being noticeable on big-endian systems, but
Fedor Pchelkin and Alexey Khoroshilov reported that copy_fd_bitmaps()
could be called with an argument that wasn't even a multiple of
BITS_PER_BYTE.  And then it fails to do the proper copy even on
little-endian machines.

The bug wasn't in copy_fd_bitmap(), but in sane_fdtable_size(), which
didn't actually sanitize the fdtable size sufficiently, and never made
sure it had the proper BITS_PER_LONG alignment.

That's partly because the alignment historically came not from having to
explicitly align things, but simply from previous fdtable sizes, and
from count_open_files(), which counts the file descriptors by walking
them one 'unsigned long' word at a time and thus naturally ends up doing
sizing in the proper 'chunks of unsigned long'.

But with the introduction of close_range(), we now have an external
source of "this is how many files we want to have", and so
sane_fdtable_size() needs to do a better job.

This also adds that explicit alignment to alloc_fdtable(), although
there it is mainly just for documentation at a source code level.  The
arithmetic we do there to pick a reasonable fdtable size already aligns
the result sufficiently.

In fact,clang notices that the added ALIGN() in that function doesn't
actually do anything, and does not generate any extra code for it.

It turns out that gcc ends up confusing itself by combining a previous
constant-sized shift operation with the variable-sized shift operations
in roundup_pow_of_two().  And probably due to that doesn't notice that
the ALIGN() is a no-op.  But that's a (tiny) gcc misfeature that doesn't
matter.  Having the explicit alignment makes sense, and would actually
matter on a 128-bit architecture if we ever go there.

This also adds big comments above both functions about how fdtable sizes
have to have that BITS_PER_LONG alignment.

Fixes: 60997c3d45d9 ("close_range: add CLOSE_RANGE_UNSHARE")
Reported-by: Fedor Pchelkin <aissur0002@gmail.com>
Reported-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Link: https://lore.kernel.org/all/20220326114009.1690-1-aissur0002@gmail.com/
Tested-and-acked-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/file.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/fs/file.c b/fs/file.c
index 97d212a9b814..c01c29417ae6 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -87,6 +87,21 @@ static void copy_fdtable(struct fdtable *nfdt, struct fdtable *ofdt)
 	copy_fd_bitmaps(nfdt, ofdt, ofdt->max_fds);
 }
 
+/*
+ * Note how the fdtable bitmap allocations very much have to be a multiple of
+ * BITS_PER_LONG. This is not only because we walk those things in chunks of
+ * 'unsigned long' in some places, but simply because that is how the Linux
+ * kernel bitmaps are defined to work: they are not "bits in an array of bytes",
+ * they are very much "bits in an array of unsigned long".
+ *
+ * The ALIGN(nr, BITS_PER_LONG) here is for clarity: since we just multiplied
+ * by that "1024/sizeof(ptr)" before, we already know there are sufficient
+ * clear low bits. Clang seems to realize that, gcc ends up being confused.
+ *
+ * On a 128-bit machine, the ALIGN() would actually matter. In the meantime,
+ * let's consider it documentation (and maybe a test-case for gcc to improve
+ * its code generation ;)
+ */
 static struct fdtable * alloc_fdtable(unsigned int nr)
 {
 	struct fdtable *fdt;
@@ -102,6 +117,7 @@ static struct fdtable * alloc_fdtable(unsigned int nr)
 	nr /= (1024 / sizeof(struct file *));
 	nr = roundup_pow_of_two(nr + 1);
 	nr *= (1024 / sizeof(struct file *));
+	nr = ALIGN(nr, BITS_PER_LONG);
 	/*
 	 * Note that this can drive nr *below* what we had passed if sysctl_nr_open
 	 * had been set lower between the check in expand_files() and here.  Deal
@@ -269,11 +285,25 @@ static unsigned int count_open_files(struct fdtable *fdt)
 	return i;
 }
 
+/*
+ * Note that a sane fdtable size always has to be a multiple of
+ * BITS_PER_LONG, since we have bitmaps that are sized by this.
+ *
+ * 'max_fds' will normally already be properly aligned, but it
+ * turns out that in the close_range() -> __close_range() ->
+ * unshare_fd() -> dup_fd() -> sane_fdtable_size() we can end
+ * up having a 'max_fds' value that isn't already aligned.
+ *
+ * Rather than make close_range() have to worry about this,
+ * just make that BITS_PER_LONG alignment be part of a sane
+ * fdtable size. Becuase that's really what it is.
+ */
 static unsigned int sane_fdtable_size(struct fdtable *fdt, unsigned int max_fds)
 {
 	unsigned int count;
 
 	count = count_open_files(fdt);
+	max_fds = ALIGN(max_fds, BITS_PER_LONG);
 	if (max_fds < NR_OPEN_DEFAULT)
 		max_fds = NR_OPEN_DEFAULT;
 	return min(count, max_fds);
-- 
2.34.1



