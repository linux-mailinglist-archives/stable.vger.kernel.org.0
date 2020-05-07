Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3DC41C9D31
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 23:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726533AbgEGVWI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 17:22:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:45772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726218AbgEGVWI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 17:22:08 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C644820731;
        Thu,  7 May 2020 21:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588886527;
        bh=FTITSTKPQuycySM9HS4+Xt+5yD+fEP6AjWs4CJ3BF14=;
        h=Date:From:To:Subject:From;
        b=YFe60Y13rDB9RXwjoTWB4gW2N9apraAxhmtVGUbSQ7Y7rPQbtWehLqXRFOQdYAavV
         9/FVOUO5TVAVmi/Cz0kX2czuSJoAXt6VDvmw2lI6vln7hgCVdKNYwDv1w1UpC3qMOR
         GMXl4hbFYv9itpIjZgmDwfo0Sm/fj4T1Q4snlgOc=
Date:   Thu, 07 May 2020 14:22:06 -0700
From:   akpm@linux-foundation.org
To:     dave.rodgman@arm.com, mark.rutland@arm.com, markus@oberhumer.com,
        minchan@kernel.org, mm-commits@vger.kernel.org, ngupta@vflare.org,
        sergey.senozhatsky.work@gmail.com, stable@vger.kernel.org,
        w@1wt.eu, yuchao0@huawei.com
Subject:  + lib-lzo-fix-ambiguous-encoding-bug-in-lzo-rle.patch
 added to -mm tree
Message-ID: <20200507212206.wBl9QmMsn%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: lib/lzo: fix ambiguous encoding bug in lzo-rle
has been added to the -mm tree.  Its filename is
     lib-lzo-fix-ambiguous-encoding-bug-in-lzo-rle.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-lzo-fix-ambiguous-encoding-bug-in-lzo-rle.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-lzo-fix-ambiguous-encoding-bug-in-lzo-rle.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dave Rodgman <dave.rodgman@arm.com>
Subject: lib/lzo: fix ambiguous encoding bug in lzo-rle

In some rare cases, for input data over 32 KB, lzo-rle could encode two
different inputs to the same compressed representation, so that
decompression is then ambiguous (i.e.  data may be corrupted - although
zram is not affected because it operates over 4 KB pages).

This modifies the compressor without changing the decompressor or the
bitstream format, such that:

- there is no change to how data produced by the old compressor is
  decompressed

- an old decompressor will correctly decode data from the updated
  compressor

- performance and compression ratio are not affected

- we avoid introducing a new bitstream format

In testing over 12.8M real-world files totalling 903 GB, three files were
affected by this bug.  I also constructed 37M semi-random 64 KB files
totalling 2.27 TB, and saw no affected files.  Finally I tested over files
constructed to contain each of the ~1024 possible bad input sequences; for
all of these cases, updated lzo-rle worked correctly.

There is no significant impact to performance or compression ratio.

Link: http://lkml.kernel.org/r/20200507100203.29785-1-dave.rodgman@arm.com
Signed-off-by: Dave Rodgman <dave.rodgman@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Dave Rodgman <dave.rodgman@arm.com>
Cc: Willy Tarreau <w@1wt.eu>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: Markus F.X.J. Oberhumer <markus@oberhumer.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Chao Yu <yuchao0@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/lzo.txt    |    8 ++++++--
 lib/lzo/lzo1x_compress.c |   13 +++++++++++++
 2 files changed, 19 insertions(+), 2 deletions(-)

--- a/Documentation/lzo.txt~lib-lzo-fix-ambiguous-encoding-bug-in-lzo-rle
+++ a/Documentation/lzo.txt
@@ -159,11 +159,15 @@ Byte sequences
            distance = 16384 + (H << 14) + D
            state = S (copy S literals after this block)
            End of stream is reached if distance == 16384
+           In version 1 only, to prevent ambiguity with the RLE case when
+           ((distance & 0x803f) == 0x803f) && (261 <= length <= 264), the
+           compressor must not emit block copies where distance and length
+           meet these conditions.
 
         In version 1 only, this instruction is also used to encode a run of
-        zeros if distance = 0xbfff, i.e. H = 1 and the D bits are all 1.
+           zeros if distance = 0xbfff, i.e. H = 1 and the D bits are all 1.
            In this case, it is followed by a fourth byte, X.
-           run length = ((X << 3) | (0 0 0 0 0 L L L)) + 4.
+           run length = ((X << 3) | (0 0 0 0 0 L L L)) + 4
 
       0 0 1 L L L L L  (32..63)
            Copy of small block within 16kB distance (preferably less than 34B)
--- a/lib/lzo/lzo1x_compress.c~lib-lzo-fix-ambiguous-encoding-bug-in-lzo-rle
+++ a/lib/lzo/lzo1x_compress.c
@@ -268,6 +268,19 @@ m_len_done:
 				*op++ = (M4_MARKER | ((m_off >> 11) & 8)
 						| (m_len - 2));
 			else {
+				if (unlikely(((m_off & 0x403f) == 0x403f)
+						&& (m_len >= 261)
+						&& (m_len <= 264))
+						&& likely(bitstream_version)) {
+					// Under lzo-rle, block copies
+					// for 261 <= length <= 264 and
+					// (distance & 0x80f3) == 0x80f3
+					// can result in ambiguous
+					// output. Adjust length
+					// to 260 to prevent ambiguity.
+					ip -= m_len - 260;
+					m_len = 260;
+				}
 				m_len -= M4_MAX_LEN;
 				*op++ = (M4_MARKER | ((m_off >> 11) & 8));
 				while (unlikely(m_len > 255)) {
_

Patches currently in -mm which might be from dave.rodgman@arm.com are

lib-lzo-fix-ambiguous-encoding-bug-in-lzo-rle.patch

