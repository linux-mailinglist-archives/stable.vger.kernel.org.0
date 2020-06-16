Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF051FB91C
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731744AbgFPQBY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 12:01:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:49302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732756AbgFPPwL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:52:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D51EA21532;
        Tue, 16 Jun 2020 15:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322730;
        bh=QIcS73uwgRHW6LMWNWdiRKdRJrtAF/id/hyM7AUDHKc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K0xxvKTobU7FVyAxZ6MnYZU63aWYEtNynGufKWi54CGprHgfQqIsbhfjVgqMuPoRT
         YFAha6uNq1rKVnJ3ZFs457BRCowM1cLZSTstyLvERJ8tWhsrq3d0oGxfaMge/iyQaV
         phBDEBszhtOuDFqSBrEW80l1DjrxocHxOVA6MUWI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Rodgman <dave.rodgman@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mark Rutland <mark.rutland@arm.com>, Willy Tarreau <w@1wt.eu>,
        Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        "Markus F.X.J. Oberhumer" <markus@oberhumer.com>,
        Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>, Chao Yu <yuchao0@huawei.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.6 082/161] lib/lzo: fix ambiguous encoding bug in lzo-rle
Date:   Tue, 16 Jun 2020 17:34:32 +0200
Message-Id: <20200616153110.284300762@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.402291280@linuxfoundation.org>
References: <20200616153106.402291280@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Rodgman <dave.rodgman@arm.com>

commit b5265c813ce4efbfa2e46fd27cdf9a7f44a35d2e upstream.

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

In testing over 12.8M real-world files totalling 903 GB, three files
were affected by this bug.  I also constructed 37M semi-random 64 KB
files totalling 2.27 TB, and saw no affected files.  Finally I tested
over files constructed to contain each of the ~1024 possible bad input
sequences; for all of these cases, updated lzo-rle worked correctly.

There is no significant impact to performance or compression ratio.

Signed-off-by: Dave Rodgman <dave.rodgman@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Dave Rodgman <dave.rodgman@arm.com>
Cc: Willy Tarreau <w@1wt.eu>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: Markus F.X.J. Oberhumer <markus@oberhumer.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Chao Yu <yuchao0@huawei.com>
Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/r/20200507100203.29785-1-dave.rodgman@arm.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/lzo.txt    |    8 ++++++--
 lib/lzo/lzo1x_compress.c |   13 +++++++++++++
 2 files changed, 19 insertions(+), 2 deletions(-)

--- a/Documentation/lzo.txt
+++ b/Documentation/lzo.txt
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
--- a/lib/lzo/lzo1x_compress.c
+++ b/lib/lzo/lzo1x_compress.c
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


